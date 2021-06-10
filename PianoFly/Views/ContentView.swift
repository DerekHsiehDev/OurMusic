//
//  ContentView.swift
//  PianoFly
//
//  Created by Derek Hsieh on 4/19/21.
//

import SwiftUI

struct ContentView: View {
    
    @State var index = 0
    @State var isShowingPracticeLogView = false
    @StateObject var practiceModel = PracticeModel()
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    var body: some View {
     
       if isLoggedIn {
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    ZStack {
                        
                        HomeView(practiceModel: practiceModel)
                            .edgesIgnoringSafeArea(.all)
                            .opacity(self.index == 0 ? 1 : 0)
                            .zIndex(self.index == 0 ? 1 : 0)
                        
                        Color.green
                            .opacity(self.index == 1 ? 1 : 0)
                            .opacity(self.index == 1 ? 1 : 0)
                            
                    }
                    .padding(.bottom, -35)
                    
                    CustomTabs(index: self.$index, isShowingPracticeLogView: $isShowingPracticeLogView)
                        .padding(.bottom)
                }
                
                PracticeLogView(isShowing: $isShowingPracticeLogView, practiceModel: practiceModel)
                    .offset(y: isShowingPracticeLogView ? 0 : UIScreen.main.bounds.height * 3)
                    .edgesIgnoringSafeArea(.horizontal)
                
                
                    
            }
            .statusBar(hidden: true)
        } else {
            SignUpView()
                .statusBar(hidden: true)
        }
        
       

        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
