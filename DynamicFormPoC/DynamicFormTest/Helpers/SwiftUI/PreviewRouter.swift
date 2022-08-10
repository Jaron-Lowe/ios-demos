import XCoordinator
import UIKit

/// Used as a dummy router for viewModels required in SwiftUI Preview Providers 
final class PreviewRouter<RouteType: Route>: Router {
    var currentRoute: RouteType?
    var viewController: UIViewController!
    
    func contextTrigger(_ route: RouteType, with options: TransitionOptions, completion: ContextPresentationHandler?) {
        currentRoute = route
    }
    
    var weakRouter: WeakRouter<RouteType> {
        return WeakRouter(self) { $0.strongRouter }
    }
}
