//
//  KidNPlayDance.swift
//  Quotes
//
//  Created by Donovan Holmes on 8/17/24.
//

//import SwiftUI
//
//struct KidNPlayDanceView: View {
//    @State private var leftOffset: CGFloat = 0
//    @State private var rightOffset: CGFloat = 0
//    @State private var rotation: Double = 0
//    
//    var body: some View {
//        HStack(spacing: 50) {
//            Image(systemName: "figure.walk")
//                .resizable()
//                .frame(width: 50, height: 100)
//                .rotationEffect(.degrees(rotation))
//                .offset(x: leftOffset)
//                .scaleEffect(x: -1, y: 1) // Flip the left figure horizontally to face right
//                
//            Image(systemName: "figure.walk")
//                .resizable()
//                .frame(width: 50, height: 100)
//                .rotationEffect(.degrees(rotation))
//                .offset(x: rightOffset)
//        }
//        .onAppear {
//            startKidNPlayDance()
//        }
//    }
//    
//    private func startKidNPlayDance() {
//        withAnimation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
//            leftOffset = -20
//            rightOffset = 20
//            rotation = 15
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            withAnimation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
//                leftOffset = 20
//                rightOffset = -20
//                rotation = -15
//            }
//        }
//    }
//}
//
//#Preview {
//    KidNPlayDanceView()
//}
//
