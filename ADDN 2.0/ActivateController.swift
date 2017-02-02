//
//  ActivateController.swift
//  ADDN 2.0
//
//  Created by Jay on 22/01/2017.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit

class ActivateController: UIViewController,UITextFieldDelegate
{
    
    lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "ADDN")
        //487 * 90
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let activateCodeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = " Enter Activate Code"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var activateButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.rgb(red: 80, green: 101, blue: 161)
        button.setTitle("Activate", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleActivate), for: .touchUpInside)
        return button
    }()

    
    func handleActivate(){
        //should handle the authentication of activate code
        if let activateCode = activateCodeTextField.text {
            
            let defaultUser = UserDefaults.standard
            defaultUser.set(activateCode, forKey: "activateCode")
            let homeController = ReportOptionController(style: .grouped)
            let homeNavController = UINavigationController(rootViewController: homeController)
            present(homeNavController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.rgb(red: 61, green: 91, blue: 151)
        
        view.addSubview(inputsContainerView)
        
        view.addSubview(profileImageView)
        
        view.addSubview(activateButton)

        setupInputsContainerView()
        setupActivateButton()
        setupProfileImageView()
    
    }
    
    func setupInputsContainerView(){
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -32).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //
        inputsContainerView.addSubview(activateCodeTextField)
        //xywh
        activateCodeTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor,constant: 12).isActive = true
        activateCodeTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        activateCodeTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        activateCodeTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, constant: 0).isActive = true
        
        activateCodeTextField.delegate = self
    }
    
    func setupActivateButton(){
        activateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activateButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        activateButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        activateButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    func setupProfileImageView(){
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 75).isActive = true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleActivate()
        return true
    }
    
    
}



