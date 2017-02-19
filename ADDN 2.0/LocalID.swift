//
//  LocalID.swift
//  ADDN 2.0
//
//  Representing the JSON Object for a local id
//
//  Created by Jay on 05/02/2017.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit

class LocalID: SafeJsonObject {
    var id: NSNumber?
    var centre: String?
    var date_of_export: String?
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dictionary)
    }
}
