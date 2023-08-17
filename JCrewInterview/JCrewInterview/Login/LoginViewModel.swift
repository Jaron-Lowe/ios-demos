//
//  LoginViewModel.swift
//  JCrewInterview
//
//  Created by Jaron Lowe on 8/16/23.
//

import Foundation

struct Alert {
	let title: String
	let message: String
}

@MainActor
final class LoginViewModel: ObservableObject {
	@Published var username = ""
	@Published var password = ""
	@Published var isAlertPresented = false
	@Published var alert: Alert?

	let loginService: LoginServicing
	
	init(loginService: LoginServicing) {
		self.loginService = loginService
	}
	
	func loginAction() {
		guard !username.isEmpty, !password.isEmpty else {
			prepareAlert(.init(title: "One More Thing", message: "You must enter a username and password."))
			return
		}
		Task {
			do {
				let loginResult = try await loginService.login(credentials: .init(username: username, password: password))
				prepareAlert(.init(title: "Success", message: loginResult.jwtValue))
			} catch let error as ApiFailure {
				prepareAlert(.init(title: "Error Code: \(error.errorCode)", message: error.errorMessage))
			} catch {
				prepareAlert(.init(title: "Failure", message: "Something went wrong"))
			}
		}
	}
}

private extension LoginViewModel {
	func prepareAlert(_ alert: Alert) {
		isAlertPresented = true
		self.alert = alert
	}
}
