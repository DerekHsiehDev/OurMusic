//
//  BarChart.swift
//  PianoFly
//
//  Created by Derek Hsieh on 4/23/21.
//

import SwiftUI

struct BarChart: View {
    
    @State var daysArray: [String] = ["", "", "","", "", "", ""]
    
    @State var selectedTime: CGFloat = -1
    @State var selectedIndex: Int = -1
    
    var body: some View {
        ZStack
        {
           
            
            VStack {
                HStack {
                    Text(selectedIndex != -1 ? "\(String(format: "%.0f minutes", selectedTime))" : "Practice Minutes This Week")
                        .foregroundColor(.white)
                        .font(.title2)
                        .bold()
                        .padding(.leading)
                    
                    Spacer(minLength: 0)
                }
                
     
                
                HStack(spacing: 20) {
                    BarView(daysArray: $daysArray, selectedTime: $selectedTime, selectedIndex: $selectedIndex, date: 0, val: 100)
                    BarView(daysArray: $daysArray, selectedTime: $selectedTime, selectedIndex: $selectedIndex, date: 1, val: 60)
                    BarView(daysArray: $daysArray, selectedTime: $selectedTime, selectedIndex: $selectedIndex, date: 2, val: 39)
                    BarView(daysArray: $daysArray, selectedTime: $selectedTime, selectedIndex: $selectedIndex, date: 3, val: 90)
                    BarView(daysArray: $daysArray, selectedTime: $selectedTime, selectedIndex: $selectedIndex, date: 4, val: 125)
                    BarView(daysArray: $daysArray, selectedTime: $selectedTime, selectedIndex: $selectedIndex, date: 5, val: 150)
                    BarView(daysArray: $daysArray, selectedTime: $selectedTime, selectedIndex: $selectedIndex, date: 6, val: 100)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(#colorLiteral(red: 0.3411764706, green: 0.2901960784, blue: 0.8862745098, alpha: 0.8513462496)))
                    .frame(width: UIScreen.main.bounds.width - 15, height: 250)
            )
        
         
        
           
        }
        .onAppear {
            var days = [String]()
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            let currentDate = Date()
            
            for val in stride(from: -7, through: 0, by: 1) {
                let newDate = Calendar.current.date(byAdding: .day, value: val, to: currentDate)
                let stringDate = formatter.string(from: newDate!)
                print(stringDate)
                days.append(stringDate)
                
                
            }
            
            daysArray = days
        }
    }
}

struct BarChart_Previews: PreviewProvider {
    static var previews: some View {
        BarChart()
    }
}


 


struct BarView: View {

    @Binding var daysArray: [String]
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
            
            Text(daysArray[date].prefix(1))
                .foregroundColor(.white)
                .bold()
        }
        .onTapGesture {
            if selectedIndex == date {
                withAnimation(.linear(duration: 0.2)) {
                    self.selectedIndex = -1
                    tappedImpact()
                }
            } else {
                withAnimation(.linear(duration: 0.2)) {
                    self.selectedTime = val
                    self.selectedIndex = date
                    tappedImpact()
                }
            }
            
          
     
        }
    }
    
    func tappedImpact() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
}
