//
//  FiltersViewController.swift
//  MVVM+RxSwift Example
//
//  Created by Jaron Lowe on 11/17/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class FiltersViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet private var friendsOnlyButton: UIButton!
    @IBOutlet private var onlineOnlyButton: UIButton!
    @IBOutlet private var genderView: UIView!
    @IBOutlet private var genderDetailLabel: UILabel!
    @IBOutlet private var ageView: UIView!
    @IBOutlet private var ageDetailLabel: UILabel!
    @IBOutlet private var resetButton: UIButton!
    @IBOutlet private var applyButton: UIButton!
    
    let disposeBag = DisposeBag()
    private let viewModel = FiltersViewModel()
    
    private let selectedFiltersRelay: PublishRelay<PeopleFilters> = PublishRelay()
    var selectedFilters: Observable<PeopleFilters> {
        return selectedFiltersRelay.asObservable()
    }
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel(viewModel)
    }

}

// MARK: - Private Methods

private extension FiltersViewController {
    
    func bindViewModel(_ viewModel: FiltersViewModel) {
        let outputs = viewModel.transform(FiltersViewModel.Inputs(
            friendsOnlyButtonTaps: friendsOnlyButton.rx.tap.mapToVoid(),
            onlineOnlyButtonTaps: onlineOnlyButton.rx.tap.mapToVoid(),
            genderViewSelections: genderView.rx.tapGesture().when(.recognized).flatMapLatest { [weak self] _ in
                UIAlertController.rx.presentAlert(
                    viewController: self,
                    title: "Gender", message: nil, preferredStyle: .actionSheet, popoverView: self?.genderView, popoverDirection: .up, animated: true,
                    actions: GenderFilterOption.allCases.map { RxAlertAction(title: $0.title, style: .default, result: $0) }
                )
            },
            ageViewSelections: ageView.rx.tapGesture().when(.recognized).flatMapLatest { [weak self] _ in
                UIAlertController.rx.presentAlert(
                    viewController: self,
                    title: "Age", message: nil, preferredStyle: .actionSheet, popoverView: self?.ageView, popoverDirection: .up, animated: true,
                    actions: AgeFilterOption.allCases.map { RxAlertAction(title: $0.title, style: .default, result: $0) }
                )
            },
            resetButtonTaps: resetButton.rx.tap.mapToVoid(),
            applyButtonTaps: applyButton.rx.tap.mapToVoid()
        ))
        
        outputs.isFriendsOnlySelected.drive(friendsOnlyButton.rx.isSelected).disposed(by: disposeBag)
        outputs.isOnlineOnlySelected.drive(onlineOnlyButton.rx.isSelected).disposed(by: disposeBag)
        outputs.genderDetail.drive(genderDetailLabel.rx.text).disposed(by: disposeBag)
        outputs.ageDetail.drive(ageDetailLabel.rx.text).disposed(by: disposeBag)
        outputs.submittedFormData
            .drive(onNext: { [weak self] formData in
                guard let self = self else { return }
                self.selectedFiltersRelay.accept(formData)
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
}
