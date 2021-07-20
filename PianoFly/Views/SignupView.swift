//
//  SignupView.swift
//  PianoFly
//
//  Created by Derek Hsieh on 4/24/21.
//


import SwiftUI
import FirebaseAuth
import FirebaseFirestore


struct SignUpView: View {
  
   
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            LinearGradient(gradient: .init(colors: [Color(#colorLiteral(red: 0.5647058824, green: 0.5058823529, blue: 0.9529411765, alpha: 1)), Color(#colorLiteral(red: 0.3411764706, green: 0.2901960784, blue: 0.8862745098, alpha: 1))]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.vertical)
            
            
            
                Home()

            
        }

        
    }
        
}

struct SignUpViewPreview: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

struct Home : View {
    
    @State var displayName: String = ""
    @State var email: String = ""
    @State var providerID: String = ""
    @State var provider: String = ""
    @State var showError: Bool = false
    @State var index = 0
    @State var showOnboardingForSignupWithApple: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    var body : some View {
        
        VStack {
            
            
            if index == 0 {
                Image("Rounded Logo")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .shadow(color: Color.black.opacity(0.7), radius: 3, x: 0, y: 0)
                
                Spacer()
            }
            
        
            
            HStack{
                
                
                
                Button(action: {
                    
                    withAnimation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.5)){

                       self.index = 0
                    }
                    
                
                    
                }) {
                    
                    Text("Login")
                        .foregroundColor(self.index == 0 ? .black : .white)
                        .fontWeight(.bold)
                        .padding(.vertical, 10)
                        .frame(width: (UIScreen.main.bounds.width - 50) / 2)
                    
                }.background(self.index == 0 ? Color.white : Color.clear)
                .clipShape(Capsule())
                
                Button(action: {
                    
                   withAnimation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.5)){
                       
                      self.index = 1
                   }
                    
                }) {
                    
                    Text("Sign Up")
                        .foregroundColor(self.index == 1 ? .black : .white)
                        .fontWeight(.bold)
                        .padding(.vertical, 10)
                        .frame(width: (UIScreen.main.bounds.width - 50) / 2)
                    
                }.background(self.index == 1 ? Color.white : Color.clear)
                .clipShape(Capsule())
                
            }.background(Color.black.opacity(0.1))
            .clipShape(Capsule())
            .padding(.top, 25)
            
            if self.index == 0 {
                
                Login()
                
                Spacer(minLength: 0)
            }
            else{
                
                SignUp()
            }
            
            if self.index == 0 {
                
                Button(action: {
                    
                }) {
                    
                    Text("Forget Password?")
                        .foregroundColor(.white)
                
                }
                .padding(.top, 20)
            }
            
            HStack(spacing: 15){
                
                Color.white.opacity(0.7)
                .frame(width: 35, height: 1)
                
                Text("Or")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Color.white.opacity(0.7)
                .frame(width: 35, height: 1)
                
            }
            .padding(.top, 10)
            
            Button(action: {
                
                SignInWithApple.instance.startSignInWithAppleFlow(view: self)
                
            }, label: {
                
                
                HStack {
                    
                    Image(systemName: "applelogo")
                    
                    Text("Sign up with Apple")
         
                }
                
                .foregroundColor(.white)
                .padding()
                .padding(.horizontal)
             
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.black)
                        
                )

            })
            
        
            
        }
        .padding()
        .fullScreenCover(isPresented: $showOnboardingForSignupWithApple, onDismiss: {
            self.presentationMode.wrappedValue.dismiss()
        }, content: {
            OnboardingView(showOnboardingForSignupWithApple: $showOnboardingForSignupWithApple)
                .preferredColorScheme(.light)
        })
        .alert(isPresented: $showError, content: {
            return Alert(title: Text("Error signing in with Apple 😰"))
        })
        
    }
    
    // MARK: FUNCTIONS
    
    func connectToFirebase(name: String, email: String, provider: String, credential: AuthCredential) {
        
        AuthService.instance.logInUserToFirebase(credential: credential) { returnedProviderID, isError, isNewUser, returnedUserID in
            
            if let newUser = isNewUser {
                
                if newUser {
                    // new user
                    print("NEW USER")
                    
                    if let providerID = returnedProviderID, !isError {
                        // SUCCESS
                
                        // new user, continue to onboarding part 2
                        self.displayName = name
                        self.email = email
                        self.providerID = providerID
                        self.provider = provider
                        self.showOnboardingForSignupWithApple.toggle()
                        
                    } else {
                        // ERROR
                        print("error getting provider id from log in user to firebase")
                        self.showError.toggle()
                    }
                    
                } else {
                    // existing user
                    print("EXISTINGH USER")
                    if let userID = returnedUserID {
                        
                        AuthService.instance.logInUserToApp(userID: userID) { success in
                            if success {
                                print("Successful log in existing user")
                            } else {
                                print("error loggin existin guser into our app")
                                self.showError.toggle()
                            }
                        }
                        
                    } else {
                        // ERROR
                        print("error getting provider id from existing user to firebase")
                        self.showError.toggle()
                    }
                    
                }
                
            } else {
                // ERROR
                print("error getting info when loggin in user to Firebase")
                self.showError.toggle()
            }
            
       
        }
    }
}

struct Login : View {
    
