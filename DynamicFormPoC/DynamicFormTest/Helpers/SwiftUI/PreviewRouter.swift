import XCoordinator
import UIKit

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
