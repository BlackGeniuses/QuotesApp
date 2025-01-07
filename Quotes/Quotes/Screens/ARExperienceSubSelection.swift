//
//  ARExperienceSubSelection.swift
//  Quotes
//
//  Created by Donovan Holmes on 8/19/24.
//
import SwiftUI

struct ARExperienceSubSelection: View {
    let category: ARCategory
    @State private var selectedSubCategory: ARSubCategory?
    
    var body: some View {
        List(ARSubCategory.allCases, id: \.self) { subCategory in
            NavigationLink(
                destination: ARViewContainer(category: category, subCategory: subCategory),
                tag: subCategory,
                selection: $selectedSubCategory
            ) {
                Label(subCategory.displayName, systemImage: subCategory.systemImageName)
            }
        }
        .navigationTitle("\(category.displayName) Subcategories")
    }
}


#Preview {
    ARExperienceSubSelection(category: .home)
}
