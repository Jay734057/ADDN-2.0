//
//  jwt_token.swift
//  ADDN 2.0
//
//  Created by Jay on 09/02/2017.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit

class jwt_token: SafeJsonObject {
    var token:String?
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dictionary)
    }
}
