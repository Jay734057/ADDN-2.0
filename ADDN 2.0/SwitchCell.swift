//
//  SwitchCell.swift
//  ADDN 2.0
//
//  Created by Jay on 23/01/2017.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit

class SwitchCell: BaseCell {
    
    var titleLabelWidthAnchorConstraint: NSLayoutConstraint?
    var titleLabelRightAnChorConstraint: NSLayoutConstraint?
    
    let switchButton: UISwitch = {
        let switchButton = UISwitch(frame: CGRect.zero)
        return switchButton
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let detailLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setupView() {
        addSubview(titleLabel)
        //xywh
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 18).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        titleLabelWidthAnchorConstraint = titleLabel.widthAnchor.constraint(equalToConstant: 100)
        titleLabelWidthAnchorConstraint?.isActive = true
        
        titleLabelRightAnChorConstraint = titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -18)
        
        titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        addSubview(detailLabel)
        //xywh
        detailLabel.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 12).isActive = true
        detailLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        detailLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        detailLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        accessoryView = switchButton

    }
    
}