//
//  AppDelegate.swift
//  MVVM+RxSwift Example
//
//  Created by Jaron Lowe on 11/17/21.
//

import UIKit
import XCoordinator

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let window = UIWindow()
    let router = RootCoordinator().strongRouter

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        configureNavBar()
        
        router.setRoot(for: window)
        return true
    }
    
    func configureNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .blue
        UINavigationBar.appearance().tintColor = .white
        appearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
}

