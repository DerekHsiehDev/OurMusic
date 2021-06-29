//
//  HomeView.swift
//  PianoFly
//
//  Created by Derek Hsieh on 4/20/21.
//

import SwiftUI
import SwiftUICharts

struct HomeView2: View {
    
    let chartStyle = ChartStyle(backgroundColor: Color(#colorLiteral(red: 0.3411764706, green: 0.2901960784, blue: 0.8862745098, alpha: 1)), accentColor: Colors.GradientUpperBlue, secondGradientColor: Colors.BorderBlue, textColor: Color.white, legendTextColor: Color.white, dropShadowColor: Color.white)

    
    @StateObject var practiceModel: PracticeModel
    @StateObject var firebaseViewModel: FirebaseViewModel
    @State var isEditing: Bool = false
    
    var body: some View {
        VStack {
            
            ZStack {
                
                HStack(spacing: 15) {
                    
                    Text("Home")
                        .font(.largeTitle)
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
            
            VStack(spacing: 0) {
                if !practiceModel.chartData.isEmpty {
                    
                    HStack {
                        Text("Stats")
                            .font(.title)
                            .bold()
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding()
                    
                    
//                    BarChartView(data: ChartData(points: practiceModel.chartData), title: "Recent Practice (minutes)", style: chartStyle, form: ChartForm.extraLarge, cornerImage: Image(systemName: "music.quarternote.3"), valueSpecifier: "%.0f")
                    BarChart(firebaseViewModel: firebaseViewModel)
                }
    
                
                HStack {
                    Text("Pieces")
                        .font(.title)
                        .bold()
                    
                    Spacer()
                    
                    if isEditing {
                        Button {
                            
                        } label: {
                            // Add new piece
                            Image(systemName: "plus.square.fill")
                                .font(.largeTitle)
                        }
                    }
                    
                   

                    
                    Button(action: {isEditing.toggle()}, label: {
                        
                        Text(isEditing ? "done" : "edit")
                            .foregroundColor(isEditing ? .white : .blue)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .background(
                                RoundedRectangle(cornerRadius: 8.5)
                                    .fill(isEditing ? Color.blue : Color.clear)
                                    
                            )
                    })
                }
                .padding(.horizontal)
                .padding()
                .padding(.top)

                ScrollView(.horizontal, showsIndicators: false) {
                    
                    
                        
                        HStack(spacing: 30) {
                            
                           
                            
                           
                            
                            ForEach(practiceModel.pieces, id: \.self) { piece in
                                CardView(isEditing: $isEditing, piece: piece)
                                    
                            }
                        }
                        .padding()
                        .padding()
                        
                    
                   
                }
                .onTapGesture {
                    print("tapped")
                }
                
                    
            }
        
                
                Spacer(minLength: 0)
       
            
      
        }
        .background(Color.black.opacity(0.09).edgesIgnoringSafeArea(.vertical))
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView2(practiceModel: PracticeModel(), firebaseViewModel: FirebaseViewModel())
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
