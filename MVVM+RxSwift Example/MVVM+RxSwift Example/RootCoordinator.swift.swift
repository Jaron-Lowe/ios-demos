//
//  RootCoordinator.swift.swift
//  MVVM+RxSwift Example
//
//  Created by Jaron Lowe on 11/25/21.
//

import UIKit
import XCoordinator
import RxRelay

enum AppRoute: Route {
    case peopleList
    case filters(BehaviorRelay<PeopleFilters>)
    case filtersDone
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
        case .filters(let filtersBridgeRelay):
            return .present(makeFiltersController(filtersBridgeRelay: filtersBridgeRelay))
        case .filtersDone:
            return .dismiss()
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
        controller.viewModel = PeopleListViewModel(router: weakRouter, peopleService: PeopleService())
        return controller
    }
    
    func makeFiltersController(filtersBridgeRelay: BehaviorRelay<PeopleFilters>) -> FiltersViewController {
        let controller: FiltersViewController = makeController()
        controller.viewModel = FiltersViewModel(router: weakRouter, filtersBridgeRelay: filtersBridgeRelay)
        return controller
    }
}
