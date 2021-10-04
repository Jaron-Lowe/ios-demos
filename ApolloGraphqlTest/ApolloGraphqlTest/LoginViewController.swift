//
//  LoginViewController.swift
//  ApolloGraphqlTest
//
//  Created by Jaron Lowe on 3/23/21.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

class LoginViewController: UIViewController {

    // =================================================================================
    // MARK: - Properties
    // =================================================================================
    
    // IBOutlets
    @IBOutlet weak var emailFieldLinked: UITextField!
    @IBOutlet weak var loginButtonLinked: UIButton!
    @IBOutlet weak var loadingIndicatorLinked: UIActivityIndicatorView!
    
    // Variables
    private var isLoading = BehaviorSubject<Bool>(value: false)
    private var email = BehaviorSubject<String>(value: "jaron@apollotest.com")
    
    private let disposeBag = DisposeBag()
    
    
    // =================================================================================
    // MARK: - Lifecycle
    // =================================================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupObservers()
    }
    
    
    // =================================================================================
    // MARK: - Control Actions
    // =================================================================================
    
    private func proceedToTestScreen(token: String) {
        guard let controller = storyboard?.instantiateViewController(identifier: "Test") as? PagedLaunchListViewController else { return }
        controller.token.onNext(token)
        navigationController?.pushViewController(controller, animated: true)
    }
    

}


// =================================================================================
// MARK: - Rx Setup
// =================================================================================

private extension LoginViewController {
    
    func setupObservers() {
        
        // Observe LoadingIndicator IsAnimating
        isLoading
            .bind(to: loadingIndicatorLinked.rx.isAnimating)
            .disposed(by: disposeBag)
        
        // Bind Email to Field
        email
            .bind(to: emailFieldLinked.rx.text)
            .disposed(by: disposeBag)
        
        // Bind Field to Email
        emailFieldLinked.rx.text
            .orEmpty
            .bind(to: email)
            .disposed(by: disposeBag)
        
        // Bind Login Button isEnabled
        isLoading
            .subscribe(onNext: {[weak self] isLoading in
                self?.emailFieldLinked.isEnabled = !isLoading
                self?.loginButtonLinked.isEnabled = !isLoading
            })
            .disposed(by: disposeBag)
        
        // Observe Login Tap
        loginButtonLinked.rx.tap
            .withLatestFrom(email, resultSelector: { $1 })
            .do(onNext: {[weak self] _ in self?.isLoading.onNext(true) })
            .flatMapLatest({email in SampleApolloApi.Login(email: email) })
            .subscribe(onNext: {[weak self] result in
                self?.isLoading.onNext(false)
                switch result {
                case .success(let data):
                    if let token = data.login { self?.proceedToTestScreen(token: token) }
                case .failure(let error):
                    print("Graph Error: \(error.localizedDescription)")
                }
            })
            .disposed(by: disposeBag)
    }
    
    
}
