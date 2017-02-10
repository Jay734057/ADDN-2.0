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
    
    lazy var noActiveCodeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.clear
        button.setTitle("Need new code?", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleGetActiveCode), for: .touchUpInside)
        return button
    }()

    func handleGetActiveCode() {
        let alertView = UIAlertController(title: "Active Code", message: "Jay", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertView.addAction(alertAction)
        
        self.present(alertView, animated: true, completion: {
            self.activateCodeTextField.text = ""
        })
    }
    
    func handleActivate(){
        
        view.endEditing(true)
        
        //should handle the authentication of activate code
        if let activateCode = activateCodeTextField.text {
            //check if code is valid? then....
            APIservice.sharedInstance.validateToken(secret: activateCode, completion: { (jwt: jwt_token) in
                if jwt.token == Constants.VALID_TOKEN {
                    let defaultUser = UserDefaults.standard
                    defaultUser.set(true, forKey: "activateFlag")

                    let homeController = HomeController()
                    let homeNavController = UINavigationController(rootViewController: homeController)
                    
                    self.present(homeNavController, animated: true, completion: nil)
                } else {
                    // code is not valid
                    let defaultUser = UserDefaults.standard
                    defaultUser.set(false, forKey: "activateFlag")
                    //show alert information
                    
                    let alertView = UIAlertController(title: "Invalid Active Code!", message: "Try Again Please", preferredStyle: .alert)
                    
                    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertView.addAction(alertAction)
                    
                    self.present(alertView, animated: true, completion: {
                        self.activateCodeTextField.text = ""
                    })
                }
                
            })
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.rgb(red: 61, green: 91, blue: 151)
        
        view.addSubview(inputsContainerView)
        
        view.addSubview(profileImageView)
        
        view.addSubview(activateButton)
        
        view.addSubview(noActiveCodeButton)

        setupInputsContainerView()
        setupActivateButton()
        setupProfileImageView()
        setupBottomButton()
    
    }
    
    func setupBottomButton() {
        noActiveCodeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12).isActive = true
        noActiveCodeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        noActiveCodeButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        noActiveCodeButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3).isActive = true
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



