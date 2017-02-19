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

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        //check the applicaiton status before enter the home controller
        if checkIfActivated() {
            let homeController = HomeController()
            let homeNavController = UINavigationController(rootViewController: homeController)
            window?.rootViewController = homeNavController
        }else {
            //present the activation controller
            window?.rootViewController = ActivateController()
        }
        
        return true
    }
    
    func checkIfActivated() -> Bool {
        if let flag = defaultUser.value(forKey: "activateFlag") as? Bool{
            if flag{
                return true
            } else {
                return false
            }
        }else {
            return false
        }
    }
    
    
}

