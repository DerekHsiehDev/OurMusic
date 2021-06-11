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
    
    func signOutWithEmail(handler: @escaping(_ isFinished: Bool) -> ()) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("ERROR SIGNING OUT \(signOutError.localizedDescription)")
        }
        
        // delay for 0.3 seconds so ui can catch up
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.wipeUserDefaultsForUser()
            handler(true)
            return
        }
    }
    
    // gets user data from db with userID then updates user defaults
    func logInUser(userID: String, firstName: String, lastName: String, handler: @escaping(_ isError: Bool, _ isFinished: Bool) ->()) {
        self.REF_USERS.document("\(String(describing: userID))").setData([
            DatabaseUserField.firstName: firstName,
            DatabaseUserField.lastName: lastName,
            DatabaseUserField.email: "apple"

            ]
        ) { err in
            if let err = err {
                print("Error writing document: \(err.localizedDescription)")
              } else {
                print("SUCCESSFULLY CREATED NEW USER: \(String(describing: userID))")
                  // sign in
                  
                  
                    self.updateUserDefaultsForUser(isLoggingIn: true, firstName: firstName, lastName: lastName, userID: userID, userEmail: "apple") { isFinished in
                        print("SUCCESS")
                        handler(false, true)
                    }
                  
            
              }
        }
    }
    
    func signInExistingUserWithEmail(email: String, password: String, handler: @escaping(_ isError: Bool, _ alertMessage: String?) -> ()) {
        
        // firebase sign in w email
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            
            if let error = error {
                // return true for error and the alert message
                print(error.localizedDescription.capitalized)
                handler(true, error.localizedDescription)
                return
            } else {
                
                // checking if user id exists - should always exist if theres no error signing in, but just to be safe
                
                if let userID = Auth.auth().currentUser?.uid {
                    self.getUserDataFromDatabase(userID: userID) { isError in
                        if isError {
                            print("ERROR GETTING USER DATA FROM DB")
                            handler(true, "Error getting user data from database")
                            return
                        } else {
                            print("SUCCESS GETTING USER DATA AND SIGNING IN")
                            handler(false, nil)
                        }
                    }
                }
          
                
                
            }
            
        }
    }
    
    func updateUserDefaultsForUser(isLoggingIn: Bool, firstName: String, lastName: String, userID: String, userEmail: String, handler: @escaping(_ isFinished: Bool) ->()) {
        // Set user defaults to keep user logged in

        
        if isLoggingIn {
            UserDefaults.standard.set(firstName, forKey: CurrentUserDefaults.firstName)
            UserDefaults.standard.set(lastName, forKey: CurrentUserDefaults.lastName)
            UserDefaults.standard.set(userEmail, forKey: CurrentUserDefaults.email)
            UserDefaults.standard.set(userID, forKey: CurrentUserDefaults.userID)
            handler(true)
        } else {
            
            // loop through all userdefaults and delete keys
            let defaultsDictionary = UserDefaults.standard.dictionaryRepresentation()
            defaultsDictionary.keys.forEach { key in
                UserDefaults.standard.removeObject(forKey: key)
            }
            handler(true)
        }
 
    }
    
    func createNewUserUsingEmail(mail: String, password: String, firstName: String, lastName: String, handler: @escaping(_ isError: Bool, _ alertMessage: String?) ->()) {
        Auth.auth().createUser(withEmail: mail, password: password) { (user, error) in
            if let error = error {
                handler(true, error.localizedDescription)
                return
            }
            if let userId = Auth.auth().currentUser?.uid {
                // create new user document with first and last names
                self.REF_USERS.document("\(String(describing: userId))").setData([
                    DatabaseUserField.firstName: firstName,
                    DatabaseUserField.lastName: lastName,
                    DatabaseUserField.email: mail

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
    
    private func getUserDataFromDatabase(userID: String, handler: @escaping(_ isError: Bool) -> ()) {
        self.REF_USERS.document(userID).getDocument { documentSnapshot, error in
            if let error = error {
                print("ERROR WHEN GETTING DOCUMENTS FROM USERS DB: \(error.localizedDescription)")
                handler(true)
                return
            } else {
                if let document = documentSnapshot,
                   let firstName = document.get(DatabaseUserField.firstName) as? String,
                   let lastName = document.get(DatabaseUserField.lastName) as? String,
                   let email = document.get(DatabaseUserField.email) as? String {
                    self.updateUserDefaultsForUser(isLoggingIn: true, firstName: firstName, lastName: lastName, userID: userID, userEmail: email) { isFinished in
                        handler(false)
                        return
                    }
                }
            }
        }
    }
    
  
    
    private func wipeUserDefaultsForUser() {
        // loop through all userdefaults and delete keys
        let defaultsDictionary = UserDefaults.standard.dictionaryRepresentation()
        defaultsDictionary.keys.forEach { key in
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
    
}

