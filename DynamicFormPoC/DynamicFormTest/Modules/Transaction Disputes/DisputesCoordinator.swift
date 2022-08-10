import XCoordinator
import UIKit
import SwiftUI

enum DisputesRoute: Route {
    case select
    case form(DisputeForm)
    case tip
    case success
}

final class DisputesCoordinator: NavigationCoordinator<DisputesRoute> {
    
    // MARK: NavigationCoordinator
    override func prepareTransition(for route: DisputesRoute) -> NavigationTransition {
        switch route {
        case .select:
            return .set([makeDisputeSelectScreen()])
        case .form(let disputeForm):
            return .push(makeDisputeFormScreen(disputeForm: disputeForm))
        case .tip:
            return .present(makeTipScreen())
        case .success:
            return .push(makeSuccessScreen())
        }
    }
}

// MARK: - Private Methods
private extension DisputesCoordinator {
    func makeDisputeSelectScreen() -> UIViewController {
        let viewModel = DisputeSelectViewModel(router: weakRouter)
        let controller = UIHostingController(rootView: DisputeSelectView(viewModel: viewModel))
        controller.title = "Dispute Transaction"
        return controller
    }
    
    func makeDisputeFormScreen(disputeForm: DisputeForm) -> UIViewController {
        let viewModel = DisputeFormViewModel(disputeForm: disputeForm)
        let controller = UIHostingController(rootView: DisputeFormView(viewModel: viewModel))
        controller.title = "Dispute"
        return controller
    }
    
    func makeTipScreen() -> UIViewController {
        return UIViewController()
    }
    
    func makeSuccessScreen() -> UIViewController {
        return UIViewController()
    }
}
