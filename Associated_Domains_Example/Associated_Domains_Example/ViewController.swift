//
//  ViewController.swift
//  Universal_Links_Example
//
//  Created by Jaron Lowe on 7/28/22.
//

import UIKit
import Combine

final class ViewController: UIViewController {

    // MARK: Properties
    static let pendingUniversalLink = CurrentValueSubject<String?, Never>(nil)
    
    @IBOutlet weak var universalLinkLabel: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Associated Domain Tests"
      
        Self.pendingUniversalLink
            .compactMap { $0 }
            .assign(to: \.text, on: universalLinkLabel)
            .store(in: &subscriptions)
    }

    // MARK: IBActions
    @IBAction func loginButtonPressed(_ sender: Any) {
     login()
    }
    
    @IBAction func scrollViewTapped(_ sender: Any) {
        tryToHideKeyboard()
    }
    
    // MARK: Action Methods
    func login() {
        tryToHideKeyboard()
        fakeLoginPublisher()
            .sink { _ in
                print("Fake Login completed")
            }
            .store(in: &subscriptions)
    }
    
    func fakeLoginPublisher() -> AnyPublisher<Void, Never> {
        let subject = PassthroughSubject<Void, Never>()
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 2) {
            subject.send()
            subject.send(completion: .finished)
        }
        return subject.eraseToAnyPublisher()
    }
    
    func tryToHideKeyboard() {
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameField { passwordField.becomeFirstResponder() }
        if textField == passwordField { login() }
        return true
    }
}
