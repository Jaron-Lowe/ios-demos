//
//  ViewController.swift
//
//  Created by Jaron Lowe.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    // MARK: Properties

    private lazy var segmentControl: UISegmentedControl = {
        let control = TabSegmentedControl(items: ["Tab 1", "Tab 2", "Tab 3", "Tab 4"])
        control.normalTextColor = UIColor(red: 222/255, green: 225/255, blue: 227/255, alpha: 1.0)
        control.selectedTextColor = .white
        control.disabledTextColor = .lightGray
        control.selectionIndicatorColor = UIColor(red: 220/255, green: 23/255, blue: 43/255, alpha: 1.0)
        control.selectionIndicatorTrayColor = UIColor(red: 251/255, green: 251/255, blue: 251/255, alpha: 0.2)
        control.selectedSegmentIndex = 0
        return control
    }()
    
    private lazy var indexLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let disposeBag = DisposeBag()
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        setUpObservers()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

// MARK: - Private Methods

private extension ViewController {
    
    func configureViews() {
        view.backgroundColor = UIColor(red: 45/255, green: 45/255, blue: 46/255, alpha: 1.0)
        
        [segmentControl, indexLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        view.addSubview(segmentControl)
        view.addSubview(indexLabel)
        
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 36.0),
            segmentControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8.0),
            segmentControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8.0),
            segmentControl.heightAnchor.constraint(equalToConstant: 36.0),
            
            indexLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            indexLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8.0),
            indexLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8.0),
        ])
    }
    
    func setUpObservers() {
        segmentControl.rx.selectedSegmentIndex
            .distinctUntilChanged()
            .map { "Select Index: \($0)" }
            .bind(to: indexLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
}
