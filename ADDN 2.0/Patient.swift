//
//  Patient.swift
//  ADDN 2.0
//
//  Created by Jay on 24/01/2017.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit

class Patient: SafeJsonObject {
    var id: NSNumber?
    var active: Bool?
    var age_at_export_in_days: NSNumber?
    var diabetes_duration_in_days: NSNumber?
    var diabetes_type_other: String?
    var diabetes_type_value: String?
    var gender: String?
    var local_id_id: NSNumber?
    
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dictionary)
    }
}
