//
//  FirebaseViewModel.swift
//  PianoFly
//
//  Created by Derek Hsieh on 6/23/21.
//

import Foundation
import SwiftUI
import FirebaseFirestore

class FirebaseViewModel: ObservableObject {
    
    @Published var fullPracticeLog: [PostModel] = []
    @Published var lastSevenDaysLog: [PostModel] = []
    
    // MARK: PUBLIC FUNCTIONS
    
    func getFullPracticeLog(userID: String, handler: @escaping(_ isFinished: Bool) ->()){
        UploadPracticeLog.instance.getPracticeLog(userID: userID) { returnedPosts in
            for post in returnedPosts {
                self.fullPracticeLog.append(post)
            }
            handler(true)
            
            return
        }
    }
    
    // MARK: PRIVATE FUNCTIONS
    
    func populateSevenDaysLog(fullArray: [PostModel]?) {
        
        var lastSevenDaysLog: [PostModel] = []
        // get string dates from last week
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        
        
        for val in stride(from: 0, through: -7, by: -1) {
            let newDate = Calendar.current.date(byAdding: .day, value: val, to: currentDate)
            let stringDate: String = (formatter.string(from: newDate!))

//            print(fullArray?.filter({ $0.postID == stringDate}))
            
            if let results = fullArray?.filter({ $0.postID == stringDate }), results.count > 0 {
                // Exists date found
                lastSevenDaysLog.append(contentsOf: results)
                print("found")
                
            } else {
                // Doesn't exist in
//               print("1 does not exists in the array")
            }
            
        }
        
        print(lastSevenDaysLog)
        self.lastSevenDaysLog = lastSevenDaysLog
        
    }
    
}
