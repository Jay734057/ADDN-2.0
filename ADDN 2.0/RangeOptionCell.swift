//
//  AgeCell.swift
//  ADDN 2.0
//
//  Cell for range setting
//
//  Created by Jay on 22/01/2017.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit

class RangeOptionCell: BaseCell, UITextFieldDelegate {
    
    var min: Double? {
        didSet{
            if min != Double.leastNormalMagnitude{
                minAgeTextField.text = min?.description
            }
        }
    }
    
    var max: Double? {
        didSet{
            if max != Double.greatestFiniteMagnitude{
                maxAgeTextField.text = max?.description
            }
        }
    }
    
    let ageInputContainerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var minAgeTextField: UITextField = {
        let min = UITextField()
        min.font = UIFont.systemFont(ofSize: 18)
        min.placeholder = "Lower..."
        min.textAlignment = .center
        min.delegate = self
        min.keyboardType = .decimalPad
        min.translatesAutoresizingMaskIntoConstraints = false
        return min
    }()
    
    let toLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = " to :"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var maxAgeTextField: UITextField = {
        let max = UITextField()
        max.font = UIFont.systemFont(ofSize: 18)
        max.placeholder = "Upper..."
        max.textAlignment = .center
        max.delegate = self
        max.keyboardType = .decimalPad
        max.translatesAutoresizingMaskIntoConstraints = false
        return max
    }()
    
    func setupInputContainer() {
        //
        ageInputContainerView.addSubview(toLabel)
        toLabel.centerXAnchor.constraint(equalTo: ageInputContainerView.centerXAnchor).isActive = true
        toLabel.centerYAnchor.constraint(equalTo: ageInputContainerView.centerYAnchor).isActive = true
        toLabel.widthAnchor.constraint(equalToConstant: 48).isActive = true
        toLabel.heightAnchor.constraint(equalTo: ageInputContainerView.heightAnchor).isActive = true
        //
        ageInputContainerView.addSubview(minAgeTextField)
        minAgeTextField.rightAnchor.constraint(equalTo: toLabel.leftAnchor, constant: -8).isActive = true
        minAgeTextField.centerYAnchor.constraint(equalTo: toLabel.centerYAnchor).isActive = true
        minAgeTextField.leftAnchor.constraint(equalTo: ageInputContainerView.leftAnchor, constant: 0).isActive = true
        minAgeTextField.heightAnchor.constraint(equalTo: ageInputContainerView.heightAnchor).isActive = true
        
        ageInputContainerView.addSubview(maxAgeTextField)
        maxAgeTextField.rightAnchor.constraint(equalTo: ageInputContainerView.rightAnchor, constant: 0).isActive = true
        maxAgeTextField.centerYAnchor.constraint(equalTo: toLabel.centerYAnchor).isActive = true
        maxAgeTextField.leftAnchor.constraint(equalTo: toLabel.rightAnchor, constant: 8).isActive = true
        maxAgeTextField.heightAnchor.constraint(equalTo: ageInputContainerView.heightAnchor).isActive = true
    }
    
    override func setupView() {
        addSubview(ageInputContainerView)
        //xywh
        ageInputContainerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        ageInputContainerView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        ageInputContainerView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -24).isActive = true
        ageInputContainerView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        setupInputContainer()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = minAgeTextField.text {
            min = Double(text)
        }
        if let text = maxAgeTextField.text {
            max = Double(text)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool { 
        switch string {
        case "0","1","2","3","4","5","6","7","8","9":
            return true
        case ".":
            var decimalCount = 0
            for character in (textField.text?.characters.map{String($0)})! {
                if character == "." {
                    decimalCount += 1
                }
            }
            
            if decimalCount == 1 {
                return false
            } else {
                return true
            }
        default:
            let array = string.characters.map{String($0)}
            if array.count == 0 {
                return true
            }
            return false
        }
        
    }

}

