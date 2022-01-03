//
//  PeopleListViewController.swift
//  MVVM+RxSwift Example
//
//  Created by Jaron Lowe on 11/18/21.
//

import UIKit
import RxSwift
import RxCocoa

final class PeopleListViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet private var filterButton: UIBarButtonItem!
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = .label
        return control
    }()
    @IBOutlet private var loadingIndicatorBackgroundView: UIView!
    @IBOutlet private var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private var emptyTableLabel: UILabel!
    @IBOutlet private var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    var viewModel: PeopleListViewModel!
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.refreshControl = refreshControl
        bindViewModel(viewModel)
    }
    
}

// MARK: - Private Methods

private extension PeopleListViewController {
    
    func bindViewModel(_ viewModel: PeopleListViewModel) {        
        let outputs = viewModel.transform(PeopleListViewModel.Inputs(
            filterButtonTaps: filterButton.rx.tap.mapToVoid(),
            tableRefreshes: refreshControl.rx.controlEvent(.valueChanged).mapToVoid()
        ))
        
        outputs.loadingIndicatorIsHidden.drive(loadingIndicatorBackgroundView.rx.isHidden).disposed(by: disposeBag)
        outputs.tableItems
            .do(onNext: { [weak self] _ in self?.refreshControl.endRefreshing() })
            .drive(
                tableView.rx.items(cellIdentifier: PersonCell.identifier, cellType: PersonCell.self),
                curriedArgument: { (row, model, cell) in cell.configure(model: model) }
            )
            .disposed(by: disposeBag)
        outputs.emptyLabelIsHidden.drive(emptyTableLabel.rx.isHidden).disposed(by: disposeBag)
        outputs.errorToDisplay
            .drive(onNext: { error in
                print("Error: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
}
