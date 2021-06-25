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
    
    func convertLongDateToShortDate(longDate: Date) -> String {
        
        let dayformatter = DateFormatter()
        dayformatter.dateFormat = "D"
        let shortDate = dayformatter.string(from: longDate)
        
        return shortDate
    }
    
    // MARK: PRIVATE FUNCTION
    
    private func convertStringDateToDateObject(date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        let date = dateFormatter.date(from: date)
        return date ?? Date()
    }
}

