//
//  RootCoordinator.swift.swift
//  MVVM+RxSwift Example
//
//  Created by Jaron Lowe on 11/25/21.
//

import UIKit
import XCoordinator

enum AppRoute: Route {
    case peopleList
    case filters
}

final class RootCoordinator: NavigationCoordinator<AppRoute> {
 
    // MARK: Init
    
    init() {
        super.init(initialRoute: .peopleList)
    }
    
    // MARK: Overrides
    
    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        switch route {
        case .peopleList:
            return .push(makePeopleListController())
        case .filters:
            return .present(makeFiltersController())
        }
    }
}

private extension RootCoordinator {
    
    func makeController<T: UIViewController>() -> T {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: String(describing: T.self)) as? T else {
            fatalError("Could not instantiate storyboard controller.")
        }
        return controller
    }
    
    func makePeopleListController() -> PeopleListViewController {
        let controller: PeopleListViewController = makeController()
        controller.viewModel = PeopleListViewModel(router: weakRouter)
        return controller
    }
    
    func makeFiltersController() -> FiltersViewController {
        let controller: FiltersViewController = makeController()
        return controller
    }
}
