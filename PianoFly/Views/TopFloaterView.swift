//
//  TopFloaterView.swift
//  PianoFly
//
//  Created by Derek Hsieh on 8/6/21.
//

import Foundation
import SwiftUI

struct TopFloaterView {
    func createTopFloaterView(errMsg: String) -> some View {
        VStack(alignment: .center) {
            
             Text(errMsg)
                .foregroundColor(.black)
                .bold()
                .font(.title2)
            
        }
        .frame(width: UIScreen.main.bounds.width - 30, height: 100)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.8), radius: 0.25, x: 0, y: 0)
    }
}
