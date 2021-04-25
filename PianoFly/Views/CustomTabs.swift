//
//  CustomTabs.swift
//  PianoFly
//
//  Created by Derek Hsieh on 4/19/21.
//

import SwiftUI

struct CustomTabs: View {
    
    @Binding var index: Int
    @Binding var isShowingPracticeLogView: Bool
    
    var body: some View {
        HStack {
            Button(action: {
                withAnimation(.linear(duration: 0.1)) {
                    self.index = 0
                }
            
            }) {
                Image(systemName: "music.note")
                    .font(.system(size: 30))
            }
            .foregroundColor(Color.black.opacity(self.index == 0 ? 1 : 0.1))
            
            Spacer(minLength: 0)
            
            Button(action: {
                withAnimation(.linear(duration: 0.1)) {
                    self.index = 1
                }
            }) {
                Image(systemName: "calendar")
                    .font(.system(size: 30))
            }
            .foregroundColor(Color.black.opacity(self.index == 1 ? 1 : 0.1))
            .offset(x: 10)
            
            Spacer(minLength: 0)
            
            
            Button(action: {
                // toggle practice view
                withAnimation(Animation.spring()) {
                    isShowingPracticeLogView = true
                }
                
                
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 45))
                    .foregroundColor(Color(#colorLiteral(red: 0.3411764706, green: 0.2901960784, blue: 0.8862745098, alpha: 1)))
                    
            }
            .offset(y: -25)
            
            Spacer(minLength: 0)
            
            
            Button(action: {
                withAnimation(.linear(duration: 0.1)) {
                    self.index = 2
                }
            }) {
                Image(systemName: "message.fill")
                    .font(.system(size: 30))
            }
            .foregroundColor(Color.black.opacity(self.index == 2 ? 1 : 0.1))
            .offset(x: -10)
            
            
            Spacer(minLength: 0)
            
            Button(action: {
                withAnimation(.linear(duration: 0.1)) {
                    self.index = 3
                }
            }) {
                Image(systemName: "person.fill")
                    .font(.system(size: 30))
            }
            .foregroundColor(Color.black.opacity(self.index == 3 ? 1 : 0.1))
            
        }
        .padding(.horizontal, 35)
        .padding(.top, 35)
        .background(Color.white)
        .clipShape(CShape())
        .padding(.bottom, 25)
    }
}

struct CShape: Shape {
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: 0, y: 35))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 35))
            path.addArc(center: CGPoint(x: (rect.width / 2) - 4, y: 35), radius: 33, startAngle: .zero, endAngle: .init(degrees: 180), clockwise: true)
            
        }
    }
}
