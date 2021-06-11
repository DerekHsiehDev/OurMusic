//
//  AuthService.swift
//  PianoFly
//
//  Created by Derek Hsieh on 6/10/21.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class AuthService {
    static let instance = AuthService()
    private var REF_USERS = db.collection("Users")
    
    // MARK: PUBLIC FUNCTIONS
    
    func logInUserToApp(userID: String, handler: @escaping (_ success: Bool) -> ()) {
        // get users info
        
        getUserInfo(forUserID: userID) { returnedUserID, returnedFirstName, returnedLastName in
            if let userID = returnedUserID, let firstName = returnedFirstName, let lastName = returnedLastName {
                // success
                print("success getting user info while logging in ")
                handler(true)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    // set user info into app
                    UserDefaults.standard.set(userID, forKey: CurrentUserDefaults.userID)
                    UserDefaults.standard.set(firstName, forKey: CurrentUserDefaults.firstName)
                    UserDefaults.standard.set(lastName, forKey: CurrentUserDefaults.lastName)
                }

                
            } else {
                // error
                print("error getting user info ")
                handler(false)
            }
        }
        
        // set the users info into our app
        
    }
    
    
    
    func logInUserToFirebase(credential: AuthCredential, handler: @escaping (_ providerID: String?, _ irError: Bool, _ isNewUser: Bool?, _ userID: String?) -> ()) {
        
        Auth.auth().signIn(with: credential) { result, error in
            
            // check for errors
            if error != nil {
                print("ERROR LOGGIN INTO FIREBASE: \(error!.localizedDescription)")
                handler(nil, true, nil, nil)
                return
            }
        
            // check for provider ID
            guard let providerID = result?.user.uid else {
                print("error getting provider ID")
                handler(nil, true, nil, nil)
                return
            }
            
            guard let userID = Auth.auth().currentUser?.uid else {
                print("couldn't get user id")
                handler(nil, true, nil, nil)
                return
            }
            
            self.checkIfUserExistsInDatabase(providerID: userID) { returnedUserID in
                print(userID)
                if let userID = returnedUserID {
                    // user exists, log in to app
                    print("user already exists")
                    self.getUserInfo(forUserID: userID) { returnedUserID, returnedFirstName, returnedLastName  in
                        UserDefaults.standard.setValue(returnedUserID, forKey: CurrentUserDefaults.userID)
                        UserDefaults.standard.setValue(returnedFirstName, forKey: CurrentUserDefaults.firstName)
                        UserDefaults.standard.setValue(returnedLastName, forKey: CurrentUserDefaults.lastName)
                        handler(providerID, false, false, userID)
                    }

                } else {
                    // user doees not exist, continuet to onboarding a new user
                    
                    // create new user document with first and last names
                    
                    if let userID = Auth.auth().currentUser?.uid {
                        handler(providerID, false, true, userID)
                    }
                   
                    
                    
                }
            }
            
            
            
        }
        
        
        
        
    }
    
    
    
    // MARK: PRIVATE FUNCTIONS
    
    private func checkIfUserExistsInDatabase(providerID: String, handler: @escaping (_ existingUserID: String?) -> ()) {
        // if a userID is treutnred, then the user does exist in our databse
        
        let docRef = db.collection("Users").document(providerID)
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                handler(document.documentID)
            } else {
                handler(nil)
            }
        }
    }
    
    private func getUserInfo(forUserID userID: String, handler: @escaping (_ userID: String?, _ firstName: String?, _ lastName: String?) -> ()) {
        
        db.collection("Users").document(userID).getDocument { documentSnapshot, error in
            if let document = documentSnapshot,
               let firstName = document.get(DatabaseUserField.firstName) as? String,
               let lastName = document.get(DatabaseUserField.lastName) as? String {
                    print("success getting user info")
                    handler(userID, firstName, lastName)
                    return
            } else {
                print("Error getting user info")
                handler(nil, nil, nil)
                return
            }
        }
        
    }
    
    
    
}
