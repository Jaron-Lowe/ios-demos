import Foundation
import Combine

class DisputeSelectViewModel: ObservableObject {
    // MARK: Properties
    @Published private(set) var disputeOptions: [DisputeForm] = DisputeForm.allCases
    
    private var cancellables = Set<AnyCancellable>()
    // MARK: Init
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
            .sink { option in
                SceneDelegate.proccedToDisputeForm(disputeForm: option)
            }
            .store(in: &cancellables)
    }
    
    // MARK: Outputs
    
    
}
