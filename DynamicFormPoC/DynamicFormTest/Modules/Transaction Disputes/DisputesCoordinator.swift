import XCoordinator
import UIKit
import SwiftUI

enum DisputesRoute: Route {
    case select
    case form(DisputeForm)
    case tip
    case tipDismiss
    case success
}

final class DisputesCoordinator: NavigationCoordinator<DisputesRoute> {
    
    // MARK: NavigationCoordinator
    override func prepareTransition(for route: DisputesRoute) -> NavigationTransition {
        rootViewController.modalPresentationStyle = .fullScreen
        switch route {
        case .select:
            return .set([makeDisputeSelectScreen()])
        case .form(let disputeForm):
            return .push(makeDisputeFormScreen(disputeForm: disputeForm))
        case .tip:
            return .present(makeTipScreen())
        case .tipDismiss:
            return .dismiss()
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
        let viewModel = DisputeFormViewModel(router: weakRouter, disputeForm: disputeForm)
        let controller = UIHostingController(rootView: DisputeFormView(viewModel: viewModel))
        controller.title = "Dispute"
        return controller
    }
    
    func makeTipScreen() -> UIViewController {
        let viewModel = DisputeTipViewModel(router: weakRouter)
        let controller = UIHostingController(rootView: DisputeTipView(viewModel: viewModel))
        controller.title = ""
        return controller
    }
    
    func makeSuccessScreen() -> UIViewController {
        return UIViewController()
    }
}
