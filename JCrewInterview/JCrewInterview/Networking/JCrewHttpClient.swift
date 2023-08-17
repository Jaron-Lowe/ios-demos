//
//  JCrewHttpClient.swift
//  JCrewInterview
//
//  Created by Jaron Lowe on 8/16/23.
//

import Foundation
import SimpleApiClient

final class JCrewHttpClient: HttpClient {
	init() {
		super.init(
			baseUrl: URL(string: "https://api.jcrew.com/")!,
			invalidStatusCodeType: ApiFailure.self
		)
	}
}
