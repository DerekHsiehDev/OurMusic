//
//  OnboardingView.swift
//  PianoFly
//
//  Created by Derek Hsieh on 6/10/21.
//

import SwiftUI
import FirebaseAuth

struct OnboardingView: View {
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var showLastNameTextField: Bool = false
    @Binding var showOnboardingForSignupWithApple: Bool
    var body: some View {
        ZStack {
            
            LinearGradient(gradient: .init(colors: [Color(#colorLiteral(red: 0.5647058824, green: 0.5058823529, blue: 0.9529411765, alpha: 1)), Color(#colorLiteral(red: 0.3411764706, green: 0.2901960784, blue: 0.8862745098, alpha: 1))]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.vertical)
            
            VStack(spacing: 30) {
                Text("What's your \(showLastNameTextField ? "last" : "first") name?")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.MyTheme.yellowColor)
                
                if showLastNameTextField {
                    TextField("Add your last name here...", text: $lastName)
                        .padding()
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(12)
                        .font(.headline)
                        .autocapitalization(.sentences)
                        .padding(.horizontal)
                    
                    Button(action: {
                        // sign in
                        signInUser(firstName: firstName, lastName: lastName)
                    }) {
                        Text("Finish")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding()
                            .frame(height: 60)
                            .frame(maxWidth: .infinity)
                            .background(Color.MyTheme.yellowColor)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    .accentColor(Color(#colorLiteral(red: 0.3411764706, green: 0.2901960784, blue: 0.8862745098, alpha: 1)))
                    .opacity(lastName != "" ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 1.0))
                } else {
                    TextField("Add your first name here...", text: $firstName)
                        .padding()
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(12)
                        .font(.headline)
                        .autocapitalization(.sentences)
                        .padding(.horizontal)
                    
                    Button(action: {
                        // show last name text view + button
                        withAnimation {
                            showLastNameTextField.toggle()
                        }
                        
                    }) {
                        Text("Next: Add Last Name")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding()
                            .frame(height: 60)
                            .frame(maxWidth: .infinity)
                            .background(Color.MyTheme.yellowColor)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    .accentColor(Color(#colorLiteral(red: 0.3411764706, green: 0.2901960784, blue: 0.8862745098, alpha: 1)))
                    .opacity(firstName != "" ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 1.0))
                }
                
                
            }
        }
        
        
        
    }
    
    func signInUser(firstName: String, lastName: String) {
        if let userID = Auth.auth().currentUser?.uid {
            SignInWithEmail.instance.logInUser(userID: userID, firstName: firstName, lastName: lastName) { isError, isFinished in
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    print("dismissed")
                    self.showOnboardingForSignupWithApple.toggle()
                    
                    
                    
                    
                }
                
            }
        }
        
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(showOnboardingForSignupWithApple: .constant(true))
            .preferredColorScheme(.light)
    }
}
