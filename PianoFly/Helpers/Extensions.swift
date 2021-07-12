//
//  Extensions.swift
//  PianoFly
//
//  Created by Derek Hsieh on 6/10/21.
//

import Foundation
import SwiftUI

extension Color {
    
    struct MyTheme {
        static var yellowColor: Color {
            return Color("ColorYellow")
        }
        
        static var beigeColor: Color {
            return Color("ColorBeiege")
        }
        
        static var DarkPurple: Color {
            return Color("DarkPurple")
        }
        
        static var LightPurple: Color {
            return Color("LightPurple")
        }
        static var MediumPurple: Color {
            return Color("MediumPurple")
        }
    }
    
}

extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}
