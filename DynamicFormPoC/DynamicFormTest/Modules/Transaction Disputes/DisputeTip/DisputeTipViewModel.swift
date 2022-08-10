import Foundation
import Combine
import XCoordinator

final class DisputeTipViewModel: ObservableObject {
    // MARK: Properties
    private let router: WeakRouter<DisputesRoute>
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Init
    init(router: WeakRouter<DisputesRoute>) {
        self.router = router
    }
}

extension DisputeTipViewModel: BindableViewModel {
    struct Inputs {
        let closeButtonTaps: AnyPublisher<Void, Never>
        let primaryButtonTaps: AnyPublisher<Void, Never>
    }
    
    func bind(inputs: Inputs) {
        setUpSubscriptions(inputs: inputs)
    }
}

private extension DisputeTipViewModel {
    func setUpSubscriptions(inputs: Inputs) {
        Publishers.Merge(inputs.closeButtonTaps, inputs.primaryButtonTaps)
            .sink(receiveValue: { [weak self] _ in
                self?.router.trigger(.tipDismiss)
            })
            .store(in: &cancellables)
    }
}
