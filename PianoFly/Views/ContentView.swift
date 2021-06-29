//
//  ContentView.swift
//  PianoFly
//
//  Created by Derek Hsieh on 4/19/21.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var firebaseViewModel = FirebaseViewModel()
    @State var index = 0
    @State var isShowingPracticeLogView = false
    @StateObject var practiceModel = PracticeModel()
    @AppStorage(CurrentUserDefaults.userID) var userID: String?
    
    var body: some View {
     
        if userID == nil {
            SignUpView()
                .statusBar(hidden: true)
        } else {
         
            
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    ZStack {
                        
                        HomeView2(practiceModel: practiceModel, firebaseViewModel: firebaseViewModel)
                            .edgesIgnoringSafeArea(.all)
                            .opacity(self.index == 0 ? 1 : 0)
                            .zIndex(self.index == 0 ? 1 : 0)
                        
                        Color.green
                            .opacity(self.index == 1 ? 1 : 0)
                      
                        
                        SettingsView(index: $index)
                            .opacity(self.index == 3 ? 1 : 0)
                            
                    }
                    .padding(.bottom, -35)
                    
                    CustomTabs(index: self.$index, isShowingPracticeLogView: $isShowingPracticeLogView)
                }
                
                PracticeLogView(isShowing: $isShowingPracticeLogView, practiceModel: practiceModel, firebaseViewModel: firebaseViewModel)
                    .offset(y: isShowingPracticeLogView ? 0 : UIScreen.main.bounds.height * 3)
                    .edgesIgnoringSafeArea(.horizontal)
                
                
                    
            }
            .statusBar(hidden: true)
            .onAppear {
                print("appeared")
                firebaseViewModel.getFullPracticeLog(userID: userID!) { isFinished in
                        print("FETCHED ALL USER POSTS")
                }
            }
        }
        
       

        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
