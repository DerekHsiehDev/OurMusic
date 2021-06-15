//
//  UploadPracticeLog.swift
//  PianoFly
//
//  Created by Derek Hsieh on 6/14/21.
//

import FirebaseFirestore
import SwiftUI

class UploadPracticeLog {
    
    @AppStorage(CurrentUserDefaults.userID) var userID: String?
    static let instance = UploadPracticeLog()
    let REF = db.collection(FirestoreDocumentCollectionNames.log)
    
    // MARK: PUBLIC FUNCTIONS
    
    func uploadPracticeLog(dateString: String, practiceMinutes: Int, handler: @escaping(_ isError: Bool, _ practiceMinutes: Int?,_ dateString: String?) ->()) {
        if let userID = userID {
            let practiceREF = REF.document(userID)
            
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
        } else {
            print("ERROR GETTING USER ID, USER MAY NOT BE SIGNED IN, SHOULD NEVER BE A PROBLEM")
            handler(true, nil, nil)
            return
        }
    
    }
    
    // MARK: PRIVATE FUNCTIONS
    
    
}
