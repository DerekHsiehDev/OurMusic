//
//  PracticeLogView.swift
//  PianoFly
//
//  Created by Derek Hsieh on 4/19/21.
//

import SwiftUI
import FirebaseCore

struct PracticeLogView: View {
    @Binding var isShowing: Bool
    @State var progress : CGFloat = 0
    @StateObject var practiceModel: PracticeModel
    @AppStorage(CurrentUserDefaults.userID) var userID: String?
    @StateObject var firebaseViewModel: FirebaseViewModel
    
    var body: some View {
        
        
        VStack {
            
            HStack(alignment: .center) {
                
                Text("Practice Log")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .font(.largeTitle)
                
                
                Spacer()
                
                Button(action: {
                    
                    
                    
                    withAnimation(Animation.easeInOut(duration: 0.5)) {
                        isShowing = false
                        
                    }
                    
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .font(Font.title3.weight(.bold))
                    
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            
            Spacer()
            CircularSlider(isShowing: $isShowing, progress: $progress)
            Spacer()
            
            Button(action: {
                if Int(progress * 200) != 0 {
                    
                    print("finsihed")
                    DateHelper.instance.getCurrentDate { currentDate in
                        let practiceMinutes = Int(progress * 200)
                        
                        // send to database: id = currentDate, practiceMinutes = practiceMinutes, date = now
                        UploadPracticeLog.instance.uploadPracticeLog(dateString: currentDate, practiceMinutes: practiceMinutes) { isError, practiceMinutes, dateString in
                            if isError {
                                print("ERROR")
                            } else {
                                print("SUCCESSFULLY UPLOADED TO FIRESTORE: id: \(dateString ?? ""), practiceminutes: \(String(describing: practiceMinutes))")
                                // get data from db
                                
                                if let userID = userID {
                                    firebaseViewModel.getFullPracticeLog(userID: userID) { isFinished in
                                        print("FINISHED FETCHING USER POSTS")
                                    }
                                    
                                    
                                    
                                } else {
                                    print("NO USER ID FOUND")
                                    return
                                }
                            }
                        }
                    }
                    
                    withAnimation(Animation.easeInOut(duration: 0.5)) {
                        isShowing = false
                        practiceModel.appendChartData(data: Int(progress*500))
                        
                        
                    }
                    
                    
                    
                    
                }
                
            }) {
                Text("Done")
                    .foregroundColor(.black)
                    .font(.title2)
                    .fontWeight(.medium)
                
                    .background(
                        RoundedRectangle(cornerRadius: 35)
                            .fill(Color.white)
                            .frame(width: UIScreen.main.bounds.width - 100, height: 60)
                        
                    )
                    .padding(.bottom)
            }
            
        }
        .padding(.vertical, 35)
        .padding(.bottom, 35)
        
        .background(
            Color.black.edgesIgnoringSafeArea(.vertical)
            
        )
        
        
        
        
        
        
        
    }
}

struct PracticeLogViewPreview: PreviewProvider {
    static var previews: some View {
        PracticeLogView(isShowing: .constant(true), practiceModel: PracticeModel(), firebaseViewModel: FirebaseViewModel())
        
    }
}


struct CircularSlider : View {
    @Binding var isShowing: Bool
    @State var size = UIScreen.main.bounds.width - 125
    @Binding var progress: CGFloat
    @State var lastAngle: Double = 0
    @State var angle: Double = 0
    
    var body: some View{
        
        VStack{
            
            ZStack{
                
                Circle()
                    .stroke(Color.gray,style: StrokeStyle(lineWidth: 55, lineCap: .round, lineJoin: .round))
                    .frame(width: size, height: size)
                
                // progress....
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(Color(#colorLiteral(red: 0.3411764706, green: 0.2901960784, blue: 0.8862745098, alpha: 1)),style: StrokeStyle(lineWidth: 55, lineCap: .round))
                    .frame(width: size, height: size)
                    .rotationEffect(.init(degrees: -90))
                
                
                // Drag Circle...
                
                Circle()
                    .fill(Color.white)
                    .frame(width: 55, height: 55)
                    .offset(x: size / 2)
                    .rotationEffect(.init(degrees: angle))
                // adding gesture...
                    .gesture(DragGesture().onChanged({ value in
                        simpleSuccess();
                        onDrag(value: value)
                    }))
                    .rotationEffect(.init(degrees: -90))
                
                
                //                Text(convertMinutesToHoursAndMinutes(minutes: "\(progress * 500)"))
                //                    .font(.largeTitle)
                //                    .fontWeight(.heavy)
                
                Text((convertMinutesToHoursAndMinutes(minutes: "\(Int(progress * 200))")))
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                
                
            }
        }
    }
    
    func simpleSuccess() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred(intensity: 0.8)
    }
    
    
    func convertMinutesToHoursAndMinutes(minutes: String) -> String {
        let hours = Int(minutes)! / 60
        let min = (Int(minutes)! - (hours * 60))
        
        
        if hours == 0 {
            if min == 1 {
                return "\(min) minute"
            }
            return "\(min) minutes"
            
        } else if min < 10 {
            return "\(hours) : 0\(min)"
        }
        
        return "\(hours == 0 ? "" : "\(hours) :") \(min == 0 ? "00" : "\(min)")"
    }
    
    func onDrag(value: DragGesture.Value){
        
        // calculating radians...
        
        let vector = CGVector(dx: value.location.x, dy: value.location.y)
        
        // since atan2 will give from -180 to 180...
        // eliminating drag gesture size
        // size = 55 => Radius = 27.5...
        
        let radians = atan2(vector.dy - 27.5, vector.dx - 27.5)
        
        // converting to angle...
        
        var angle = radians * 180 / .pi
        
        
        // simple technique for 0 to 360...
        
        // eg = 360 - 176 = 184...
        
        
        if angle < 0{angle = 360 + angle}
        
        if abs(Double(angle) - lastAngle) > 75 {
            withAnimation(Animation.linear(duration: 0.15)) {
                let progress = lastAngle / 360
                self.progress = CGFloat(progress)
                
                self.angle = Double(lastAngle)
                self.lastAngle = Double(lastAngle)
            }
            
        } else {
            withAnimation(Animation.linear(duration: 0.15)){
                
                // progress...
                
                print(angle)
                
                let progress = angle / 360
                self.progress = progress
                
                self.angle = Double(angle)
                self.lastAngle = Double(angle)
            }
            
        }
        
        
        
        
    }
}
