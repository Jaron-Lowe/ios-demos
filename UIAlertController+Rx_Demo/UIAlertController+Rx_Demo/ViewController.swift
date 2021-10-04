//
//  ViewController.swift
//  UIAlertController+Rx_Demo
//
//  Created by Jaron Lowe on 8/19/21.
//

import UIKit
import RxSwift
import RxCocoa

enum DemoAction: Int, CaseIterable {
    
    case first
    case second
    case third
    case fourth
    
    var title: String {
        switch self {
        case .first: return "Action 1"
        case .second: return "Action 2"
        case .third: return "Action 3"
        case .fourth: return "Action 4"
        }
    }
    
}

class ViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var alertButton: UIButton!
    @IBOutlet weak var actionSheetButton: UIButton!
    
    private let demoAction = BehaviorRelay<DemoAction?>(value: nil)
    private let disposeBag = DisposeBag()
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupObservers()
    }

}

// MARK: - Private Methods

private extension ViewController {
    
    func setupObservers() {
        
        alertButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .flatMap({ [weak self] _ in
                        return UIAlertController.rx.presentAlert(
                            viewController: self,
                            title: "Alert Title", message: "Alert message body.", preferredStyle: .alert,
                            actions: DemoAction.allCases.map({ RxAlertAction(title: $0.title, style: .default, result: $0) }) + [RxAlertAction.cancelAction(title: "Cancel")]
                        )
            })
            .bind(to: demoAction)
            .disposed(by: disposeBag)
        
        actionSheetButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .flatMap({ [weak self] _ in
                        return UIAlertController.rx.presentAlert(
                            viewController: self,
                            title: "Action Sheet Title", message: nil, preferredStyle: .actionSheet,
                            popoverView: self?.actionSheetButton, popoverDirection: [.up, .down],
                            actions: DemoAction.allCases.map({ RxAlertAction(title: $0.title, style: .default, result: $0) }) + [RxAlertAction.cancelAction(title: "Cancel")]
                        )
            })
            .bind(to: demoAction)
            .disposed(by: disposeBag)
        
        demoAction
            .map { "Selected Action: \($0 == nil ? "n/a" : "\($0!.rawValue + 1)")" }
            .bind(to: outputLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
}
