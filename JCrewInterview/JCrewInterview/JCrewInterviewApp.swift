//
//  JCrewInterviewApp.swift
//  JCrewInterview
//
//  Created by Jaron Lowe on 8/16/23.
//

import SwiftUI

@main
struct JCrewInterviewApp: App {
    var body: some Scene {
        WindowGroup {
			LoginView(
				viewModel: .init(
					loginService: LoginService(httpClient: JCrewHttpClient())
				)
			)
        }
    }
}
