//
//  SignInWithEmail.swift
//  PianoFly
//
//  Created by Derek Hsieh on 6/10/21.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore



let db = Firestore.firestore()



class SignInWithEmail {
    private let REF_USERS = db.collection("Users")
    static let instance = SignInWithEmail()
    
    // MARK: PUBLIC FUNCTIONS
    
    func createNewUserUsingEmail(mail: String, password: String, firstName: String, lastName: String, handler: @escaping(_ isError: Bool, _ alertMessage: String?) ->()) {
        Auth.auth().createUser(withEmail: mail, password: password) { (user, error) in
            if let error = error {
                handler(true, error.localizedDescription)
                return
            }
            if let userId = Auth.auth().currentUser?.uid {
                // create new user document with first and last names
                self.REF_USERS.document("\(String(describing: userId))").setData([
                        "firstN": firstName,
                        "lastN": lastName,
                        "email": mail

                    ]
                ) { err in
                    if let err = err {
                        print("Error writing document: \(err.localizedDescription)")
                      } else {
                        print("SUCCESSFULLY CREATED NEW USER: \(String(describing: userId))")
                          // sign in
                          
                          
                            self.updateUserDefaultsForUser(isLoggingIn: true, firstName: firstName, lastName: lastName, userID: userId, userEmail: mail) { isFinished in
                                print("SUCCESS")
                                handler(false, nil)
                            }
                          
                    
                      }
                }
            } else {
                handler(true, "No user ID found")
                return
            }
                
                

         
        }
    }
    
    // MARK: PRIVATE FUNCTIONS
    
    private func updateUserDefaultsForUser(isLoggingIn: Bool, firstName: String, lastName: String, userID: String, userEmail: String, handler: @escaping(_ isFinished: Bool) ->()) {
        // Set user defaults to keep user logged in

        
        if isLoggingIn {
            UserDefaults.standard.set(firstName, forKey: CurrentUserDefaults.firstName)
            UserDefaults.standard.set(lastName, forKey: CurrentUserDefaults.lastName)
            UserDefaults.standard.set(userEmail, forKey: CurrentUserDefaults.email)
            UserDefaults.standard.set(userID, forKey: CurrentUserDefaults.userID)
        } else {
            
            // loop through all userdefaults and delete keys
            let defaultsDictionary = UserDefaults.standard.dictionaryRepresentation()
            defaultsDictionary.keys.forEach { key in
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
      
        
        
    }
    
}

