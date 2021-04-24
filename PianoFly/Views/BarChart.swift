//
//  BarChart.swift
//  PianoFly
//
//  Created by Derek Hsieh on 4/23/21.
//

import SwiftUI

struct BarChart: View {
    
    @State var selectedTime: CGFloat = -1
    @State var selectedIndex: Int = -1
    
    var body: some View {
        ZStack
        {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(#colorLiteral(red: 0.3411764706, green: 0.2901960784, blue: 0.8862745098, alpha: 0.8513462496)))
                .frame(width: 400, height: 275)
            
            VStack {
                HStack {
                    Text(selectedIndex != -1 ? "\(String(format: "%.0f minutes", selectedTime))" : "Practice Minutes This Week")
                        .foregroundColor(.white)
                        .font(.title2)
                        .bold()
                        .padding(.leading)
                    
                    Spacer(minLength: 0)
                }
                
                
                Spacer()
                
                HStack(spacing: 20) {
                    BarView(selectedTime: $selectedTime, selectedIndex: $selectedIndex, date: 0, val: 100)
                    BarView(selectedTime: $selectedTime, selectedIndex: $selectedIndex, date: 1, val: 60)
                    BarView(selectedTime: $selectedTime, selectedIndex: $selectedIndex, date: 2, val: 39)
                    BarView(selectedTime: $selectedTime, selectedIndex: $selectedIndex, date: 3, val: 90)
                    BarView(selectedTime: $selectedTime, selectedIndex: $selectedIndex, date: 4, val: 125)
                    BarView(selectedTime: $selectedTime, selectedIndex: $selectedIndex, date: 5, val: 150)
                    BarView(selectedTime: $selectedTime, selectedIndex: $selectedIndex, date: 6, val: 100)
                }
            }
            .frame(width: 390, height: 265)
        
           
        }
    }
}

struct BarChart_Previews: PreviewProvider {
    static var previews: some View {
        BarChart()
    }
}


    var days = ["S", "M", "T", "W", "T", "F", "S"]


struct BarView: View {
    @Binding var selectedTime: CGFloat
    @Binding var selectedIndex: Int
    let date: Int
    let val: CGFloat
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                Capsule().frame(width: 30, height: 150)
                    .foregroundColor(Color(#colorLiteral(red: 0.3411764706, green: 0.2901960784, blue: 0.8862745098, alpha: 1)))
                Capsule().frame(width: 30, height: val)
                    .foregroundColor(Color.white)
                    .scaleEffect(selectedIndex == date ? 1.20 : 1)
            }
            
            Text(days[date])
                .foregroundColor(.white)
                .bold()
        }
        .onTapGesture {
            if selectedIndex == date {
                withAnimation(.linear(duration: 0.2)) {
                    self.selectedIndex = -1
                }
            } else {
                withAnimation(.linear(duration: 0.2)) {
                    self.selectedTime = val
                    self.selectedIndex = date
                }
            }
            
          
     
        }
    }
}
