//
//  SettingsView.swift
//  PianoFly
//
//  Created by Derek Hsieh on 8/1/21.
//

import SwiftUI
import FirebaseAuth



struct SettingsView: View {
    @StateObject var firebaseViewModel: FirebaseViewModel
    @Binding var index: Int
    @AppStorage(CurrentUserDefaults.email) var email: String = ""
    @State var errMsg: String = "Successfully Sent Password Reset to Your Email"
    @State var showToast: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                GroupBox(label: SettingsLabelView(labelText: "OurMusic", labelImage: "dot.radiowaves.left.and.right"), content: {
                    HStack(alignment: .center, spacing: 10, content: {
                        
                        Image("Logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80, alignment: .center)
                            .cornerRadius(12)
                        
                        Text("MusicFly is the best way to track practice minutes for your instruments and musical journey. It’s bundled with features such as specific piece selection and teacher student integration.")
                            .font(.footnote)
                        
                    })
                })
                .padding()
                
                GroupBox(label: SettingsLabelView(labelText: "Profile", labelImage: "person.fill"), content: {
                    
                    Button(action: {
                        SignInWithEmail.instance.updateUserDefaultsForUser(isLoggingIn: false, firstName: "", lastName: "", userID: "", userEmail: "") { finished in
                            print("successfully logged out user")
                            index = 0
                            resetViewModel()
                        }
                    }, label: {
                        SettingsRowView(leftIcon: "figure.walk", text: "Sign out", color: Color.MyTheme.DarkPurple)

                    })
                    
                    
                    SettingsRowView(leftIcon: "text.quote", text: "Edit Bio", color: Color.MyTheme.DarkPurple)
                    
                    Button(action: {
                        Auth.auth().sendPasswordReset(withEmail: email) { err in
                            if let err = err {
                                print(err.localizedDescription)
                            } else {
                                showToast.toggle()
                            }
                          
                            
                        }
                        
                    }, label: {
                        SettingsRowView(leftIcon: "pencil", text: "Change Password", color: Color.MyTheme.DarkPurple)
                    })
                   
                   
                })
                .padding()
                
                GroupBox(label: SettingsLabelView(labelText: "Application", labelImage: "apps.iphone"), content: {
                    Button(action: {
                        openCustomURL(urlString: "https://www.google.com")
                    }, label: {
                        SettingsRowView(leftIcon: "folder.fill", text: "Privacy Policy", color: Color.MyTheme.yellowColor)
                    })
                    
                    Button(action: {
                        openCustomURL(urlString: "https://www.yahoo.com")
                    }, label: {
                        SettingsRowView(leftIcon: "folder.fill", text: "Terms & Conditions", color: Color.MyTheme.yellowColor)
                    })
                })
                .padding()
            }
            .navigationBarTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
    
        .present(isPresented: self.$showToast, type: .floater(), position: .top,  animation: Animation.spring(), closeOnTapOutside: true) {
            TopFloaterView().createTopFloaterView(errMsg: errMsg)
             }

    }
    
    func openCustomURL(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func resetViewModel() {
        firebaseViewModel.lastSevenDaysLog = []
        firebaseViewModel.pieceList = []
        firebaseViewModel.pieceArray = []
    }

}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        
        SettingsView(firebaseViewModel: FirebaseViewModel(), index: .constant(0))
            
        
    }
}
