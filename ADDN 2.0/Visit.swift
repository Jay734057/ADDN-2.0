//
//  Visit.swift
//  ADDN 2.0
//
//  Created by Jay on 24/01/2017.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit

class Visit: SafeJsonObject {
    var id: NSNumber?
    var hba1c_iffc: NSNumber?
    var hba1c_ngsp: NSNumber?
    var insulin_regimen: String?
    var local_id_id: NSNumber?
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dictionary)
    }
}
