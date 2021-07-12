//
//  NewPieceView.swift
//  PianoFly
//
//  Created by Derek Hsieh on 6/29/21.
//

import SwiftUI

struct NewPieceView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("New Piece").font(.title).bold()
                Spacer()
                Image(systemName: "xmark.circle.fill").foregroundColor(.gray).font(.system(size: 26))
            }
            .padding(.horizontal)
            Spacer()
        }
    }
}

struct NewPieceView_Previews: PreviewProvider {
    static var previews: some View {
        NewPieceView()
    }
}
