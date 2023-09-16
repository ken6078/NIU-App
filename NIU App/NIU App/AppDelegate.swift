//
//  AppDelegate.swift
//  NIU App
//
//  Created by Jacky Ben on 2023/5/9.
//

import UIKit

let headers = [
    "User-Agent": "Mozilla/5.0; Niu-App/0.1 (+https://github.com/ken6078/NIU-App);"
]

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        let nav = UINavigationController(rootViewController: LoginViewController())
        window?.rootViewController = nav
        
        return true
    }
}

