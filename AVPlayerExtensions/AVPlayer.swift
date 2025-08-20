import AVFoundation
import Combine
import Foundation

// MARK: - Helpers

extension AVPlayer {
    /// Seeks to the beginning of the current item and begins playing.
    func restart() {
        seek(to: .zero)
        play()
    }
    
    /// Returns whether the current item has audio tracks. Will only return accurate data once the duration of the player has been populated.
    var hasAudio: Bool {
        currentItem?.tracks.compactMap(\.assetTrack).contains { $0.mediaType == .audio } ?? false
    }
    
    /// Returns the duration of the current item only if it is non-nil and non-NaN.
    var validDuration: Double? {
        guard let duration = currentItem?.duration.seconds, !duration.isNaN else {
            return nil
        }
        return duration
    }
}

// MARK: - Basic Player Publishers

extension AVPlayer {
    var durationPublisher: AnyPublisher<Double?, Never> {
        publisher(for: \.currentItem?.duration)
            .map { $0?.seconds }
            .replaceError(with: nil)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    func periodicTimePublisher(interval: Double) -> AnyPublisher<Double, Never> {
        PeriodicTimePublisher(player: self, interval: .init(seconds: interval, preferredTimescale: .init(NSEC_PER_SEC)))
            .map(\.seconds)
            .prepend(0.0)
            .eraseToAnyPublisher()
    }
    
    var timeControlStatusPublisher: AnyPublisher<AVPlayer.TimeControlStatus, Never> {
        publisher(for: \.timeControlStatus)
            .replaceError(with: .waitingToPlayAtSpecifiedRate)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    var statusPublisher: AnyPublisher<AVPlayer.Status, Never> {
        publisher(for: \.status)
            .replaceError(with: .unknown)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}

// MARK: - Player Progress

extension AVPlayer {
    func playerProgressPublisher(interval: Double) -> AnyPublisher<Double, Never> {
        durationPublisher.combineLatest(
            periodicTimePublisher(interval: interval)
        )
        .map { Self.playerProgress(duration: $0, periodicTime: $1) }
        .eraseToAnyPublisher()
    }
    
    static func playerProgress(duration: Double?, periodicTime: Double) -> Double {
        guard let duration, duration > 0 else { return 0 }
        return max(0, min(1, periodicTime / duration))
    }
}

// MARK: - Player State

enum VideoPlayerState: Equatable {
    /// Represents the initial loading state of the player.
    case loading
    
    /// Represents an error state.
    case error
    
    /// Represents the player being ready, unfinished, but paused.
    case paused
    
    /// Represents the player loading after initial playback.
    case stalled
    
    /// Represents the player playing.
    case playing
    
    /// Represents the player having finished playing its video.
    case finished
}

extension AVPlayer {
    var playerState: VideoPlayerState {
        Self.playerState(
            duration: currentItem?.duration.seconds,
            periodicTime: currentTime().seconds,
            timeControlStatus: timeControlStatus,
            status: status
        )
    }
    
    var playerStatePublisher: AnyPublisher<VideoPlayerState, Never> {
        durationPublisher.combineLatest(
            periodicTimePublisher(interval: 1.0),
            timeControlStatusPublisher,
            statusPublisher
        )
        .map { values -> VideoPlayerState in
            let (duration, periodicTime, timeControlStatus, status) = values
            return Self.playerState(
                duration: duration,
                periodicTime: periodicTime,
                timeControlStatus: timeControlStatus,
                status: status
            )
        }
        .prepend(playerState)
        .removeDuplicates()
        .eraseToAnyPublisher()
    }
    
    static func playerState(duration: Double?, periodicTime: Double, timeControlStatus: TimeControlStatus, status: Status) -> VideoPlayerState {
        guard status != .unknown else { return .loading }
        guard timeControlStatus != .waitingToPlayAtSpecifiedRate else { return .stalled }
        guard status != .failed else { return .error }
        if timeControlStatus == .playing {
            return .playing
        } else {
            if let duration, !duration.isNaN, periodicTime >= duration {
                return .finished
            } else {
                return .paused
            }
        }
    }
}

// MARK: - Periodic Time Publisher

extension AVPlayer {
    private struct PeriodicTimePublisher: Publisher {
        typealias Output = CMTime
        typealias Failure = Never
        
        var player: AVPlayer
        var interval: CMTime
        
        init(player: AVPlayer, interval: CMTime) {
            self.player = player
            self.interval = interval
        }
        
        func receive<S>(subscriber: S) where S: Subscriber, S.Input == Output, S.Failure == Failure {
            let subscription = CMTime.Subscription(subscriber: subscriber, player: player, forInterval: interval)
            subscriber.receive(subscription: subscription)
        }
    }
}

private extension CMTime {
    final class Subscription<SubscriberType: Subscriber>: Combine.Subscription where SubscriberType.Input == CMTime, SubscriberType.Failure == Never {
        var player: AVPlayer?
        var observer: Any?

        init(subscriber: SubscriberType, player: AVPlayer, forInterval interval: CMTime) {
            self.player = player
            self.observer = player.addPeriodicTimeObserver(forInterval: interval, queue: nil) { time in
                _ = subscriber.receive(time)
            }
        }

        // We have no demand, and simply wait for events to trigger.
        func request(_ demand: Subscribers.Demand) {}

        func cancel() {
            if let observer {
                player?.removeTimeObserver(observer)
            }
            observer = nil
            player = nil
        }
    }
}
