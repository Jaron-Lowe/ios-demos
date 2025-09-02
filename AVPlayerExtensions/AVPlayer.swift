import AVFoundation
import Combine
import Foundation

// MARK: - Helpers

extension AVPlayer {
    /// Returns whether the current item has audio tracks. Will only return accurate data once the duration of the player has been populated.
    public var hasAudio: Bool {
        currentItem?.tracks.compactMap(\.assetTrack).contains { $0.mediaType == .audio } ?? false
    }
    
    /// Returns the duration of the current item only if it is non-nil and non-NaN.
    public var validDuration: Double? {
        guard let duration = currentItem?.duration.seconds, !duration.isNaN else {
            return nil
        }
        return duration
    }
    
    /// Seeks to the beginning of the current item and begins playing.
    public func restart() {
        seek(to: .zero)
        play()
    }
    
    /// Seeks to the beginning of the current item and pauses.
    public func reset() {
        seek(to: .zero)
        pause()
    }
}

// MARK: - Basic Player Publishers

extension AVPlayer {
    /// A publisher of changes to an AVPlayer's duration.
    public var durationPublisher: AnyPublisher<Double?, Never> {
        publisher(for: \.currentItem?.duration)
            .map { $0?.seconds }
            .replaceError(with: nil)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    
    /// A publisher that fires periodically as an AVPlayer plays.
    /// - Parameter interval: The interval for which to report video playback
    /// - Returns: A publisher that fires periodically as an AVPlayer plays.
    func periodicTimePublisher(interval: Double) -> AnyPublisher<Double, Never> {
        PeriodicTimePublisher(player: self, interval: .init(seconds: interval, preferredTimescale: .init(NSEC_PER_SEC)))
            .map(\.seconds)
            .prepend(0.0)
            .eraseToAnyPublisher()
    }
    
    /// A publisher of changes to an AVPlayer's time control status.
    var timeControlStatusPublisher: AnyPublisher<AVPlayer.TimeControlStatus, Never> {
        publisher(for: \.timeControlStatus)
            .replaceError(with: .waitingToPlayAtSpecifiedRate)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    /// A publisher of changes to an AVPlayer's status.
    var statusPublisher: AnyPublisher<AVPlayer.Status, Never> {
        publisher(for: \.status)
            .replaceError(with: .unknown)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}

// MARK: - Player Progress

extension AVPlayer {
    /// A publisher of changes to an AVPlayer's playback progress percentage.
    /// - Parameter interval: The rate at which player progress should be reported.
    /// - Returns: A publisher of changes to an AVPlayer's playback progress.
    public func playerProgressPublisher(interval: Double) -> AnyPublisher<Double, Never> {
        durationPublisher.combineLatest(
            periodicTimePublisher(interval: interval)
        )
        .map { Self.playerProgress(duration: $0, periodicTime: $1) }
        .eraseToAnyPublisher()
    }
    
    /// A publisher that triggers when the player progress clears requested completion percentage gates.
    /// - Parameters:
    ///   - percentGates: A set of playback completion percentages to trigger events for.
    ///   - interval: The rate at which completion gates should be polled.
    /// - Returns: A publisher that triggers when the player progress clears requested completion percentage gates.
    public func completionGatesClearedPublisher(percentGates: Set<Double>, interval: Double = 1.0) -> AnyPublisher<Double, Never> {
        let percentGates = percentGates.sorted()
        return playerProgressPublisher(interval: interval)
            .scan((Set<Double>(), Set<Double>())) { state, latestPercent in
                let (alreadyCleared, _) = state
                var toBroadcast = Set<Double>()
                for gate in percentGates {
                    if !alreadyCleared.contains(gate) && latestPercent >= gate {
                        toBroadcast.insert(gate)
                    }
                }
                return (alreadyCleared.union(toBroadcast), toBroadcast)
            }
            .compactMap { state -> Set<Double>? in
                let (_, toBroadcast) = state
                guard !toBroadcast.isEmpty else { return nil }
                return toBroadcast
            }
            .flatMap { toBroadcast in
                toBroadcast.publisher
            }
            .eraseToAnyPublisher()
    }
    
    static func playerProgress(duration: Double?, periodicTime: Double) -> Double {
        guard let duration, duration > 0 else { return 0 }
        return max(0, min(1, periodicTime / duration))
    }
}

// MARK: - Player State

/// Represents the state that a video player can be in.
public enum VideoPlayerState: Equatable {
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
    /// The current state of a video player.
    public var playerState: VideoPlayerState {
        Self.playerState(
            duration: currentItem?.duration.seconds,
            periodicTime: currentTime().seconds,
            timeControlStatus: timeControlStatus,
            status: status
        )
    }
    
    /// A publisher of changes to an AVPlayer's player state.
    public var playerStatePublisher: AnyPublisher<VideoPlayerState, Never> {
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
