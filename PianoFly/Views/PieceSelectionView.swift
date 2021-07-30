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
    @State private var showAlert = false
    @State var deletedPiece: UserPiece? = nil
    @StateObject var firebaseViewModel: FirebaseViewModel
    
    var body: some View {
        VStack {
            
            VStack {
                Text("Select one of your pieces to add practice minutes to")
                    .fontWeight(.semibold)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                    .padding(.top)
            }
            
            
            
            if CGFloat(firebaseViewModel.pieceArray.count * 160) > UIScreen.main.bounds.height {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(firebaseViewModel.pieceArray, id: \.self) { piece in
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
                            
                            Button(action: {
                                showAlert.toggle()
                                //                                deletePieceFromList(piece: piece)
                                self.deletedPiece = piece
                            }) {
                                Text(Image(systemName: "xmark"))
                                    .fontWeight(.bold)
                                
                            }
                            .accentColor(.red)
                            
                            
                            
                        }.padding()
                        .padding(.horizontal)
                        .onTapGesture {
                            self.selectedPiece = piece
                            self.showPieceBottomSheet.toggle()
                        }
                        
                    }
                }
                .padding()
                .padding(.bottom)
            } else {
                ForEach(firebaseViewModel.pieceArray, id: \.self) { piece in
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
                        
                        Button(action: {
                            showAlert.toggle()
                            self.deletedPiece = piece
                            //                            deletePieceFromList(piece: piece)
                        }) {
                            Text(Image(systemName: "xmark"))
                                .fontWeight(.bold)
                            
                        }
                        .accentColor(.red)
                        
                        
                        
                    }.padding()
                    .padding(.horizontal)
                    .padding(.bottom)
                    .onTapGesture {
                        self.selectedPiece = piece
                        self.showPieceBottomSheet.toggle()
                    }
                    
                }
            }
            
            
        }
        .alert(isPresented: $showAlert) {
            let button = Alert.Button.destructive(Text("Yes")) {
                self.deletePieceFromList()
                        }
            return Alert(title: Text("Are you sure you want to delete this piece?"), message: Text("All previous records of this piece will be deleted"), primaryButton: button, secondaryButton: .cancel(Text("No")))
        }
    }
    
    func deletePieceFromList() {
        let piece = deletedPiece
        if piece == nil {
            return
        } else {
            UploadToFirebaseHelper.instance.deletePiece(documentID: piece!.pieceTitle)
            for(index, item) in firebaseViewModel.pieceArray.enumerated() {
                if item == piece {
                    firebaseViewModel.pieceArray.remove(at: index)
                }
            }
            
            firebaseViewModel.savePieceArrayToUserDefaults(pieceArray: firebaseViewModel.pieceArray)
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
        PieceSelectionView(selectedPiece: .constant(UserPiece(pieceTitle: "", composer: "", iconColor: "")), showPieceBottomSheet: .constant(true), firebaseViewModel: FirebaseViewModel())
        
    }
}
