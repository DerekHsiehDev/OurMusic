//
//  ContentView.swift
//  PianoFly
//
//  Created by Derek Hsieh on 4/19/21.
//

import SwiftUI
import BottomSheet

struct ContentView: View {
    
    @State var isShowingFormView: Bool = false
    @StateObject var firebaseViewModel = FirebaseViewModel()
    @State var index = 0
    @State var isShowingPracticeLogView = false
    
//    @StateObject var practiceModel = PracticeModel()
    @AppStorage(CurrentUserDefaults.userID) var userID: String?
    
    @State var isShowingPieceView: Bool = false
    @State var selectedPiece: Piece? = nil
    
    var body: some View {
     
        if userID == nil {
            SignUpView()
                .statusBar(hidden: true)
        } else {
         
            
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    ZStack {
                        
                        HomeView(selectedPiece: $selectedPiece, isShowingPieceView: $isShowingPieceView, isShowingFormView: $isShowingFormView, isShowingPracticeLogView: $isShowingPracticeLogView)
                        
                            .opacity(self.index == 0 ? 1 : 0)
                            .zIndex(self.index == 0 ? 1 : 0)
                        
                        Color.green
                            .opacity(self.index == 1 ? 1 : 0)
                      
                        
                        SettingsView(index: $index)
                            .opacity(self.index == 3 ? 1 : 0)
                            
                    }
                    
                    TabView(index: $index)
                }
                
//                PracticeLogView(isShowing: $isShowingPracticeLogView, practiceModel: practiceModel, firebaseViewModel: firebaseViewModel)
//                    .offset(y: isShowingPracticeLogView ? 0 : UIScreen.main.bounds.height * 3)
//                    .edgesIgnoringSafeArea(.horizontal)
                
                
                    
            }
            .statusBar(hidden: true)
            .onAppear {
                print("appeared")
//                firebaseViewModel.getFullPracticeLog(userID: userID!) { isFinished in
//                        print("FETCHED ALL USER POSTS")
//                }
                firebaseViewModel.getAllPieces()
                
            }
            .bottomSheet(isPresented: $isShowingPieceView, height: (UIScreen.main.bounds.width) + 100) {
                PieceView(piece: self.selectedPiece ?? Piece(composer: "", title: "", practiceArray: [PracticeDays(date: "7-10-2021", practiceMinutes: 123)], thisWeekPracticeMinutes: 0, allTimePracticeMinutes: 0, iconColor: Color.clear))
            }
            .sheet(isPresented: $isShowingFormView) {
                FormView(firebaseViewModel: firebaseViewModel)
            }
            .sheet(isPresented: $isShowingPracticeLogView) {
                PracticeLogView(isShowing: $isShowingPracticeLogView, firebaseViewModel: firebaseViewModel)
            }
            
        }
        
       

        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
