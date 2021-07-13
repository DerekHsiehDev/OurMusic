//
//  PieceBreakdownView.swift
//  PianoFly
//
//  Created by Derek Hsieh on 7/5/21.
//

import SwiftUI

struct PieceBreakdownView: View {
    
    var pieceTitle: String
    var practiceMinutes: Int
    var iconColor: Color
    
    var body: some View {
        HStack {
            
            Text(returnIconName(pieceTitle: pieceTitle))
                .foregroundColor(.white)
                .font(.title2)
                .bold()
                .background(
                
                    RoundedRectangle(cornerRadius: 10)
                        .fill(iconColor)
                        .shadow(color: Color.black.opacity(0.6), radius: 4, x: 0, y: 0)
                        .frame(width: 70, height: 70)
                
                )
                .padding()
         
                
            
            VStack(alignment: .leading) {
                Text(pieceTitle)
                    .fontWeight(.semibold)
                    .font(.title3)
                
                HStack {
                    Spacer()
                    Text("\(practiceMinutes) \("mins")")
                        .fontWeight(.semibold)
                        .font(.title3)
                   
                }
                
            }
            .padding(.horizontal)
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width - 60)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        
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

struct PieceBreakdownView_Previews: PreviewProvider {
    static var previews: some View {
        
        ZStack {
            Color.MyTheme.LightPurple
            PieceBreakdownView(pieceTitle: "Fugue", practiceMinutes: 45, iconColor: Color.blue)
        }
    
           
    }
}

