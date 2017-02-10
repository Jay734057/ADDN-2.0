//
//  MenuCell.swift
//  ADDN 2.0
//
//  Created by Jay on 10/02/2017.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit

class MenuCell : BaseCell {
    let profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let menuTextLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    override func setupView() {
        super.setupView()
        
        addSubview(profileImageView)
        //xywh
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        
        addSubview(menuTextLabel)
        menuTextLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
        menuTextLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        menuTextLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        menuTextLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
    }
}
