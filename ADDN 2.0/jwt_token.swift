//
//  jwt_token.swift
//  ADDN 2.0
//
//  Representing the JSON Object for a activate token
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
