//
//  CardView.swift
//  PianoFly
//
//  Created by Derek Hsieh on 4/23/21.
//

import SwiftUI

struct CardView: View {
    var piece: Piece
    var body: some View {
        
        
        RoundedRectangle(cornerRadius: 25)
            .fill(Color.white)
            .frame(width: 175, height: 175)
            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 0)
            .overlay(
                VStack {
                    
                    HStack {
                        Spacer()
                        
                        Image(systemName: "music.note.list")
                            .foregroundColor(.gray)
                            .font(.title2)
                    }
                        
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        
                        
                        
                        Text(piece.title)
                            .font(.title3)
                            .bold()
                            
                            
                        
                        Text(piece.composer)
                    }
         
                }
                .padding()
            
            )
            
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.opacity(0.09).edgesIgnoringSafeArea(.vertical)
            CardView(piece: Piece(uuid: UUID(), composer: "Chopin", title: "Piano Concerto No. 2"))
        }
            
    }
}
