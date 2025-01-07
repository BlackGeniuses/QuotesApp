//
//  ErasScreen.swift
//  Quotes
//
//  Created by Donovan Holmes on 8/18/24.
//

import SwiftUI

struct ErasScreen: View {
    let category: String
    @ObservedObject var quoteManager = QuoteManager()
    var isDayTime: Bool // Passed from parent screen
    
    var body: some View {
        ZStack {
            VStack {
                Spacer() // Push the list down from the top
                
                List {
                    ForEach(quoteManager.eras[category] ?? [], id: \.self) { era in
                        NavigationLink(destination: categoryTitlesView(for: category, era: era)) {
                            Text(era)
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .listRowBackground(Color.clear) // Transparent row background
                    }
                }
                .listStyle(.plain)
                .frame(maxWidth: .infinity, maxHeight: 300) // Limit the height and width of the list
                .background(Color.clear) // Semi-transparent background
                .cornerRadius(10)
                .scrollContentBackground(.hidden) // Remove the default list background
                .padding() // Add padding around the list
                
                Spacer() // Push the list up from the bottom
            }
            .navigationTitle("\(category) Eras")
            .foregroundColor(.white)
        }
        .applyBackground(isDayTime: isDayTime) // Apply the background
        .onAppear {
            quoteManager.fetchEras(for: category)
        }
    }
    
    private func categoryTitlesView(for category: String, era: String) -> some View {
        if let quotes = quoteManager.categoryData[category]?[era] {
            return AnyView(CategoryTitleView(categoryName: category, eraName: era, quotes: quotes, isDayTime: isDayTime))
        } else {
            return AnyView(CategoryTitleView(categoryName: category, eraName: era, quotes: [:], isDayTime: isDayTime))
        }
    }
}

#Preview {
    ErasScreen(category: "Authors", isDayTime: true)
}

