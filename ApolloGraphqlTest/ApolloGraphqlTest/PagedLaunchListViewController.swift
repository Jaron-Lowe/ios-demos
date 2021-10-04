//
//  PagedLaunchListViewController.swift
//  ApolloGraphqlTest
//
//  Created by Jaron Lowe on 3/23/21.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

class PagedLaunchListViewController: UIViewController {

    // =================================================================================
    // MARK: - Properties
    // =================================================================================
    
    // IBOutlets
    @IBOutlet weak var loadingIndicatorLinked: UIActivityIndicatorView!
    @IBOutlet weak var cursorLabelLinked: UILabel!
    @IBOutlet weak var hasMoreLabelLinked: UILabel!
    @IBOutlet weak var countLabelLinked: UILabel!
    @IBOutlet weak var tokenLabelLinked: UILabel!
    @IBOutlet weak var loadDataButtonLinked: UIButton!
    @IBOutlet weak var dividerHeightContraintLinked: NSLayoutConstraint!
    @IBOutlet weak var tableViewLinked: UITableView!
    @IBOutlet weak var emptyTableLabelLinked: UILabel!
    
    // Variables
    private var isLoading = BehaviorSubject<Bool>(value: false)
    private var cursor = BehaviorRelay<String?>(value: nil)
    private var hasMore = BehaviorSubject<Bool>(value: true)
    private var launches = BehaviorRelay<[GetLaunchListQuery.Data.Launch.Launch]>(value: [])
    
    var token = BehaviorSubject<String?>(value: nil)
    
    private let disposeBag = DisposeBag()
    
    
    // =================================================================================
    // MARK: - Lifecycle
    // =================================================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dividerHeightContraintLinked.constant = (1.0 / UIScreen.main.scale)
        tableViewLinked.tableFooterView = UIView()
        
        setupObservers()
    }
    

}


// =================================================================================
// MARK: - Rx Setup
// =================================================================================

private extension PagedLaunchListViewController {
    
    func setupObservers() {
        
        // Observe LoadingIndicator IsAnimating
        isLoading
            .bind(to: loadingIndicatorLinked.rx.isAnimating)
            .disposed(by: disposeBag)
        
        // Bind Cursor Text
        cursor
            .map({ "Cursor: \($0 ?? "nil")" })
            .bind(to: cursorLabelLinked.rx.text)
            .disposed(by: disposeBag)
        
        // Bind HasMore Text
        hasMore
            .map({"HasMore: \($0)"})
            .bind(to: hasMoreLabelLinked.rx.text)
            .disposed(by: disposeBag)
        
        // Bind Token Text
        token
            .map({ "Token: \($0 ?? "...")" })
            .bind(to: tokenLabelLinked.rx.text)
            .disposed(by: disposeBag)
        
        // Bind LoadDataButton isEnabled
        Observable.combineLatest(isLoading, hasMore)
            .map({(isLoading, hasMore) in return (!isLoading && hasMore) })
            .bind(to: loadDataButtonLinked.rx.isEnabled)
            .disposed(by: disposeBag)
        
        // Observe Load Data Tap
        loadDataButtonLinked.rx.tap
            .withLatestFrom(cursor, resultSelector: { $1 })
            .do(onNext: {[weak self] _ in self?.isLoading.onNext(true) })
            .flatMapLatest({ cursor in return SampleApolloApi.GetLaunchList(cursor: cursor, pageSize: 20) })
            .subscribe(onNext: {[weak self] result in
                self?.isLoading.onNext(false)
                switch result {
                case .success(let data):
                    let launchData = data.launches
                    self?.cursor.accept(launchData.cursor)
                    self?.hasMore.onNext(launchData.hasMore)
                    let oldLaunches = self?.launches.value
                    let totalLaunches = (oldLaunches ?? []) + launchData.launches.compactMap({ $0 })
                    self?.launches.accept(totalLaunches)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        if (totalLaunches.count > 0) {
                            self?.tableViewLinked.scrollToRow(at: IndexPath(row: totalLaunches.count-1, section: 0), at: .bottom, animated: true)
                        }
                    }
                case .failure(let error):
                    print("Graph Error: \(error.localizedDescription)")
                }
            })
            .disposed(by: disposeBag)
        
        // Bind Launches to TableView
        launches
            .do(onNext: {[weak self] launches in
                self?.emptyTableLabelLinked.isHidden = (launches.count > 0)
                self?.countLabelLinked.text = "Count: \(launches.count)"
            })
            .bind(
                to: tableViewLinked.rx.items,
                curriedArgument: {(tv, row, model) in
                    guard let cell = tv.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell() }
                    cell.textLabel?.text = model.id
                    cell.textLabel?.textColor = (model.isTestElement == true) ? UIColor.red : UIColor.black
                    cell.detailTextLabel?.text = model.site
                    cell.detailTextLabel?.textColor = UIColor.lightGray
                    
                    return cell
                }
            )
            .disposed(by: disposeBag)
    }
    
    
}
