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
    @Published var pieceArray: [UserPiece] = []
    @Published var highestInSevenDayLog: Int = 0
    @Published var doneFetching = false
    @AppStorage(CurrentUserDefaults.userID) var userID: String?

    
    // MARK: PUBLIC FUNCTIONS
    
//    func getFullPracticeLog(userID: String, handler: @escaping(_ isFinished: Bool) ->()){
//        
//        UploadToFirebaseHelper.instance.getPracticeLog(userID: userID) { returnedPosts in
//            for post in returnedPosts {
//                self.fullPracticeLog.append(post)
//            }
//            handler(true)
//            
//            if self.lastSevenDaysLog.isEmpty {
//                self.populateSevenDaysLog(fullArray: self.fullPracticeLog)
//            }
//            else {
//                self.updateSevenDaysLog(fullArray: self.fullPracticeLog)
//            }
//
//            
//            return
//        }
//    }
    
    func getAllPieces() {
        UploadToFirebaseHelper.instance.getPieces { pieceArray in
            self.pieceArray = pieceArray
        }
    }
    
    // MARK: PRIVATE FUNCTIONS
    
//    private func populateSevenDaysLog(fullArray: [PostModel]?) {
//
//        var lastSevenDaysLog: [PostModel] = []
//        // get string dates from last week
//        let currentDate = Date()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MM-dd-yyyy"
//        var largestInSevenDays: Int = 0
//
//
//        for val in stride(from: -6, through: 0, by: 1) {
//            let newDate = Calendar.current.date(byAdding: .day, value: val, to: currentDate)
//            let stringDate: String = (formatter.string(from: newDate!))
//
//
//            print(stringDate)
//
//            if let results = fullArray?.filter({ $0.postID == stringDate }), results.count > 0 {
//                // Exists date found
//
//                lastSevenDaysLog.append(contentsOf: results)
//
//                // Can force unwrap bc already checked if results is grater than 0
//                if Int(results.first!.practiceMinutes)! > largestInSevenDays {
//                    largestInSevenDays = Int(results.first!.practiceMinutes)!
//                }
//
//
//
//            } else {
//                // Doesn't exist in
////               print("1 does not exists in the array")
//                let post = PostModel(postID: stringDate, practiceMinutes: "0", dateCreated: Date())
//
//                lastSevenDaysLog.append(contentsOf: [post])
//
//            }
//
//        }
//
//
//        self.lastSevenDaysLog = lastSevenDaysLog
//        self.highestInSevenDayLog = largestInSevenDays
//        withAnimation(.linear) {
//            self.doneFetching = true
//        }
//
//
//    }
//
//    private func updateSevenDaysLog(fullArray: [PostModel]) {
//        // Find and update today's practice minutes
//        let currentDate = Date()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MM-dd-yyyy"
//        let stringDate = formatter.string(from: currentDate)
//
//
//        withAnimation(.linear) {
//            if Int(fullArray.last!.practiceMinutes)! > self.highestInSevenDayLog { self.highestInSevenDayLog = Int(fullArray.last!.practiceMinutes)! }
//
//            let post = PostModel(postID: stringDate, practiceMinutes: "0", dateCreated: Date())
//
//            self.lastSevenDaysLog[6] = fullArray.last ?? post
//            print(lastSevenDaysLog)
//        }
//
//    }
//

}
