//
//  String+.swift
//  Overflowing Stacks
//
//  Created by Faisal Bhombal on 1/15/20.
//  Copyright © 2020 Faisal Bhombal. All rights reserved.
//

import Foundation

extension String {
    
    var hours: Int {
        get {
            let elements = self.components(separatedBy: .whitespaces)
            
            let val = elements.first ?? "4"
            let key = elements.last ?? "hours"
            
            var h = Int(val) ?? 4
            switch key {
            case "days":
                h *= 24
            case "weeks":
                h *= 168
            default:
                break
            }
            return h
        }
    }
    
}
