//
//  SunnyDayBackground.swift
//  Quotes
//
//  Created by Donovan Holmes on 8/20/24.
//

import SwiftUI

struct SunnyDayBackground: View {
    @State private var cloudOffsets: [CGFloat] = Array(repeating: -200, count: 5) // Initial positions for clouds
      @State private var cloudStartingPositions: [CGFloat] = Array(repeating: 0, count: 5) // Start positions for clouds
      
      var body: some View {
          ZStack {
              // Daytime gradient background
              LinearGradient(gradient: Gradient(colors: [Color.blue, Color.white]),
                             startPoint: .top, endPoint: .bottom)
                  .ignoresSafeArea()
              
              // Sun at the top right
              SunView()
                  .position(x: UIScreen.main.bounds.width - 80, y: 100)
              
              // Moving clouds with randomized behavior
              ForEach(0..<5, id: \.self) { index in
                  CloudView()
                      .offset(x: cloudOffsets[index], y: cloudStartingPositions[index])
                      .onAppear {
                          let randomYPosition = CGFloat.random(in: -UIScreen.main.bounds.height / 3 ... UIScreen.main.bounds.height / 3)
                          let randomDuration = Double.random(in: 10...20) // Random speed
                          let startOnLeft = Bool.random() // Randomly start from left or right
                          
                          cloudStartingPositions[index] = randomYPosition
                          cloudOffsets[index] = startOnLeft ? -200 : UIScreen.main.bounds.width + 200 // Start position off screen
                          
                          withAnimation(Animation.linear(duration: randomDuration).repeatForever(autoreverses: false)) {
                              cloudOffsets[index] = startOnLeft ? UIScreen.main.bounds.width + 200 : -200 // Move to the opposite side
                          }
                      }
              }
          }
      }
  }

  struct SunView: View {
      var body: some View {
          Circle()
              .fill(Color.yellow)
              .frame(width: 100, height: 100)
              .overlay(
                  Circle()
                      .stroke(Color.orange, lineWidth: 5)
              )
      }
  }

  struct CloudView: View {
      var body: some View {
          CloudShape()
              .fill(Color.white)
              .frame(width: 200, height: 100)
              .shadow(radius: 10)
      }
  }

  struct CloudShape: Shape {
      func path(in rect: CGRect) -> Path {
          var path = Path()
          
          let cloudWidth = rect.width
          let cloudHeight = rect.height
          
          // Create cloud-like shapes with curves
          path.move(to: CGPoint(x: 0.1 * cloudWidth, y: 0.5 * cloudHeight))
          
          path.addQuadCurve(to: CGPoint(x: 0.3 * cloudWidth, y: 0.3 * cloudHeight),
                            control: CGPoint(x: 0.2 * cloudWidth, y: 0.1 * cloudHeight))
          
          path.addQuadCurve(to: CGPoint(x: 0.5 * cloudWidth, y: 0.2 * cloudHeight),
                            control: CGPoint(x: 0.4 * cloudWidth, y: 0.05 * cloudHeight))
          
          path.addQuadCurve(to: CGPoint(x: 0.7 * cloudWidth, y: 0.3 * cloudHeight),
                            control: CGPoint(x: 0.6 * cloudWidth, y: 0.05 * cloudHeight))
          
          path.addQuadCurve(to: CGPoint(x: 0.9 * cloudWidth, y: 0.5 * cloudHeight),
                            control: CGPoint(x: 0.8 * cloudWidth, y: 0.3 * cloudHeight))
          
          path.addQuadCurve(to: CGPoint(x: 0.7 * cloudWidth, y: 0.8 * cloudHeight),
                            control: CGPoint(x: 0.8 * cloudWidth, y: 0.9 * cloudHeight))
          
          path.addQuadCurve(to: CGPoint(x: 0.3 * cloudWidth, y: 0.8 * cloudHeight),
                            control: CGPoint(x: 0.5 * cloudWidth, y: 0.9 * cloudHeight))
          
          path.addQuadCurve(to: CGPoint(x: 0.1 * cloudWidth, y: 0.5 * cloudHeight),
                            control: CGPoint(x: 0.2 * cloudWidth, y: 0.9 * cloudHeight))
          
          return path
      }
  }


#Preview {
    SunnyDayBackground()
}