    @State var mail = ""
    @State var pass = ""
    @State var showPass = false
    @State var alert = ""
    
    
    var body : some View {
        
        VStack{
            
            VStack{
                Text(alert)
                    .foregroundColor(.red)
                    .lineLimit(nil)
                
                HStack(spacing: 15){
                    
                   
                    
                    Image(systemName: "envelope")
                        .foregroundColor(.black)
                    
                    TextField("Enter Email Address", text: self.$mail)
                        .keyboardType(.emailAddress)
                    
                }.padding(.vertical, 20)
                
                Divider()
                
                HStack(spacing: 15){
                    
                    Image(systemName: "lock")
                    .resizable()
                    .frame(width: 15, height: 18)
                    .foregroundColor(.black)
                    
                    if showPass {
                        TextField("Password", text: self.$pass)
                    } else {
                        SecureField("Password", text: self.$pass)
                    }
                    
                    
                    
                    Button(action: {
                        showPass.toggle()
                    }) {
                        
                        Image(systemName: "eye")
                            .foregroundColor(.black)
                    }
                    
                }.padding(.vertical, 20)
                
            }
            .padding(.vertical)
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
            .background(Color.white)
            .cornerRadius(10)
            .padding(.top, 25)
            
            
            
            Button(action: {
                checkFieldsAndUpdateAlert()
            }) {
                
                Text("LOGIN")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 100)
                
            }.background(
            
                LinearGradient(gradient: .init(colors: [Color(#colorLiteral(red: 0.5647058824, green: 0.5058823529, blue: 0.9529411765, alpha: 1)), Color(#colorLiteral(red: 0.3411764706, green: 0.2901960784, blue: 0.8862745098, alpha: 1))]), startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(8)
            .offset(y: -40)
            .padding(.bottom, -40)
            .shadow(radius: 15)
        }
    }
    
    func checkFieldsAndUpdateAlert() {
        
        
        if pass.isEmpty {
            self.alert = "Please enter your password"
        }
        
        else if !mail.isValidEmail() {
            self.alert = "Please enter a valid email"
        } else {
            SignInWithEmail.instance.signInExistingUserWithEmail(email: mail, password: pass) { isError, returnedAlertMessage in
                if isError {
                    self.alert = returnedAlertMessage ?? ""
                } else {
                    return
                }
            }
        }
    }
}

struct SignUp : View {
    @AppStorage("isLoggedIn") var isLoggedIn = false
    @State var mail = ""
    @State var pass = ""
    @State var repass = ""
    @State var firstN = ""
    @State var lastN = ""
    @State var showPass = false
    @State var alert = ""
    
    
    
    var body : some View{
        
        VStack{
            
    
            
            VStack{
                
                Text(alert)
                    .foregroundColor(.red)
                    .lineLimit(nil)
                
                HStack(spacing: 15){
                    
                    Image(systemName: "envelope")
                        .foregroundColor(.black)
                    
                    TextField("Enter Email Address", text: self.$mail)
                        .keyboardType(.emailAddress)
                    
                }.padding(.vertical, 20)
                
                Divider()
                
                HStack(spacing: 15){
                    
                    Image(systemName: "person")
                        .foregroundColor(.black)
                    
                    TextField("First Name", text: self.$firstN)
                    
                }.padding(.vertical, 20)
                
                Divider()
                
                HStack(spacing: 15){
                    
                    Image(systemName: "person.fill")
                        .foregroundColor(.black)
                    
                    TextField("Last Name", text: self.$lastN)
                    
                }.padding(.vertical, 20)
                
                Divider()
                
                HStack(spacing: 15){
                    
                    Image(systemName: "lock")
                    .resizable()
                    .frame(width: 15, height: 18)
                    .foregroundColor(.black)
                    
                    if showPass {
                        TextField("Password", text: self.$pass)
                    } else {
                        SecureField("Password", text: self.$pass)
                    }
                    
                    
                    Button(action: {
                        showPass.toggle()
                    }) {
                        
                        Image(systemName: "eye")
                            .foregroundColor(showPass ? .gray : .black)
                    }
                    
                }.padding(.vertical, 20)
                
                Divider()
                
                HStack(spacing: 15){
                    
                    Image(systemName: "lock")
                    .resizable()
                    .frame(width: 15, height: 18)
                    .foregroundColor(.black)
                    
                    if showPass {
                        TextField("Re-Enter", text: self.$repass)
                    } else {
                        SecureField("Re-Enter", text: self.$repass)
                    }
                    
                    
                    
                    Button(action: {
                        showPass.toggle()
                    }) {
                        
                        Image(systemName: "eye")
                            .foregroundColor(showPass ? .gray : .black)
                    }
                    
                }.padding(.vertical, 20)
                
            }
            .padding(.vertical)
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
            .background(Color.white)
            .cornerRadius(10)
            .padding(.top, 25)
            
            
            Button(action: {
                checkFieldsAndUpdateAlert()
            }) {
                
                Text("SIGNUP")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 100)
                
            }.background(
            
                LinearGradient(gradient: .init(colors: [Color(#colorLiteral(red: 0.5647058824, green: 0.5058823529, blue: 0.9529411765, alpha: 1)), Color(#colorLiteral(red: 0.3411764706, green: 0.2901960784, blue: 0.8862745098, alpha: 1))]), startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(8)
            .offset(y: -40)
            .padding(.bottom, -40)
            .shadow(radius: 15)
        }
    }
    
    
    func checkFieldsAndUpdateAlert() {
        
        if pass.isEmpty || mail.isEmpty || firstN.isEmpty || lastN.isEmpty || repass.isEmpty {
            self.alert = "Please fill out all fields"
        }
        
        else if !mail.isValidEmail() {
            self.alert = "Please enter a valid email"
        }
        
        else if pass != repass {
            self.alert = "Passwords do not match"
        } else {
            SignInWithEmail.instance.createNewUserUsingEmail(mail: mail, password: pass, firstName: firstN, lastName: lastN) { isError, alertMessage in
                if isError {
                    self.alert = alertMessage ?? ""
                }
            }
         
        }
    }
}

extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}
