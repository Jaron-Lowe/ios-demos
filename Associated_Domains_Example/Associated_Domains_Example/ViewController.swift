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
        guard let username = usernameField.text, let password = passwordField.text else { return }
        
        tryToHideKeyboard()
        fakeLoginPublisher(username: username, password: password)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] _ in
                    print("Fake Login completed")
                    self?.pushNewViewController()
                }
            )
            .store(in: &subscriptions)
    }
    
    func fakeLoginPublisher(username: String, password: String) -> AnyPublisher<Void, URLError> {
        let credentials = LoginCredentials(username: username, password: password)
        let body = try? JSONEncoder().encode(credentials)
        let url = URL(string: "https://jaronlowe.com/services/Jeunesse/APITest/login.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .print("--- Login Response")
            .map { _ in () }
            .eraseToAnyPublisher()
    }
    
    func tryToHideKeyboard() {
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    func pushNewViewController() {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "viewcontroller") as? ViewController else { return }
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameField { passwordField.becomeFirstResponder() }
        if textField == passwordField { login() }
        return true
    }
}

struct LoginCredentials: Encodable {
    let username: String
    let password: String
}
