import Foundation
import Combine
import XCoordinator

class DisputeSelectViewModel: ObservableObject {
    // MARK: Properties
    @Published private(set) var disputeOptions: [DisputeForm] = DisputeForm.allCases
    
    private let router: WeakRouter<DisputesRoute>
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Init
    init(router: WeakRouter<DisputesRoute>) {
        self.router = router
    }
}

extension DisputeSelectViewModel: BindableViewModel {
    struct Inputs {
        let disputeOptionTaps: AnyPublisher<DisputeForm, Never>
    }
    
    func bind(inputs: Inputs) {
        setUpSubscriptions(inputs: inputs)
    }
}

private extension DisputeSelectViewModel {
    // MARK: Subscriptions
    func setUpSubscriptions(inputs: Inputs) {
        inputs.disputeOptionTaps
            .print("--- disputeOptionTaps")
            .sink { [weak self] option in
                self?.router.trigger(.form(option))
            }
            .store(in: &cancellables)
    }
    
    // MARK: Outputs
    
    
}
