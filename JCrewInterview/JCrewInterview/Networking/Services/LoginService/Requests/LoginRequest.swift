//
//  LoginRequest.swift
//  JCrewInterview
//
//  Created by Jaron Lowe on 8/16/23.
//

import Foundation
import SimpleApiClient

public struct LoginRequest: HttpApiRequest {
	public typealias ResponseType = LoginSuccess
	
	public var endpointPath: String {
		"login"
	}
	
	public var method: HttpMethod {
		.post
	}
	
	public var parameters: HttpParameters? {
		.body(.json(body: credentials))
	}
	
	let credentials: LoginCredentials
	
	init(credentials: LoginCredentials) {
		self.credentials = credentials
	}
}
