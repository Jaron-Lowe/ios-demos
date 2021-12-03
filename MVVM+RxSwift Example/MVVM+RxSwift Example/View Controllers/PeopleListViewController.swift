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
        control.tintColor = .white
        return control
    }()
    @IBOutlet private var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private var emptyTableLabel: UILabel!
    @IBOutlet private var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    var viewModel: PeopleListViewModel!
    
    deinit {
        print("People Controller Deinit")
    }
    
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
        
        outputs.loadingIndicatorIsHidden.drive(loadingIndicator.rx.isHidden).disposed(by: disposeBag)
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
    
    func processFilterSelections() -> Observable<PeopleFilters> {
        // TODO: Figure out how to pass along existing filters.
        return filterButton.rx.tap
            .flatMapLatest { [weak self] _ -> Observable<PeopleFilters> in
                if let controller = self?.storyboard?.instantiateViewController(withIdentifier: "FiltersViewController") as? FiltersViewController {
                    controller.modalPresentationStyle = .fullScreen
                    self?.present(controller, animated: true)
                    return controller.selectedFilters
                }
                return Observable.never()
            }
    }
}
