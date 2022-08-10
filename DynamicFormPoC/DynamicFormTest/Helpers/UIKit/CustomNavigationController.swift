import UIKit

final class CustomNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backImage = UIImage(systemName: "arrow.left")!
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
        
        let barAppearance = UINavigationBar.appearance(whenContainedInInstancesOf: [CustomNavigationController.self])
        barAppearance.standardAppearance = navBarAppearance
        barAppearance.compactAppearance = navBarAppearance
        barAppearance.scrollEdgeAppearance = navBarAppearance
        barAppearance.tintColor = .primary500
        barAppearance.isTranslucent = false
        barAppearance.barTintColor = .systemBackground

        delegate = self
    }
   
}


// MARK: - UINavigationControllerDelegate
extension CustomNavigationController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(
            title: nil,
            style: .plain,
            target: nil,
            action: nil
        )
    }
}
