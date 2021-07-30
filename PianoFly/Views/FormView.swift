//
//  FormView.swift
//  PianoFly
//
//  Created by Derek Hsieh on 7/10/21.
//

import SwiftUI

struct FormView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var pieceTitle: String = ""
    @State private var composer: String = ""
    @State private var selectedColor: String = "purple"
    @StateObject var firebaseViewModel: FirebaseViewModel
    
    var body: some View {
        
        NavigationView {
            VStack {
                HStack {
                    Text(returnIconName(pieceTitle: pieceTitle))
                        .foregroundColor(.white)
                        .font(.title2)
                        .bold()
                        .background(
                        
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(selectedColor))
                                .shadow(color: Color.black.opacity(0.6), radius: 4, x: 0, y: 0)
                                .frame(width: 70, height: 70)
                        
                        )
                        .padding()
                    
                    Spacer(minLength: 0)
                    
                    VStack(alignment: .leading) {
                        Text(pieceTitle)
                            .bold()
                            .font(.system(.title, design: .rounded))
                            .lineLimit(1)
                            .minimumScaleFactor(0.4)
                        
                        Text(composer)
                    }
                    .padding()
                    
                        
                    
                }.padding()
                    .padding(.horizontal)
                
                Form {
                    Section(header: Text("Piece Information")) {
                        TextField("Piece Title", text: $pieceTitle)
                        TextField("Composer", text: $composer)
                        
                    }
                    
                    Section(header: Text("Icon")) {
                        HStack(spacing: 10){
                          
                                RoundedRectangle(cornerRadius: 7)
                                    .fill(Color("purple"))
                                    .frame(width: 30, height: 30)
                                    .shadow(color: Color.yellow.opacity(self.selectedColor == "purple" ? 1 : 0), radius: 3, x: 0, y: 0)
                                    .onTapGesture {
                                        self.selectedColor = "purple"
                                    }
                                    
                            
                            
                                RoundedRectangle(cornerRadius: 7)
                                    .fill(Color("green"))
                                    .frame(width: 30, height: 30)
                                    .shadow(color: Color.yellow.opacity(self.selectedColor == "green" ? 1 : 0), radius: 3, x: 0, y: 0)
                                    .onTapGesture {
                                        self.selectedColor = "green"
                                    }
                                
                            
                            
                    
                                RoundedRectangle(cornerRadius: 7)
                                    .fill(Color("orange"))
                                    .frame(width: 30, height: 30)
                                    .shadow(color: Color.yellow.opacity(self.selectedColor == "orange" ? 1 : 0), radius: 3, x: 0, y: 0)
                                    .onTapGesture {
                                        self.selectedColor = "orange"
                                    }
                            
                            
                          
                                RoundedRectangle(cornerRadius: 7)
                                    .fill(Color("blue"))
                                    .frame(width: 30, height: 30)
                                    .shadow(color: Color.yellow.opacity(self.selectedColor == "blue" ? 1 : 0), radius: 3, x: 0, y: 0)
                                    .onTapGesture {
                                        self.selectedColor = "blue"
                                    }
                            
                          
                                RoundedRectangle(cornerRadius: 7)
                                    .fill(Color("red"))
                                    .frame(width: 30, height: 30)
                                    .shadow(color: Color.yellow.opacity(self.selectedColor == "red" ? 1 : 0), radius: 3, x: 0, y: 0)
                                    .onTapGesture {
                                        self.selectedColor = "red"
                                    }
                            
                            
                            Spacer()
                            
                            Text("Choose a Color")
                                .foregroundColor(Color.secondary)

                        }
                        
                        
                    }
                }
                .accentColor(.purple)
                .navigationTitle("New Piece")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button(action: {
                            uploadNewPieceToDatabase { isFinished in
                                if isFinished {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                           
                        }, label: {
                            Text("Save as New Piece")
                        })
                            .accentColor(.purple)
                    }
                }
                
                
                
                
                
      
            }
        }
    }
    
    func uploadNewPieceToDatabase(handler: @escaping(_ isFinished: Bool) ->()) {
        UploadToFirebaseHelper.instance.uploadNewPiece(pieceTitle: self.pieceTitle, composer: self.composer, iconColor: self.selectedColor) { isError in
            if isError {
                print("ERROR UPLOADING NEW PIECE TO DB")
                handler(false)
                return
            } else {
                print("SUCCESSFULLY UPLOADED NEW PIECE TO DB")
//                firebaseViewModel.getAllPieces()
                firebaseViewModel.updateNewPiece(pieceTitle: self.pieceTitle, composer: self.composer, iconColor: self.selectedColor)
                firebaseViewModel.getAllPieces()
                handler(true)
                return
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

//struct FormView_Previews: PreviewProvider {
//    static var previews: some View {
//        FormView()
//    }
//}
