//
//  StarryBackground.swift
//  Quotes
//
//  Created by Donovan Holmes on 8/19/24.
//

import SwiftUI

struct StarryBackground: View {
    @State private var starPositions: [CGPoint] = []
    
    var body: some View {
        GeometryReader { geometry in
            Canvas { context, size in
                // Draw stars
                for position in starPositions {
                    var starPath = Path()
                    starPath.addArc(center: position, radius: 1.5, startAngle: .zero, endAngle: .degrees(360), clockwise: true)
                    context.fill(starPath, with: .color(.white))
                }
            }
            .onAppear {
                // Generate random star positions
                starPositions = generateStarPositions(size: geometry.size)
            }
            .onChange(of: geometry.size) { newSize in
                // Regenerate stars if size changes
                starPositions = generateStarPositions(size: newSize)
            }
        }
        .background(Color.black) // Dark background to simulate night
        .ignoresSafeArea()
        .animation(.linear(duration: 30).repeatForever(autoreverses: false), value: starPositions)
        .onAppear {
            // Start moving stars
            withAnimation {
                moveStars()
            }
        }
    }
    
    private func generateStarPositions(size: CGSize) -> [CGPoint] {
        var positions: [CGPoint] = []
        for _ in 0..<100 {
            let x = CGFloat.random(in: 0...size.width)
            let y = CGFloat.random(in: 0...size.height)
            positions.append(CGPoint(x: x, y: y))
        }
        return positions
    }
    
    private func moveStars() {
        for i in 0..<starPositions.count {
            let x = starPositions[i].x + CGFloat.random(in: -0.5...0.5)
            let y = starPositions[i].y + CGFloat.random(in: -0.5...0.5)
            starPositions[i] = CGPoint(x: x, y: y)
        }
    }
}


#Preview {
    StarryBackground()
}
