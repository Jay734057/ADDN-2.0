//
//  AppDelegate.swift
//  ADDN 2.0
//
//  Created by Jay on 22/01/2017.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let defaultUser = UserDefaults.standard
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        application.statusBarStyle = .lightContent

        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        
        if checkIfActivated() {
            let homeController = ReportOptionController(style: .grouped)
            let homeNavController = UINavigationController(rootViewController: homeController)
            window?.rootViewController = homeNavController
        }else {
            window?.rootViewController = ActivateController()
        }
        
        return true
    }
    
    func checkIfActivated() -> Bool {
        //????
        if let code = defaultUser.value(forKey: "activateCode") as? String{
            print(code)
            if code == "Jay"{
                return true
            } else {
                return false
            }
        }else {
            return false
        }
    }
    
    
}

