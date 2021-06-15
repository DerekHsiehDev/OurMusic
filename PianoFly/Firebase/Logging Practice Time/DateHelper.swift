//
//  DateHelper.swift
//  PianoFly
//
//  Created by Derek Hsieh on 6/14/21.
//

import Foundation

class DateHelper {
     static let instance = DateHelper()
    
    
    // MARK: PUBLIC FUNCTIONS
    
    func getCurrentDate(handler: @escaping(_ currentDate: String) -> ()) {
        let currentDate = Date()
        
        // transform to string
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        
        let date = formatter.string(from: currentDate)
        print(date)
        
        handler(date)
        return
    }
}
