//
//  UploadPracticeLog.swift
//  PianoFly
//
//  Created by Derek Hsieh on 6/14/21.
//

import FirebaseFirestore
import SwiftUI

class UploadToFirebaseHelper {
    
    @AppStorage(CurrentUserDefaults.userID) var userID: String?
    static let instance = UploadToFirebaseHelper()
    let REF = db.collection(FirestoreDocumentCollectionNames.log)
    
    // MARK: PUBLIC FUNCTIONS
    
    func getPieces(handler: @escaping(_ pieceArray: [UserPiece]) -> ()) {
        var pieceArray = [UserPiece]()
        
        if let userID = userID {
            let pieceREF = db.collection(FirestoreDocumentCollectionNames.pieces).document(userID).collection(FirestoreDocumentCollectionNames.myPieces)
            
            pieceREF.getDocuments { querySnapshot, err in
                if let snapshot = querySnapshot, snapshot.documents.count > 0 {
                    for document in snapshot.documents {
                        if let pieceTitle = document.documentID as? String,
                           let composer = document.get(DatabaseNewPieceField.composer) as? String,
                            let iconColor = document.get(DatabaseNewPieceField.iconColor) as? String
                        {
                            let newPiece = UserPiece(pieceTitle: pieceTitle, composer: composer, iconColor: iconColor)
                            pieceArray.append(newPiece)
                        }
                    }
                    print(pieceArray)
                    handler(pieceArray)
                }
            }
        
            
            
        }
    }
    
    func uploadNewPiece(pieceTitle: String, composer: String, iconColor: String, handler: @escaping(_ isError: Bool) -> ()) {
        if let userID = userID {
            let pieceREF = db.collection(FirestoreDocumentCollectionNames.pieces).document(userID).collection(FirestoreDocumentCollectionNames.myPieces).document(pieceTitle)
            
            
            let newPiece: [String: Any] = [
                DatabaseNewPieceField.composer: composer,
                DatabaseNewPieceField.iconColor: iconColor
            ]
            pieceREF.setData(newPiece) { error in
                if let error = error {
                    print(error.localizedDescription)
                    handler(true)
                    return
                } else {
                    handler(false)
                    return
                }
            }
            
            
            
        }
    }
    
    func uploadPracticeLog(dateString: String, practiceMinutes: Int, handler: @escaping(_ isError: Bool, _ practiceMinutes: Int?,_ dateString: String?) ->()) {
        if let userID = userID {
            
            // check if document exists
            
            self.checkIfDocumentExistsInDatabase(userID: userID, postID: dateString) { doesExist in
                if doesExist {
                    // exists - update existing document
                    // first need to get document practice minutes
                    
                    self.getSingleDocumentFromDatabase(userID: userID, postID: dateString) { returnedPost in
                        if let returnedPost = returnedPost {
                            // update doucment practice minutes
                            let oldPracticeMinutes: Int = Int(returnedPost.practiceMinutes)!
                            let newPracticeMinutes: Int = oldPracticeMinutes + practiceMinutes
                            
                            // path
                            let practiceREF = self.REF.document(userID).collection(FirestoreDocumentCollectionNames.practice).document(dateString)
                            
                            let postData: [String: Any] = [
                                DatabasePostField.postID: dateString,
                                DatabasePostField.practiceMinutes: "\(newPracticeMinutes)",
                                DatabasePostField.dateCreated: FieldValue.serverTimestamp()
                            ]
                            
                            practiceREF.setData(postData) { error in
                                if let error = error {
                                    print("ERROR UPDATING DATA IN DOCUMENT, ERROR: \(error.localizedDescription): USERID: \(userID), POSTID: \(dateString)")
                                    handler(true, nil, nil)
                                    return
                                } else {
                                    print("SUCCESSFULLY UPDATED DATA IN DOCUMENT:  USERID: \(userID), POSTID: \(dateString)")
                                    handler(false, newPracticeMinutes, dateString)
                                    return
                                }
                            }

                        }
                    }
                    
                } else {
                    // create new document
                    let practiceREF = self.REF.document(userID)
                          
                          let postData: [String: Any] = [
                              DatabasePostField.postID: dateString,
                              DatabasePostField.practiceMinutes: "\(practiceMinutes)",
                              DatabasePostField.dateCreated: FieldValue.serverTimestamp()
                          ]
                          
                          practiceREF.collection(FirestoreDocumentCollectionNames.practice).document(dateString).setData(postData) { error in
                              if let error = error {
                                  print("ERROR UPLAODING DATA TO POST DOCUMENT \(error)")
                                  handler(true, nil, nil)
                                  return
                              } else {
                                  handler(false, practiceMinutes, dateString)
                                  return
                              }
                          }
                    
                }
            }
            
            
      
        } else {
            print("ERROR GETTING USER ID, USER MAY NOT BE SIGNED IN, SHOULD NEVER BE A PROBLEM")
            handler(true, nil, nil)
            return
        }
    
    }
    
    
    func getPracticeLog(userID: String, handler: @escaping(_ posts: [PostModel]) ->()) {
        var postArray = [PostModel]()
        // path to practice log collection
        let practiceREF = REF.document(userID).collection(FirestoreDocumentCollectionNames.practice)
        
        practiceREF.order(by: DatabasePostField.postID, descending: false).limit(to: 31).getDocuments { querySnapshot, error in
            if let snapshot = querySnapshot, snapshot.documents.count > 0 {
                for document in snapshot.documents {
                    if let userID = document.get(DatabasePostField.postID) as? String, let practiceMinutes = document.get(DatabasePostField.practiceMinutes) as? String, let dateTimestamp = document.get(DatabasePostField.dateCreated) as? Timestamp {
                        let newPost = PostModel(postID: userID, practiceMinutes: practiceMinutes, dateCreated: dateTimestamp.dateValue())
                        postArray.append(newPost)
                    }
                }
                handler(postArray)
                print("GOT ALL DOCUEMNTS")
                return
            } else {
                print("NO DOCUMENTS FOUND IN SNAPSHOT FOUND FOR THIS USER")
                handler(postArray)
                return
            }
        }
        
    }
    
    // MARK: PRIVATE FUNCTIONS
    
    private func getSingleDocumentFromDatabase(userID: String, postID: String, handler: @escaping(_ post: PostModel?) ->()) {
        // path
        
        let docREF = REF.document(userID).collection(FirestoreDocumentCollectionNames.practice).document(postID)
        
        docREF.getDocument { document, error in
            if let document = document {
                
                if let postID = document.documentID as? String, let practiceMinutes = document.get(DatabasePostField.practiceMinutes) as? String, let dateTimestamp = document.get(DatabasePostField.dateCreated) as? Timestamp {
                    let newPost = PostModel(postID: postID, practiceMinutes: practiceMinutes, dateCreated: dateTimestamp.dateValue())
                    handler(newPost)
                    return
                } else {
                    handler(nil)
                    return
                }
                
            } else {
                handler(nil)
                return
            }
        }
        
        
        
    }
    
    
    private func checkIfDocumentExistsInDatabase(userID: String, postID: String, handler: @escaping(_ doesExist: Bool) -> ()) {
        // path
        let docREF = REF.document(userID).collection(FirestoreDocumentCollectionNames.practice).document(postID)
        
        docREF.getDocument { document, error in
            if let document = document, document.exists {
                handler(true)
                return
            } else {
                handler(false)
                return
            }
        }
        
        
    }
    
}
