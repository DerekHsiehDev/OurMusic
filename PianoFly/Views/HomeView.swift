//
//  HomeView.swift
//  PianoFly
//
//  Created by Derek Hsieh on 7/5/21.
//

import SwiftUI

struct HomeView: View {
    
    @State var selectedIndex: Int = 0
    @State var date: Int = 5
//    let pieceList: [Piece] = [
//        Piece(composer: "Chopin", title: "Piano Concerto No. 2", practiceArray: [PracticeDays(date: "7-10-2021", practiceMinutes: 13)], thisWeekPracticeMinutes: 70, allTimePracticeMinutes: 450, iconColor: "blue"),
//        Piece(composer: "Bach", title: "Fugue", practiceArray: [PracticeDays(date: "7-10-2021", practiceMinutes: 13)], thisWeekPracticeMinutes: 70, allTimePracticeMinutes: 450, iconColor: "red"),
//        Piece(composer: "Kapustin", title: "Concert Etude", practiceArray: [PracticeDays(date: "7-10-2021", practiceMinutes: 13)], thisWeekPracticeMinutes: 70, allTimePracticeMinutes: 450, iconColor: "orange"),
//
//    ]
    @StateObject var firebaseViewModel: FirebaseViewModel
    @Binding var selectedPiece: Piece?
    @Binding var isShowingPieceView: Bool
    @Binding var isShowingFormView: Bool
    @Binding var isShowingPracticeLogView: Bool
    @State var currentDayShowing: Date = Date()
    
    var body: some View {
        VStack {
            
            TopBarView(isShowingFormView: $isShowingFormView, isShowingPracticeLogView: $isShowingPracticeLogView, leftImage: "tray", rightImage: "doc.badge.plus", title: "Home")
                .padding(.bottom)
            
            HStack {
                Button(action: {
                    self.selectedIndex = 0
                }, label: {
                    Text("1 Day")
                        .padding(.vertical, 12)
                        .frame(width: (UIScreen.main.bounds.width / 2) - 15)
                        .foregroundColor(.white.opacity(selectedIndex == 0 ? 1 : 0.65))

                })
                    .background(self.selectedIndex == 0 ? Color.MyTheme.DarkPurple : Color.clear)
                .clipShape(Capsule())
                
                Button(action: {
                    self.selectedIndex = 1
                }, label: {
                    Text("7 Days")
                        .padding(.vertical, 12)
                        .frame(width: (UIScreen.main.bounds.width / 2) - 30)
                        .foregroundColor(.white.opacity(selectedIndex == 1 ? 1 : 0.65))

                })
                    .background(self.selectedIndex == 1 ? Color.MyTheme.DarkPurple : Color.clear)
                    .clipShape(Capsule())
            }
            .background(Color.MyTheme.LightPurple)
            .clipShape(Capsule())
            .padding(.bottom)
            
            
            ScrollView(showsIndicators: false){
                // Toggle Slider
             
                
                // Today's view
                HStack {
                    // Date picker
                    VStack(spacing: 10) {
                        Button(action: {
                            
                            increaseDate()
                            
                        }) {
                            Image(systemName: "chevron.up")
                        }
                        .accentColor(.white)
                        
                        VStack(spacing: 0) {
                            Text(DateHelper.instance.formatDate(date: currentDayShowing, dateFormat: "d"))
                                .bold()
                                .font(.largeTitle)
                            .foregroundColor(.white)
                            
                            Text(DateHelper.instance.formatDate(date: currentDayShowing, dateFormat: "MMM"))
                                .bold()
                                .font(.title2)
                                .foregroundColor(.white)
                        }
          
                        
                        
                        Button(action: {
                            
                            decreaseDate()
                            
                        }) {
                            Image(systemName: "chevron.down")
                        }
                        .accentColor(.white)
                    }
                    
                    // Middle Card: practice minutes
                    Spacer(minLength: 0)
                    VStack(spacing: 20) {
                        Image(systemName: "music.note.list")
                            .foregroundColor(.white)
                            .font(.title.weight(.bold))
                        
                        ZStack {
                            Text("104")
                            
                                .bold()
                                .lineLimit(1)
                                .font(.largeTitle)
                                
                            .foregroundColor(.clear)
                            
                            Text("\(self.returnTodaysPracticeMinutes() == -1 ? "" : "\(self.returnTodaysPracticeMinutes())")")
                                .bold()
                                .lineLimit(1)
                                .font(.largeTitle)
                            .foregroundColor(.white)
                        }
                        
                        Text("mins")
                            .foregroundColor(.white)
                        
                    }
                    .padding()
                    .background( Color(#colorLiteral(red: 0.9921568627, green: 0.5529411765, blue: 0.6941176471, alpha: 1)))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding(.horizontal)
                    .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 0)
                    
                    VStack(spacing: 20) {
                        Image(systemName: "music.quarternote.3")
                            .foregroundColor(.white)
                            .font(.title.weight(.bold))
                        
                        ZStack {
                            Text("\(4)")
                                .bold()
                                .font(.largeTitle)
                                .lineLimit(1)
                            .foregroundColor(.clear)
                            
                            Text("\(self.returnNumberOfPieces() == -1 ? "" : "\(self.returnNumberOfPieces())")")
                                .bold()
                                .font(.largeTitle)
                            .foregroundColor(.white)
                        }
                        
                        Text("pieces")
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        
                    }
                    .padding()
                    .background(Color.MyTheme.LightPurple)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding(.horizontal)
                    .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 0)
                  
                }
                
                .padding()
                
                
                .background(Color.MyTheme.MediumPurple)
           
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding(.horizontal)
                
                // Piece breakdown
                
                VStack(spacing: 0) {
                    
                    if checkIfUserPracticedOnADayThroughLastSevenDaysLog(date: currentDayShowing, log: firebaseViewModel.lastSevenDaysLog) {
                        
                        ForEach(firebaseViewModel.pieceList, id: \.self) { piece in
                            
                            if returnPieceArrayElementFromDateString(date: currentDayShowing, piece: piece) != 0 {
                                PieceBreakdownView(pieceTitle: piece.title, practiceMinutes: returnPieceArrayElementFromDateString(date: currentDayShowing, piece: piece), iconColor: Color(piece.iconColor))
                                    .padding()
                                    .onTapGesture {
                                        selectedPiece = piece
                                        isShowingPieceView.toggle()
                                    }
                            }
                         
                            
                        }
                    } else {
                        Text("No Practice Log Yet")
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width - 60)
                            .padding()
                    }
                 
                
                }
                .background(Color.MyTheme.LightPurple)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            

            
           
            
            Spacer(minLength: 0)
        }
        
        
    }
    
