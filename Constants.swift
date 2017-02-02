//
//  File.swift
//  ADDN 2.0
//
//  Created by Jay on 26/01/2017.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit

struct Constants {
    
    static let CENTER_CODE = "ACT-CBR-CAN"
    //
    static let GENDER = "Gender"
    
    static let SELECTABLE_GENDERS = ["Male","Female"]
    static let TITLES_FOR_GENDERS = ["MALE","FEMALE"]
    
    static let AGE_RANGE = "Age Range"
    
    static let PRESET_AGE_RANGES = [(Double.leastNormalMagnitude,6.0),(6.0,12.0),(12.0,18.0),(18.0,25.0),(25.0,50.0),(50.0,Double.greatestFiniteMagnitude)]
    //
    static let DIABETES_TYPE = "Diabetes Type"
    
    static let SELECTABLE_DIABETES_TYPES = ["Type 1","Type 2","Gestational","Monogenic","CFRD","Neonatal","Unspecified","Other"]
    
    static let PRESET_DIABETES_TYPE_INDEX = 0
    
    static let DIATETES_DURATION_RANGE = "Diabetes Duration Range"
    
    static let PRESET_DIATETES_DURATION_RANGES = [(Double.leastNormalMagnitude,1.0),(1.0,5.0),(5.0,10.0),(10.0,Double.greatestFiniteMagnitude)]
    //
    static let INSULIN_REGIMEN = "Insulin Regimen"
    
    static let SELECTABLE_INSULIN_REGIMEN = ["CSII","BD/Twice Daily","MDI","Other","Nill"]
    static let TITLES_FOR_INSULIN_REGIMEN = ["CSII","BD_TWICE_DAILY","MDI","Other","NILL"]
    //
    static let HbA1c_TYPE = "HbA1c Type"
    
    static let SELECTABLE_HbA1c_TYPES = ["NGSP(%)","IFFC(mmol/mol)"]
    
    static let HbA1c_RANGES = "HbA1c Ranges"
    
    static let PRESET_HbA1c_RANGES_FOR_NGSP = [(Double.leastNormalMagnitude,7.0),(7.0,7.5),(7.5,9.0),(9.0,Double.greatestFiniteMagnitude)]
    
    static let PRESET_HbA1c_RANGES_FOR_IFFC = [(Double.leastNormalMagnitude,53.0),(53.0,58.0),(58.0,75.0),(75.0,Double.greatestFiniteMagnitude)]
    //
    static let CONSENTTOBECONTACTED = "Consent to be contacted"
    
    static let AGEBREAKDOWNBYGENDER = "Age range breakdown by gender"
    
    static let INSULINREGIMENBREAKDOWNBYAGE = "Insulin regimen breakdown by age"
    
    //menu constant 
    
    static let SELECTABLE_ITEMS = [[GENDER,AGE_RANGE],[DIABETES_TYPE,DIATETES_DURATION_RANGE],[INSULIN_REGIMEN],[HbA1c_TYPE,HbA1c_RANGES],[CONSENTTOBECONTACTED,AGEBREAKDOWNBYGENDER,INSULINREGIMENBREAKDOWNBYAGE]]
    
    static let SELECTABLE_ATTRIBUTES = [SELECTABLE_GENDERS,SELECTABLE_DIABETES_TYPES,SELECTABLE_INSULIN_REGIMEN,SELECTABLE_HbA1c_TYPES]

    static let PRESET_RANGES = [PRESET_AGE_RANGES,PRESET_DIATETES_DURATION_RANGES,[],[]]
}
















