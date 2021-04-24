//
//  HomeView.swift
//  PianoFly
//
//  Created by Derek Hsieh on 4/20/21.
//

import SwiftUI
import SwiftUICharts

struct HomeView: View {
    
    let chartStyle = ChartStyle(backgroundColor: Color(#colorLiteral(red: 0.3411764706, green: 0.2901960784, blue: 0.8862745098, alpha: 1)), accentColor: Colors.GradientUpperBlue, secondGradientColor: Colors.BorderBlue, textColor: Color.white, legendTextColor: Color.white, dropShadowColor: Color.white)

    
    @StateObject var practiceModel: PracticeModel
    
    var body: some View {
        VStack {
            
            ZStack(alignment: .bottom) {
                
                GeometryReader { geo in
                    Rectangle()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.5647058824, green: 0.5058823529, blue: 0.9529411765, alpha: 1)), Color(#colorLiteral(red: 0.3411764706, green: 0.2901960784, blue: 0.8862745098, alpha: 1))]), startPoint: .bottomLeading, endPoint: .topTrailing))
                        .frame(height: UIScreen.main.bounds.height / 5)
                        .edgesIgnoringSafeArea(.top)
                        .cornerRadius(CGFloat(25), corners: .bottomLeft)
                        .cornerRadius(CGFloat(25), corners: .bottomRight)
                    
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                            
                                Text("Weekly Practice")
                                    .foregroundColor(.white)
                                    .font(.system(size: 35, weight: .light))
                                
                                
                                
                                Text("432 Minutes")
                                    .font(.system(size: 45, weight: .bold))
                                    
                                    .foregroundColor(.white)
                                Spacer()
                                
                            }
                            .padding([.leading, .top, .bottom])
                            
                            Spacer()
                        }
                        .padding(.top)
                        .padding(.top)
                        
                   
                        
//                        RoundedRectangle(cornerRadius: 25)
//                            .fill(Color.white)
//                            .frame(width: geo.size.width - 25, height: (geo.size.width / 3) - 25)
//                            .padding(.bottom)
//                            .overlay(
//                                HStack {
//                                    VStack {
//                                        Image(systemName: "timer")
//                                            .font(.title2)
//                                            .foregroundColor(.white)
//                                            .background(
//                                                RoundedRectangle(cornerRadius: 10)
//                                                    .fill(Color(#colorLiteral(red: 0.3411764706, green: 0.2901960784, blue: 0.8862745098, alpha: 1)))
//                                                    .frame(width: 40, height: 40)
//                                        )
//
//                                        Spacer(minLength: 0)
//
//                                        Text("2 hr ")
//                                            .bold()
//
//                                        Text("Time")
//                                            .fontWeight(.light)
//
//                                        Spacer(minLength: 0)
//
//                                    }
//                                    Spacer()
//
//                                    VStack {
//                                        Image(systemName: "timer")
//                                            .font(.title2)
//                                            .foregroundColor(.white)
//                                            .background(
//                                                RoundedRectangle(cornerRadius: 10)
//                                                    .fill(Color(#colorLiteral(red: 0.3411764706, green: 0.2901960784, blue: 0.8862745098, alpha: 1)))
//                                                    .frame(width: 40, height: 40)
//                                        )
//
//                                        Spacer(minLength: 0)
//
//                                        Text("5")
//                                            .bold()
//
//                                        Text("Pieces")
//                                            .fontWeight(.light)
//
//                                        Spacer(minLength: 0)
//
//                                    }
//
//                                    Spacer()
//
//                                    VStack {
//                                        Image(systemName: "timer")
//                                            .font(.title2)
//                                            .foregroundColor(.white)
//                                            .background(
//                                                RoundedRectangle(cornerRadius: 10)
//                                                    .fill(Color(#colorLiteral(red: 0.3411764706, green: 0.2901960784, blue: 0.8862745098, alpha: 1)))
//                                                    .frame(width: 40, height: 40)
//                                        )
//
//                                        Spacer(minLength: 0)
//
//                                        Text("7")
//                                            .bold()
//
//                                        Text("Streak")
//                                            .fontWeight(.light)
//
//                                        Spacer(minLength: 0)
//
//                                    }
//                                }
//                                .frame(width: geo.size.width - 75, height: (geo.size.width / 4) - 100)
////                                .padding(.bottom)
//                            )
//
                        
                        
                    }
                    
                }
                
            
        
            
            }
            .frame(height: UIScreen.main.bounds.height / 4)
            
            VStack(spacing: 0) {
                if !practiceModel.chartData.isEmpty {
                    
                    HStack {
                        Text("Stats")
                            .font(.largeTitle)
                            .bold()
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, -35)
                    .padding(.bottom)
                    
                    
//                    BarChartView(data: ChartData(points: practiceModel.chartData), title: "Recent Practice (minutes)", style: chartStyle, form: ChartForm.extraLarge, cornerImage: Image(systemName: "music.quarternote.3"), valueSpecifier: "%.0f")
                    BarChart()
                        .padding(.bottom)
                        
                }
    
                
                HStack {
                    Text("Pieces")
                        .font(.largeTitle)
                        .bold()
                    
                    Spacer()
                }
                .padding(.horizontal)
                

                ScrollView(.horizontal, showsIndicators: false) {
                    
                    HStack {
                        ForEach(practiceModel.pieces, id: \.self) { piece in
                            CardView(piece: piece)
                                
                        }
                    }
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
        HomeView(practiceModel: PracticeModel())
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
