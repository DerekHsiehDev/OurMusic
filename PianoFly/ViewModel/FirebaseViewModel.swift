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
    
    func updateSevenDayLog(dateString: String, practiceMinutes: Int, piece: UserPiece?) {
            
        for(index, item) in lastSevenDaysLog.enumerated() {
                if item.postID == dateString {
                    lastSevenDaysLog[index].practiceMinutes += practiceMinutes
                    
                    if let piece = piece {
                        // user had selected piece
                        
                        // udpate the piece list here
                        
                        self.updatePieceList(piece: piece, dateString: dateString, practiceMinutes: practiceMinutes)
                        
                        if item.pieces?[piece.pieceTitle] == nil {
                            lastSevenDaysLog[index].pieces?[piece.pieceTitle] = practiceMinutes
                            
                         
                            
                       
                        } else {
                            lastSevenDaysLog[index].pieces?[piece.pieceTitle]! += practiceMinutes
                        }
                        
                        
                            
                    }
                    
                    
                }
//                else {
//                    var newPost: PostModel
//                    if let piece = piece {
//
//
//                        newPost = PostModel(postID: dateString, practiceMinutes: practiceMinutes, dateCreated: Date(), pieces: [piece.pieceTitle: practiceMinutes])
//                    } else {
//                        newPost = PostModel(postID: dateString, practiceMinutes: practiceMinutes, dateCreated: Date())
//                    }
//
//                    lastSevenDaysLog.append(newPost)
//                }
            
  
        }
    }
    
 
    func updateTodaysPracticeMinutes(practiceMinutes: Int) {
        
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
    
    
    private func updatePieceList(piece: UserPiece, dateString: String, practiceMinutes: Int) {
        for(index, item) in pieceList.enumerated() {
            if item.title == piece.pieceTitle {
                // found
                // check if practice day alreadcy exists
                
                pieceList[index].allTimePracticeMinutes += practiceMinutes
                pieceList[index].thisWeekPracticeMinutes += practiceMinutes
                
                for (index2, day) in item.practiceArray.enumerated() {
                    print(day.date)
                    if day.date == dateString {
                        
                        print(pieceList[index].practiceArray[index2].practiceMinutes)
                        pieceList[index].practiceArray[index2].practiceMinutes  += practiceMinutes
                        print("UPDATED")
                        return
                    }
                }
                
            let newPracticeDay = PracticeDays(date: dateString, practiceMinutes: practiceMinutes)
                pieceList[index].practiceArray.append(newPracticeDay)
                print("UPDATED")
            }
        }
     }
     
    
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

    

}
