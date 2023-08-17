//
//  ApiFailure.swift
//  JCrewInterview
//
//  Created by Jaron Lowe on 8/16/23.
//

import Foundation

public struct ApiFailure: Decodable, Error {
	let errorCode: Int
	let errorMessage: String
}
