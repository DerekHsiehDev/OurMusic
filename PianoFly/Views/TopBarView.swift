//
//  TopBarView.swift
//  PianoFly
//
//  Created by Derek Hsieh on 7/5/21.
//

import SwiftUI

struct TopBarView: View {
    
    @Binding var isShowingFormView: Bool
    @Binding var isShowingPracticeLogView: Bool
    var leftImage: String
    var rightImage: String
    var title: String
    var body: some View {
        HStack {
            Button(action: {
                isShowingFormView.toggle()
            }) {
                Image(systemName: rightImage)
                    .font(Font.title2.weight(.bold))
                    .padding(10)
                    .background(
                    RoundedRectangle(cornerRadius: 9)
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 50, height: 50)
                    )
            }
            .accentColor(Color.black)
  
            
               Spacer(minLength: 0)
            Text(title)
                .bold()
                .font(.title2)
            
            Spacer(minLength: 0)
            
            Button(action: {
                isShowingPracticeLogView.toggle()
            }) {
                Image(systemName: leftImage)
                    .font(Font.title2.weight(.bold))
                    .padding(10)
                    .background(
                    RoundedRectangle(cornerRadius: 9)
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 50, height: 50)
                    )
            }
            .accentColor(Color.black)
            
         
            
        }
        .padding(.horizontal)
    }
}


