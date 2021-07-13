//
//  PieceSelectionView.swift
//  PianoFly
//
//  Created by Derek Hsieh on 7/11/21.
//

import SwiftUI

struct PieceSelectionView: View {
    @Binding var selectedPiece: UserPiece
    @Binding var showPieceBottomSheet: Bool
    
    var pieceArray: [UserPiece]
    
    var body: some View {
        VStack {
            
            Text("Select one of your pieces to add practice minutes to")
                .font(.title2)
                   .multilineTextAlignment(.center)
                   .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
                .padding(.top)
                
                
                
            if CGFloat(pieceArray.count * 145) > UIScreen.main.bounds.height {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(pieceArray, id: \.self) { piece in
                        HStack {
                            Text(returnIconName(pieceTitle: piece.pieceTitle))
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
                                Text(piece.pieceTitle)
                                    .bold()
                                    .font(.system(.title, design: .rounded))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.4)
                                
                                Text(piece.composer)
                            }
                            .padding()
                            
                            Spacer(minLength: 0)
                            
                                
                            
                        }.padding()
                            .padding(.horizontal)
                            .onTapGesture {
                                self.selectedPiece = piece
                                self.showPieceBottomSheet.toggle()
                            }

                    }
                }
                .padding()
            } else {
                ForEach(pieceArray, id: \.self) { piece in
                    HStack {
                        Text(returnIconName(pieceTitle: piece.pieceTitle))
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
                            Text(piece.pieceTitle)
                                .bold()
                                .font(.system(.title, design: .rounded))
                                .lineLimit(1)
                                .minimumScaleFactor(0.4)
                            
                            Text(piece.composer)
                        }
                        .padding()
                        
                        Spacer(minLength: 0)
                        
                            
                        
                    }.padding()
                        .padding(.horizontal)
                        .onTapGesture {
                            self.selectedPiece = piece
                            self.showPieceBottomSheet.toggle()
                        }

                }
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

struct PieceSelectionView_Previews: PreviewProvider {

    static var previews: some View {
        PieceSelectionView(selectedPiece: .constant(UserPiece(pieceTitle: "", composer: "", iconColor: "")), showPieceBottomSheet: .constant(true), pieceArray: [UserPiece(pieceTitle: "Piano Concerto No. 2", composer: "Chopin", iconColor: "blue"), UserPiece(pieceTitle: "Fugue", composer: "Bach", iconColor: "red")])
        
    }
}
