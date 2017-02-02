//
//  ViewController.swift
//  ADDN 2.0
//
//  Created by Jay on 22/01/2017.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit

class LaunchScreen: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        setupTimer()
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "ADDN"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont(name: "Arial", size: 80)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupView() {
        view.backgroundColor = UIColor.rgb(red: 61, green: 91, blue: 151)
        
        view.addSubview(label)
        //xywh
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: 250).isActive = true
        label.heightAnchor.constraint(equalToConstant: 90).isActive = true
    }
    
    var count = 0
    var timer = Timer()
    
    func setupTimer() {
        
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
    }
    
    func countDown() {
        count += 1
        if count > 3 {
            timer.invalidate()
            let homeController = HomeController(style: .grouped)
            let homeNavController = UINavigationController(rootViewController: homeController)
            
            self.present(homeNavController, animated: true, completion: nil)
        }
    }
}

