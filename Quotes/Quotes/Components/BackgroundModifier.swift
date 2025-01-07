//
//  BackgroundModifier.swift
//  Quotes
//
//  Created by Donovan Holmes on 8/20/24.
//

import Foundation
import SwiftUI

struct BackgroundModifier: ViewModifier {
    var isDayTime: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            if isDayTime {
                SunnyDayBackground()
            } else {
                StarryBackground()
            }
            
            content
        }
        .edgesIgnoringSafeArea(.all)
    }
}

extension View {
    func applyBackground(isDayTime: Bool) -> some View {
        self.modifier(BackgroundModifier(isDayTime: isDayTime))
    }
}
