//
//  PieceView.swift
//  PianoFly
//
//  Created by Derek Hsieh on 7/6/21.
//

import SwiftUI

struct PieceView: View {
    
    var piece: Piece
    
    var body: some View {
        VStack {
            HStack {
                Text(returnIconName(pieceTitle: piece.title))
                    .foregroundColor(.white)
                    .font(.title2)
                    .bold()
                    .background(
                    
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(piece.iconColor))
                            .shadow(color: Color.black.opacity(0.6), radius: 4, x: 0, y: 0)
                            .frame(width: 70, height: 70)
                    
                    )
                    .padding()
                
                
                
                VStack(alignment: .leading) {
                    Text(piece.title)
                        .bold()
                        .font(.system(.title, design: .rounded))
                        
                    
                    Text(piece.composer)
                }
                .padding()
                
              Spacer(minLength: 0)
                    
                
            }
            .padding(.horizontal)
            .padding(.leading)
            
            VStack(spacing: 10) {
                HStack {
                    // box 1
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("\(piece.practiceArray[piece.practiceArray.endIndex - 1].practiceMinutes)")
                                .foregroundColor(.white)
                                .font(.largeTitle)
                                .bold()
                            
                            
                            Text("minutes")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.title3)
                            
                            Spacer()
                        }
                        .padding()
                        
                        Spacer()
                        
                        Text("today")
                            .foregroundColor(.white)
                            .bold()
                            .padding()
                            .font(.largeTitle)
                            
                    }
                    
                    .frame(width: (UIScreen.main.bounds.width/2) - 25, height: (UIScreen.main.bounds.width/2) - 25)
                    
                    .background(RoundedRectangle(cornerRadius: 22).fill(Color(#colorLiteral(red: 0.9019607843, green: 0.4941176471, blue: 0.1333333333, alpha: 1))))
                    
                    
                    // box 2
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("\(piece.thisWeekPracticeMinutes)")
                                .foregroundColor(.white)
                                .font(.largeTitle)
                                .bold()
                            
                            
                            Text("minutes")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.title3)
                            
                            Spacer()
                        }
                        .padding()
                        
                        Spacer()
                        
                        Text("week")
                            .foregroundColor(.white)
                            .bold()
                            .padding()
                            .font(.largeTitle)
                            
                    }
                    
                    .frame(width: (UIScreen.main.bounds.width/2) - 25, height: (UIScreen.main.bounds.width/2) - 25)
                    
                    .background(RoundedRectangle(cornerRadius: 22).fill(Color(#colorLiteral(red: 0.2823529412, green: 0.2039215686, blue: 0.831372549, alpha: 1))))
                }
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(piece.thisWeekPracticeMinutes)")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .bold()
                        
                        
                        Text("minutes")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.title3)
                        
                        Spacer()
                    }
                    .padding()
                    
                    Spacer()
                    
                    HStack {
                        
                        Spacer()
                        Text("all time")
                            .foregroundColor(.white)
                            .bold()
                            .padding()
                            .font(.largeTitle)
                    }
                        
                }
                
                .frame(width: (UIScreen.main.bounds.width) - 50, height: (UIScreen.main.bounds.width/2) - 25)
                
                .background(RoundedRectangle(cornerRadius: 22).fill(Color(#colorLiteral(red: 0.4941176471, green: 0.8392156863, blue: 0.8745098039, alpha: 1))))
                
            }
        }
    }
    
    
    func returnIconName(pieceTitle: String) -> String {
        let components = pieceTitle.components(separatedBy: .whitespacesAndNewlines)
        let words = components.filter { !$0.isEmpty }

        
        if words.count > 1 {
         
            let iconName = words[0][0] + words[1][0]
            return iconName
            
        } else {
            return String(pieceTitle.prefix(2))
        }

        
    }
}

struct PieceView_Previews: PreviewProvider {
    static var previews: some View {
        PieceView(piece: Piece(composer: "Chopin", title: "Piano Concerto No. 2", practiceArray: [PracticeDays(date: "7-10-2021", practiceMinutes: 12)], thisWeekPracticeMinutes: 150, allTimePracticeMinutes: 1200, iconColor: "blue"))
    }
}
