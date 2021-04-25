 //
//  CardView.swift
//  PianoFly
//
//  Created by Derek Hsieh on 4/23/21.
//

import SwiftUI

struct FlipEffect: GeometryEffect {
    var animatbleData: Double {
        get { angle }
        set { angle = newValue }
    }
    
    @Binding var flipped: Bool
    var angle: Double
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        
        DispatchQueue.main.async {
            flipped = angle >= 90 && angle < 270
        }
        
        
        
        let newAngle = flipped ? -180 + angle : angle
        
        let angleInRadians = CGFloat(Angle(degrees: newAngle).radians)
        
        var transform3d = CATransform3DIdentity
        transform3d.m34 = -1/max(size.width, size.height)
        
        transform3d = CATransform3DRotate(transform3d, angleInRadians, 1, 0, 0)
        transform3d = CATransform3DTranslate(transform3d, -size.width / 2, -size.height / 2, 0)
        
        let affineTransform = ProjectionTransform(CGAffineTransform(translationX: size.width/2, y: size.height/2))
        
        return ProjectionTransform(transform3d).concatenating(affineTransform)
    }
}

struct CardView: View {
    @State var flipped: Bool = false
    @State var flip: Bool = false
    
    var piece: Piece
    
    var body: some View {
        
        
           
        
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white)
                .frame(width: 175, height: 175)
                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 0)
                .overlay(
                    VStack {

                        HStack {
                            Spacer()

                            Image(systemName: "music.note.list")
                                .foregroundColor(.gray)
                                .font(.title2)
                        }


                        Spacer()

                        VStack(alignment: .leading) {



                            Text(piece.title)
                                .font(.title3)
                                .bold()



                            Text(piece.composer)
                        }

                    }
                    .padding()

                )
                .opacity(flipped ? 0 : 1)
            
            
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.black)
                .frame(width: 175, height: 175)
                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 0)
                .overlay(
                    VStack {

                        Spacer(minLength: 0)

                        VStack(alignment: .leading) {

                            Text(piece.title)
//                                .font(.title3)
                                .bold()
                                .foregroundColor(.white)
                                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                                


                            
                        }
                        
                        Spacer(minLength: 0)

                    }
                    .padding()

                )
                .opacity(flipped ? 1 : 0)
                
            
        }
        .rotation3DEffect(self.flipped ? Angle(degrees: 180): Angle(degrees: 0), axis: (x: CGFloat(0), y: CGFloat(10), z: CGFloat(0)))
        .animation(.default) // implicitly applying animation
        .onTapGesture {
            // explicitly apply animation on toggle (choose either or)
            //withAnimation {
                self.flipped.toggle()
            //}
    }
        
        
 
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.opacity(0.09).edgesIgnoringSafeArea(.vertical)
            CardView(piece: Piece(uuid: UUID(), composer: "Chopin", title: "Piano Concerto No. 2"))
        }
            
    }
}



