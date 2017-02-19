//
//  SwitchCell.swift
//  ADDN 2.0
//
//  Cell for switchable items
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
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        titleLabelWidthAnchorConstraint = titleLabel.widthAnchor.constraint(equalToConstant: 150)
        titleLabelWidthAnchorConstraint?.isActive = true
        
        titleLabelRightAnChorConstraint = titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -18)
        
        titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        accessoryView = switchButton
        
        addSubview(detailLabel)
        //xywh
        detailLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -80).isActive = true
        detailLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        detailLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        detailLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

    }
    
}
