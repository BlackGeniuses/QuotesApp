//
//  QuoteScreen.swift
//  Quotes
//
//  Created by Donovan Holmes on 8/17/24.
//
import SwiftUI

struct QuoteScreen: View {
    let quotes: [String] // List of quotes by the same owner
    let owner: String
    @State private var selectedPage = 0
    @State var isDayTime: Bool // This will be passed from the previous screen
    
    var body: some View {
        ZStack {
            VStack {
                TabView(selection: $selectedPage) {
                    ForEach(quotes.indices, id: \.self) { index in
                        VStack(alignment: .leading) {
                            Text("\"\(quotes[index])\"") // Display quote in quotation marks
                                .font(.body)
                                .padding()
                                .foregroundColor(.white) // Make text white to stand out on dark background
                            
                            Text("- \(owner)") // Display owner of the quote
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.bottom, 20)
                        }
                        .padding()
                        .tag(index) // Tag each page to track the current index
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .navigationTitle("Quote Details")
                .foregroundColor(.white)
                
                HStack(spacing: 8) {
                    ForEach(quotes.indices, id: \.self) { index in
                        Circle()
                            .fill(index == selectedPage ? Color.yellow : Color.gray)
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.top, 20)
            }
        }
        .applyBackground(isDayTime: isDayTime) // Apply the background modifier
    }
}

#Preview {
    QuoteScreen(quotes: ["Don't check me check the...", "Another quote here...", "Yet another quote..."], owner: "Larry June", isDayTime: true)
}
