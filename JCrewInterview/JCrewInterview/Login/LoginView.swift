//
//  LoginView.swift
//  JCrewInterview
//
//  Created by Jaron Lowe on 8/16/23.
//

import SwiftUI

struct LoginView: View {
	@ObservedObject var viewModel: LoginViewModel
	@State var backgroundName = Bool.random() ? "JCrew_Background" : "JCrew_Background_2"
	
	init(viewModel: LoginViewModel) {
		self.viewModel = viewModel
	}
	
	var body: some View {
		ZStack {
			Color.clear
				.background(Image(uiImage: UIImage(named: backgroundName)!)
					.resizable()
				 .scaledToFill()
				 .frame(maxWidth: .infinity))
			
			VStack(spacing: 24) {
				Text("J.Crew Login")
					.font(.title)
				VStack(spacing: 8) {
					TextField("Username", text: $viewModel.username)
						.textFieldStyle(.roundedBorder)
					SecureField("Password", text: $viewModel.password)
						.textFieldStyle(.roundedBorder)
				}
				Button {
					viewModel.loginAction()
				} label: {
					Text("Login")
						.foregroundColor(.black)
						.frame(maxWidth: .infinity, minHeight: 30)
				}
				.buttonStyle(.bordered)
				.frame(maxWidth: .infinity)
			}
			.padding(16)
			.background(.thinMaterial)
			.cornerRadius(16)
			.overlay(
				RoundedRectangle(cornerRadius: 16)
					.stroke(Color.gray.opacity(0.4), lineWidth: 1)
			)
			.padding(32)
			.frame(maxWidth: 500)
		}
		.ignoresSafeArea()
		.alert(
			viewModel.alert?.title ?? "",
			isPresented: $viewModel.isAlertPresented,
			presenting: viewModel.alert,
			actions: { alert in
				Button("Ok") { }
			},
			message: { alert in
				Text(alert.message)
			}
		)
	}
}

struct LoginView_Previews: PreviewProvider {
	static var previews: some View {
		LoginView(
			viewModel: .init(
				loginService: PreviewLoginService()
			)
		)
	}
}
