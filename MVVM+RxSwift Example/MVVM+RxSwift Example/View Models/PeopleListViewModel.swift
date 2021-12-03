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

final class PeopleListViewModel {
    
    // MARK: Properties
    private let router: WeakRouter<AppRoute>
    
    private let filtersRelay: BehaviorRelay<PeopleFilters> = BehaviorRelay(value: .defaultFilters)
    private let isLoadingRelay = BehaviorRelay(value: false)
    
    private let peopleService: PeopleServicing = PeopleService()
    
    private let disposeBag = DisposeBag()
    
    // MARK: Init
    
    init(router: WeakRouter<AppRoute>) {
        // TODO: peopleService SHOULD be dependency injected here in a real project
        self.router = router
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
        inputs.filterButtonTaps
            .flatMapFirst { [router = self.router] _ in
                router.rx.trigger(.filters)
            }
            .subscribe(onNext: { _ in
                print("Navigated")
            })
            .disposed(by: disposeBag)
        
        let fetchPeopleObservable = fetchPeople(inputs: inputs)
        let tableData = tableItems(fetchObservable: fetchPeopleObservable)
        
        return Outputs(
            loadingIndicatorIsHidden: loadingIndicatorIsHidden(inputs: inputs),
            tableItems: tableData,
            emptyLabelIsHidden: emptyLabelIsHidden(tableItems: tableData),
            errorToDisplay: errorToDisplay(fetchObservable: fetchPeopleObservable)
        )
    }
    
}

// MARK: - Private Methods

private extension PeopleListViewModel {
    
    func loadingIndicatorIsHidden(inputs: Inputs) -> Driver<Bool> {
        return isLoadingRelay
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
    }
    
    /*
    func filters(inputs: Inputs) -> Observable<PeopleFilters> {
        return inputs.filterButtonTaps
            .flatMapLatest {
                
            }
            .scan(PeopleFilters.defaultFilters, accumulator: { _, filters in
                
            })
    }
    
    func triggerFiltersRoute() -> Observable<PeopleFilters> {
        return .just(.defaultFilters)
    }
    */
    
    func fetchPeople(inputs: Inputs) -> Observable<Result<[Person], Error>> {
        return Observable.merge(filtersRelay.mapToVoid(), inputs.tableRefreshes)
            .withLatestFrom(filtersRelay)
            .do(onNext: { [weak self] _ in self?.isLoadingRelay.accept(true) })
            .flatMapLatest { [peopleService = self.peopleService] filters in
                peopleService.getPeople(filters: filters)
            }
            .do(onNext: { [weak self] _ in self?.isLoadingRelay.accept(false) })
            .share()
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


