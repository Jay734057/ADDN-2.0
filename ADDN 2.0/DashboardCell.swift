//
//  DashboardCell.swift
//  ADDN 2.0
//
//  Cell for Dashboard
//
//  Created by Jay on 05/02/2017.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit

class DashboardCell: BaseCell {
    override func setupView() {
        addSubview(titleForTotal)
        //xywh
        titleForTotal.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        titleForTotal.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        titleForTotal.heightAnchor.constraint(equalToConstant: 40).isActive = true
        titleForTotal.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/3).isActive = true
        addSubview(DataForTotal)
        DataForTotal.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 16).isActive = true
        DataForTotal.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        DataForTotal.heightAnchor.constraint(equalToConstant: 40).isActive = true
        DataForTotal.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/3).isActive = true
    }
    
    let titleForTotal:UILabel = {
        let label = UILabel()
        label.text = "Totol Patients"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var DataForTotal:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
}
