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
    var viewModel: FiltersViewModel!
    
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
                    actions: GenderFilterOption.allCases.map { RxAlertAction(title: $0.title, style: .default, result: $0) } + [RxAlertAction.cancelAction(title: "Cancel")]
                )
            },
            ageViewSelections: ageView.rx.tapGesture().when(.recognized).flatMapLatest { [weak self] _ in
                UIAlertController.rx.presentAlert(
                    viewController: self,
                    title: "Age", message: nil, preferredStyle: .actionSheet, popoverView: self?.ageView, popoverDirection: .up, animated: true,
                    actions: AgeFilterOption.allCases.map { RxAlertAction(title: $0.title, style: .default, result: $0) } + [RxAlertAction.cancelAction(title: "Cancel")]
                )
            },
            resetButtonTaps: resetButton.rx.tap.mapToVoid(),
            applyButtonTaps: applyButton.rx.tap.mapToVoid()
        ))
        
        disposeBag.insert([
            outputs.isFriendsOnlySelected.drive(friendsOnlyButton.rx.isSelected),
            outputs.isOnlineOnlySelected.drive(onlineOnlyButton.rx.isSelected),
            outputs.genderDetail.drive(genderDetailLabel.rx.text),
            outputs.ageDetail.drive(ageDetailLabel.rx.text)
        ])
    }
    
}
