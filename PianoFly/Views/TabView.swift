//
//  TabView.swift
//  musicflyuitests
//
//  Created by Derek Hsieh on 7/4/21.
//

import SwiftUI

struct TabView: View {
    
    @Binding var index: Int

    var body: some View {
        
        HStack {
            Button(action: {
                
                withAnimation(.linear(duration: 0.1)) {
                    self.index = 0
                }
                
            }, label: {
                VStack(spacing: 10) {
                    Image(systemName: index == 0 ? "house.fill" : "house")
                        .foregroundColor(Color.MyTheme.DarkPurple.opacity(index == 0 ? 1 : 0.45))
                        .font(.system(size: 30))
                    
                    Circle()
                        .fill(Color.MyTheme.DarkPurple.opacity(index == 0 ? 1 : 0))
                        .frame(width: 10, height: 10)
                        
                }
            })
            
            Spacer(minLength: 0)
            
            Button(action: {
                withAnimation(.linear(duration: 0.1)) {
                    self.index = 1
                }
            }, label: {
                VStack(spacing: 10) {
                    Image(systemName: "calendar")
                        .foregroundColor(Color.MyTheme.DarkPurple.opacity(index == 1 ? 1 : 0.45))
                        .font(.system(size: 30))
                    
                    Circle()
                        .fill(Color.MyTheme.DarkPurple.opacity(index == 1 ? 1 : 0))
                        .frame(width: 10, height: 10)
                        
                }
            })
            
            Spacer(minLength: 0)
            
            Button(action: {
                withAnimation(.linear(duration: 0.1)) {
                    self.index = 2
                }
                
            }, label: {
                VStack(spacing: 10) {
                    Image(systemName: "studentdesk")
                        .foregroundColor(Color.MyTheme.DarkPurple.opacity(index == 2 ? 1 : 0.45))
                        .font(.system(size: 30))
                    
                    Circle()
                        .fill(Color.MyTheme.DarkPurple.opacity(index == 2 ? 1 : 0))
                        .frame(width: 10, height: 10)
                        
                }
            })
            
            Spacer(minLength: 0)
            
            
            Button(action: {
                withAnimation(.linear(duration: 0.1)) {
                    self.index = 3
                }
            }, label: {
                VStack(spacing: 10) {
                    Image(systemName: index == 3 ? "gearshape.fill" : "gearshape")
                        .foregroundColor(Color.MyTheme.DarkPurple.opacity(index == 3 ? 1 : 0.45))
                        .font(.system(size: 30))
                    
                    Circle()
                        .fill(Color.MyTheme.DarkPurple.opacity(index == 3 ? 1 : 0))
                        .frame(width: 10, height: 10)
                        
                }
            })
  
        }
        .padding(.horizontal)
        .padding(.top)
    }
}

struct TabView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        
        VStack {
            Spacer()
            TabView(index: .constant(0))
        }
    }
}
