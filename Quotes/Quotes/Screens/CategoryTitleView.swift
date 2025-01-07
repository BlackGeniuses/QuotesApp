//
//  CategoryTitleView.swift
//  Quotes
//
//  Created by Donovan Holmes on 8/17/24.
//

import SwiftUI

struct CategoryTitleView: View {
    let categoryName: String
    let eraName: String
    let quotes: [String: String] // Dictionary of quotes and owners
    @State var isDayTime: Bool // This will be passed from the previous screen
    
    var body: some View {
        ZStack {
            // Background applied based on the time of day
            VStack {
                Spacer() // Push the content to the middle
                
                // Centered list with transparent background
                List {
                    ForEach(Array(Set(quotes.values)), id: \.self) { owner in
                        NavigationLink(destination: QuoteScreen(quotes: findQuotes(for: owner), owner: owner, isDayTime: isDayTime)) {
                            Text(owner)
                                .font(.headline)
                                .foregroundColor(.white) // Ensure text stands out
                        }
                        .listRowBackground(Color.clear) // Transparent row background
                    }
                }
                .listStyle(.plain)
                .frame(maxWidth: .infinity, maxHeight: 300) // Limit the height and width
                .background(Color.clear) // Semi-transparent background
                .cornerRadius(10)
                .scrollContentBackground(.hidden) // Remove the list's default background
                .padding() // Add some padding around the list
                
                Spacer() // Add space below the list
            }
            .navigationTitle("\(categoryName) - \(eraName) Titles")
            .foregroundColor(.white)
        }
        .applyBackground(isDayTime: isDayTime) // Apply the background
    }
    
    private func findQuotes(for owner: String) -> [String] {
        return quotes.filter { $0.value == owner }.map { $0.key }
    }
}

#Preview {
    CategoryTitleView(categoryName: "Music", eraName: "1990s", quotes: ["Don't check me check the...": "Larry June"], isDayTime: true)
}

