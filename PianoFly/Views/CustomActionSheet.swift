//
//  CustomActionSheet.swift
//  PianoFly
//
//  Created by Derek Hsieh on 6/28/21.
//

import SwiftUI

struct CustomActionSheet: View {
    var body: some View {
        
        VStack(spacing: 15) {
            Text("custom action sheet")
        }
        .padding(.bottom, (UIApplication.shared.windows.last?.safeAreaInsets.bottom)! + 10)
        .padding(.horizontal)
        .padding(.top, 20)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(25)
        
    }
}
    
    
    struct CustomActionSheet_Previews: PreviewProvider {
        static var previews: some View {
            CustomActionSheet()
                
        }
    }
