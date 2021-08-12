//
//  ForgetPassword.swift
//  PianoFly
//
//  Created by Derek Hsieh on 7/30/21.
//

import SwiftUI
import FirebaseAuth

struct ForgetPassword: View {
    @Binding var showPassToast: Bool
    @Binding var showAlert: Bool
    @State var emailText: String = ""
    @State var errorMsg: String = ""
    var body: some View {
        VStack {
            Text("Forgot Your Password?")
                .bold()
                .font(.largeTitle)
            
            VStack {
                TextField("Email", text: $emailText)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .keyboardType(.emailAddress)
                    .background(Color.gray.opacity(0.3).cornerRadius(10))
                    .foregroundColor(.black)
                    .font(.headline)
                    
                
                Button(action: {
                    
                    // forgot password

                    Auth.auth().sendPasswordReset(withEmail: emailText) { err in
                        if let err = err {
                            print(err.localizedDescription)
                            errorMsg = err.localizedDescription
                            return
                        } else {
                            print("SUCCESS SENDING RESET")
                            showAlert.toggle()
                            emailText = ""
                            showPassToast.toggle()
                        }
                    }
                    
                }, label: {
                    Text("Reset Password")
                        .frame(maxWidth: .infinity, maxHeight: 50, alignment: .center)
                        .background(Color.MyTheme.LightPurple.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        
                })
                .disabled(emailText == "")
                
                
            }
            .padding()
            .padding()
            
            Text(errorMsg)
                .foregroundColor(.red)
                .padding()
        }
    }
}

struct ForgetPassword_Previews: PreviewProvider {
    static var previews: some View {
        ForgetPassword(showPassToast: .constant(false), showAlert: .constant(true))
    }
}
