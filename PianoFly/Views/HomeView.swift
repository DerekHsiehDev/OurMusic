//
//  HomeView.swift
//  PianoFly
//
//  Created by Derek Hsieh on 6/15/21.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        
        ZStack {
            
            HStack(spacing: 15) {
                
                Text("Home")
                    .font(.title)
                    .foregroundColor(.black)
                    .fontWeight(.heavy)
                
                Spacer(minLength: 0)
                
             
                
                ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)) {
                    Button {
                        
                    } label: {
                        Image(systemName: "tray.fill")
                            .font(.title)
                            .foregroundColor(.black)
                    }
                    
                    Circle()
                        .fill(Color.red)
                        .frame(width: 15, height: 15)
                        .offset(x: 5, y: -10)
                    
                }
                
                
            }
     
        }
        .padding()
        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

struct HomeVie2w_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
