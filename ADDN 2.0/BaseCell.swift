//
//  BaseCell.swift
//  ADDN 2.0
//
//  Base class for all table cell
//
//  Created by Jay on 22/01/2017.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit

class BaseCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {}
}


