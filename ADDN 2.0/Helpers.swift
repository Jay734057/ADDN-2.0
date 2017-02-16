//
//  Helpers.swift
//  ADDN 2.0
//
//  Created by Jay on 22/01/2017.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit

extension UIColor{
    static func rgb(red:CGFloat, green: CGFloat, blue: CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension Array where Element: FloatingPoint {
    var total: Element {
        return reduce(0, +)
    }
    
    var average: Element {
        return isEmpty ? 0 : total / Element(count)
    }
    
    var median: Element {
        return isEmpty ? 0 : sorted()[count/2]
    }
    
    var min: Element {
        return isEmpty ? 0 : sorted().first!
    }
    
    var max: Element {
        return isEmpty ? 0 : sorted().last!
    }
    
}
