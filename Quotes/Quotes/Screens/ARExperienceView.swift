//
//  ARExperienceView.swift
//  Quotes
//
//  Created by Donovan Holmes on 8/19/24.
//

import SwiftUI
import RealityKit
import ARKit

struct ARExperienceView: View {
    let category: ARCategory
    let subCategory: ARSubCategory
    
    var body: some View {
        ARViewContainer(category: category, subCategory: subCategory)
            .edgesIgnoringSafeArea(.all)
            .navigationTitle(category.displayName)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
    }
}

#Preview {
    ARExperienceView(category: .home, subCategory: .modernHome)
}
