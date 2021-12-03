//
//  FiltersViewModel.swift
//  MVVM+RxSwift Example
//
//  Created by Jaron Lowe on 11/17/21.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

final class FiltersViewModel {
    
    // MARK: Properties
    
    private let isFriendsOnly = BehaviorRelay(value: false)
    private let isOnlineOnly = BehaviorRelay(value: false)
    private let gender = BehaviorRelay(value: GenderFilterOption.any)
    private let age = BehaviorRelay(value: AgeFilterOption.any)
    private var formData: Observable<PeopleFilters> {
        return Observable.combineLatest(isFriendsOnly, isOnlineOnly, gender, age, resultSelector: {
            return PeopleFilters(isFriendsOnly: $0, isOnlineOnly: $1, gender: $2, age: $3)
        })
    }
    
    private let disposeBag = DisposeBag()
    
    // MARK: Init
    
    init(filters: PeopleFilters = .defaultFilters) {
        applyFilterModel(filters: filters)
    }
    
}

// MARK: - Private Methods

private extension FiltersViewModel {
    
    func applyFilterModel(filters: PeopleFilters) {
        isFriendsOnly.accept(filters.isFriendsOnly)
        isOnlineOnly.accept(filters.isOnlineOnly)
        gender.accept(filters.gender)
        age.accept(filters.age)
    }
    
    func setUpActionObservers(inputs: Inputs) {
        setUpFriendsOnlyButtonTapsObserver(inputs: inputs)
        setUpOnlineOnlyButtonTapsObserver(inputs: inputs)
        setUpGenderSelectionObserver(inputs: inputs)
        setUpAgeSelectionObserver(inputs: inputs)
        setUpResetTapObserver(inputs: inputs)
    }
    
    func setUpFriendsOnlyButtonTapsObserver(inputs: Inputs) {
        inputs.friendsOnlyButtonTaps
            .withLatestFrom(isFriendsOnly)
            .subscribe(onNext: {[weak self] isFriendsOnly in
                self?.isFriendsOnly.accept(!isFriendsOnly)
            })
            .disposed(by: disposeBag)
    }
    
    func setUpOnlineOnlyButtonTapsObserver(inputs: Inputs) {
        inputs.onlineOnlyButtonTaps
            .withLatestFrom(isOnlineOnly)
            .subscribe(onNext: {[weak self] isOnlineOnly in
                self?.isOnlineOnly.accept(!isOnlineOnly)
            })
            .disposed(by: disposeBag)
    }
    
    func setUpGenderSelectionObserver(inputs: Inputs) {
        inputs.genderViewSelections
            .bind(to: gender)
            .disposed(by: disposeBag)
    }
    
    func setUpAgeSelectionObserver(inputs: Inputs) {
        inputs.ageViewSelections
            .bind(to: age)
            .disposed(by: disposeBag)
    }
    
    func setUpResetTapObserver(inputs: Inputs) {
        inputs.resetButtonTaps
            .subscribe(onNext: { [weak self] _ in
                self?.resetFilters()
            })
            .disposed(by: disposeBag)
    }
    
    func processFormSubmissions(inputs: Inputs) -> Driver<PeopleFilters> {
        return inputs.applyButtonTaps.withLatestFrom(formData).asDriver(onErrorJustReturn: .defaultFilters)
    }
    
    func resetFilters() {
        applyFilterModel(filters: .defaultFilters)
    }
    
}

// MARK: - ViewModel

extension FiltersViewModel: ViewModel {
    
    struct Inputs {
        let friendsOnlyButtonTaps: Observable<Void>
        let onlineOnlyButtonTaps: Observable<Void>
        let genderViewSelections: Observable<GenderFilterOption>
        let ageViewSelections: Observable<AgeFilterOption>
        let resetButtonTaps: Observable<Void>
        let applyButtonTaps: Observable<Void>
    }
    
    struct Outputs {
        let isFriendsOnlySelected: Driver<Bool>
        let isOnlineOnlySelected: Driver<Bool>
        let genderDetail: Driver<String>
        let ageDetail: Driver<String>
        let submittedFormData: Driver<PeopleFilters>
    }
    
    func transform(_ inputs: Inputs) -> Outputs {
        setUpActionObservers(inputs: inputs)
        
        return Outputs(
            isFriendsOnlySelected: isFriendsOnly.asDriver(onErrorJustReturn: false),
            isOnlineOnlySelected: isOnlineOnly.asDriver(onErrorJustReturn: false),
            genderDetail: gender.map { $0.title }.asDriver(onErrorJustReturn: ""),
            ageDetail: age.map { $0.title }.asDriver(onErrorJustReturn: ""),
            submittedFormData: processFormSubmissions(inputs: inputs)
        )
    }
    
}
