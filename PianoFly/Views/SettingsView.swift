//
//  SettingsView.swift
//  PianoFly
//
//  Created by Derek Hsieh on 6/10/21.
//

import SwiftUI
import FirebaseFirestore

struct SettingsView: View {
    @Binding var index: Int
    
    @AppStorage(CurrentUserDefaults.userID) var userID: String?
    @AppStorage(CurrentUserDefaults.firstName) var firstName: String?
    @AppStorage(CurrentUserDefaults.lastName) var lastName: String?
    @AppStorage(CurrentUserDefaults.email) var email: String?
    @StateObject var firebaseViewModel: FirebaseViewModel
    
    var body: some View {
        VStack {
            Text(userID ?? "")
            Text(firstName ?? "")
            Text(lastName ?? "")
            Text(email ?? "")
            
            Button(action: {
                
                
                SignInWithEmail.instance.signOutWithEmail { isFinished in
                    firebaseViewModel.lastSevenDaysLog = []
                    firebaseViewModel.pieceArray = []
                    firebaseViewModel.pieceList = []
                    
                }
                
                
                
                
            }, label: {
                Text("Sign Out")
            })
            
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    
    static var previews: some View {
        SettingsView(index: .constant(0), firebaseViewModel: FirebaseViewModel())
    }
}
