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
    @Published var thisWeekPracticeMinutes: Int? = nil
    @Published var todayPracticeMinutes: Int? = nil
    @Published var doneFetching = false
    @Published var pieceList: [Piece] = []
    
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
            self.getPracticeLog()
        }
 
    }
    
    
    func getPracticeLog() {
        if let userID = userID {
            UploadToFirebaseHelper.instance.getPracticeLog(userID: userID) { returnedPostModels in
                self.populateSevenDaysLog(fullArray: returnedPostModels)
                self.populatePieceList(postModelArray: self.lastSevenDaysLog)
            }
        }
        
    }
    
    // MARK: PRIVATE FUNCTIONS
    
    private func populateSevenDaysLog(fullArray: [PostModel]?) {

        var lastSevenDaysLog: [PostModel] = []
        // get string dates from last week
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        var largestInSevenDays: Int = 0


        for val in stride(from: -6, through: 0, by: 1) {
            let newDate = Calendar.current.date(byAdding: .day, value: val, to: currentDate)
            let stringDate: String = (formatter.string(from: newDate!))


            print(stringDate)

            if let results = fullArray?.filter({ $0.postID == stringDate }), results.count > 0 {
                // Exists date found

                lastSevenDaysLog.append(contentsOf: results)

                // Can force unwrap bc already checked if results is grater than 0
                if Int(exactly: results.first!.practiceMinutes)! > largestInSevenDays {
                    largestInSevenDays = Int(exactly: results.first!.practiceMinutes)!
                }



            } else {
                // Doesn't exist in
               print("1 does not exists in the array")
                let post = PostModel(postID: stringDate, practiceMinutes: 0, dateCreated: Date())

                lastSevenDaysLog.append(contentsOf: [post])

            }

        }


        self.lastSevenDaysLog = lastSevenDaysLog
        self.highestInSevenDayLog = largestInSevenDays
        withAnimation(.linear) {
            self.doneFetching = true
        }


    }
    
    private func populatePieceList(postModelArray: [PostModel]) {
        
        for piece in pieceArray {
            let newPiece = Piece(composer: piece.composer, title: piece.pieceTitle, practiceArray: [], thisWeekPracticeMinutes: 0, allTimePracticeMinutes: 0, iconColor: piece.iconColor)
            pieceList.append(newPiece)
        }
        
        for postModel in postModelArray {
            if postModel.pieces == nil {
                // do nothing bc there are no pieces
                
                for i in 0..<pieceList.count {
                    pieceList[i].practiceArray.append(PracticeDays(date: postModel.postID, practiceMinutes: 0))
                }
                
            } else {
                // there are pieces here
                
                for piece in postModel.pieces! {
                    // find from piece array
                    if let foundPiece = findFromPieceArray(pieceTitle: piece.key) {
                        if checkIfPieceExistsInList(pieceTitle: foundPiece.pieceTitle) {
                            // exists
                            
                            for i in 0..<pieceList.count {
                            
                                if pieceList[i].title == foundPiece.pieceTitle {
                                    // this is the one
                                    pieceList[i].thisWeekPracticeMinutes += piece.value
                                    pieceList[i].allTimePracticeMinutes += piece.value
                                    pieceList[i].practiceArray.append(PracticeDays(date: postModel.postID, practiceMinutes: piece.value))
                                }
                            }
                            
                        } else {
                            // not found - make new
                            
                            let practiceArray: [PracticeDays] = [PracticeDays(date: postModel.postID, practiceMinutes: piece.value)]
                            let newPiece = Piece(composer: foundPiece.composer, title: foundPiece.pieceTitle, practiceArray: practiceArray, thisWeekPracticeMinutes: piece.value, allTimePracticeMinutes: piece.value, iconColor: foundPiece.iconColor)
                            pieceList.append(newPiece)
                        }
                    } else {
                        print("DIDNT FIND")
                    }
                    
              
                }
                
            }
        }
        
        print("PIECE LIST")
        print(pieceList)
        
        
        
    }
    
    private func returnElementOfPieceFromPieceList(pieceTitle: String) -> Int {
        var counter = 0
        for piece in pieceList {
            if piece.title == pieceTitle {
                break
            } else {
                counter += 1
            }
        }
        
        return counter
    }
    
    private func checkIfPieceExistsInList(pieceTitle: String) -> Bool {
        for piece in self.pieceList {
            if piece.title == pieceTitle {
                return true
            }
        }
        return false
    }
    
    private func findFromPieceArray(pieceTitle: String) -> UserPiece? {
        for piece in pieceArray {
            if piece.pieceTitle == pieceTitle {
                return piece
            }
        }
        
        return nil
    }

    private func updateSevenDaysLog(fullArray: [PostModel]) {
        // Find and update today's practice minutes
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        let stringDate = formatter.string(from: currentDate)


        withAnimation(.linear) {
            if Int(exactly: fullArray.last!.practiceMinutes)! > self.highestInSevenDayLog { self.highestInSevenDayLog = Int(exactly: fullArray.last!.practiceMinutes)! }

//            let post = PostModel(postID: stringDate, practiceMinutes: "0", dateCreated: Date())

//            self.lastSevenDaysLog[6] = fullArray.last ?? post
            print(lastSevenDaysLog)
        }

    }


}
