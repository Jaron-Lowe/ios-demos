//
//  PeopleListViewModel.swift
//  MVVM+RxSwift Example
//
//  Created by Jaron Lowe on 11/18/21.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import XCoordinator
import XCoordinatorRx

final class PeopleListViewModel {
    
    // MARK: Properties
    private let router: WeakRouter<AppRoute>
    private let peopleService: PeopleServicing
    
    private let filtersRelay: BehaviorRelay<PeopleFilters> = BehaviorRelay(value: .defaultFilters)
    
    private let disposeBag = DisposeBag()
    
    // MARK: Init
    
    init(router: WeakRouter<AppRoute>, peopleService: PeopleServicing) {
        self.router = router
        self.peopleService = peopleService
    }
    
}

// A: tap<Void> --> triggerRoute<PeopleFilters> --> scan<PeopleFilters>.startWith(.default)
// B: text<String>
// C: combineLatest(A, B) --> flatMapLatest<Result<[Person]>>

// loadingIndicatorIsHidden:    isLoading --> map<Bool>
// tableItems:                  C --> map<[Person]>
// emptyLabelIsHidden:          tableItems --> map<Bool>
// errorToDisplay:              C -> map<Error>

// MARK: - ViewModel

extension PeopleListViewModel: ViewModel {
    
    struct Inputs {
        let filterButtonTaps: Observable<Void>
        let tableRefreshes: Observable<Void>
    }
    
    struct Outputs {
        let loadingIndicatorIsHidden: Driver<Bool>
        let tableItems: Driver<[Person]>
        let emptyLabelIsHidden: Driver<Bool>
        let errorToDisplay: Driver<Error>
    }
    
    func transform(_ inputs: Inputs) -> Outputs {
        let fetchPeopleObservable = fetchPeople(inputs: inputs)
        let tableData = tableItems(fetchObservable: fetchPeopleObservable)
        setUpActions(inputs: inputs)
        
        return Outputs(
            loadingIndicatorIsHidden: loadingIndicatorIsHidden(inputs: inputs, fetchObservable: fetchPeopleObservable),
            tableItems: tableData,
            emptyLabelIsHidden: emptyLabelIsHidden(tableItems: tableData),
            errorToDisplay: errorToDisplay(fetchObservable: fetchPeopleObservable)
        )
    }
    
}

// MARK: - Private Methods

private extension PeopleListViewModel {
    
    // MARK: Actions
    
    func setUpActions(inputs: Inputs) {
        inputs.filterButtonTaps
            .subscribe(onNext: {[weak self] _ in
                self?.triggerFiltersRoute()
            })
            .disposed(by: disposeBag)
    }
    
    func triggerFiltersRoute() {
        router.trigger(.filters(filtersRelay))
    }
    
    // MARK: Partial Observables
    
    func fetchPeople(inputs: Inputs) -> Observable<Result<[Person], Error>> {
        return Observable.merge(filtersRelay.mapToVoid(), inputs.tableRefreshes)
            .withLatestFrom(filtersRelay)
            .flatMapLatest { [peopleService = self.peopleService] filters in
                peopleService.getPeople(filters: filters)
            }
            .share()
    }

    // MARK: Drivers
    
    func loadingIndicatorIsHidden(inputs: Inputs, fetchObservable: Observable<Result<[Person], Error>>) -> Driver<Bool> {
        return Observable.merge(
            Observable.merge(filtersRelay.mapToVoid(), inputs.tableRefreshes).map { _ in return false },
            fetchObservable.map { _ in return true }
        )
            .asDriver(onErrorJustReturn: false)
    }
    
    func tableItems(fetchObservable: Observable<Result<[Person], Error>>) -> Driver<[Person]> {
        return fetchObservable
            .map { result in
                switch result {
                case .success(let people):
                    return people
                case .failure:
                    return []
                }
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    func emptyLabelIsHidden(tableItems: Driver<[Person]>) -> Driver<Bool> {
        return tableItems
            .map { return !$0.isEmpty }
            .asDriver(onErrorJustReturn: false)
    }
    
    func errorToDisplay(fetchObservable: Observable<Result<[Person], Error>>) -> Driver<Error> {
        return fetchObservable
            .map { result -> Error? in
                switch result {
                case .success:
                    return nil
                case .failure(let error):
                    return error
                }
            }
            .asDriver(onErrorJustReturn: nil)
            .compactMap { $0 }
    }
    
}


