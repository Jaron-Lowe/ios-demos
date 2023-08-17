//
//  LoginService.swift
//  JCrewInterview
//
//  Created by Jaron Lowe on 8/16/23.
//

import Foundation
import SimpleApiClient

public struct LoginCredentials: Encodable {
	let username: String
	let password: String
}

public protocol LoginServicing {
	func login(credentials: LoginCredentials) async throws -> LoginSuccess
}

public final class LoginService: LoginServicing {
	let httpClient: HttpClient
	
	init(httpClient: HttpClient) {
		self.httpClient = httpClient
	}
	
	public func login(credentials: LoginCredentials) async throws -> LoginSuccess {
		try await httpClient.sendAsync(api: LoginRequest(credentials: credentials))
	}
}

public final class PreviewLoginService: LoginServicing {
	public func login(credentials: LoginCredentials) async throws -> LoginSuccess {
		if Bool.random() {
			return .init(jwtValue: "1234")
		}
		else if Bool.random() {
			throw ApiFailure(errorCode: 1, errorMessage: "Server error encountered")
		}
		else {
			throw URLError(.badServerResponse)
		}
	}
}