    func returnNumberOfPieces() -> Int {
        for log in firebaseViewModel.lastSevenDaysLog {
            if log.postID == DateHelper.instance.convertDateToCustomString(dateToConvert: currentDayShowing) {
                
                return log.pieces?.count ?? 0
            }
        }
        
        return -1
    }
    
    func returnTodaysPracticeMinutes() -> Int {
        for log in firebaseViewModel.lastSevenDaysLog {
            if log.postID == DateHelper.instance.convertDateToCustomString(dateToConvert: currentDayShowing) {
                return log.practiceMinutes
            }
            
        }
        return -1
    }
    
    func returnPieceArrayElementFromDateString(date: Date, piece: Piece) -> Int {
        
        let dateString = DateHelper.instance.formatDate(date: date, dateFormat: "MM-dd-yyyy")
        
        for practice in piece.practiceArray {
            if practice.date == dateString {
                
                return practice.practiceMinutes
            }
        }
        
        
        
        return 0
    }
    
    func checkIfUserPracticedOnADayThroughLastSevenDaysLog(date: Date, log: [PostModel]) -> Bool {
        let dateString = DateHelper.instance.formatDate(date: date, dateFormat: "MM-dd-yyyy")
        for post in log {
            if post.postID == dateString {
                if post.practiceMinutes == 0 {
                    return false
                } else {
                    return true
                }
            }
        }
        
        return false
    }
    
    func increaseDate() {
        let newDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDayShowing)!
        // check if new date is greater than current day - cant go over
        if newDate < Date() {
            currentDayShowing = newDate
        }
    }
    
    func decreaseDate() {
        currentDayShowing = Calendar.current.date(byAdding: .day, value: -1, to: currentDayShowing)!
    }
    
    
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView(, selectedPiece: <#Binding<Piece?>#>)
//    }
//}
