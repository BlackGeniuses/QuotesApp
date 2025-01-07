//
//  QuotesCategorySelectionScreen.swift
//  Quotes
//
//  Created by Donovan Holmes on 8/15/24.
//
import SwiftUI

struct QuotesCategorySelectionScreen: View {
    @EnvironmentObject var userAccountModel: UserAccountModel
    @State private var selectedCategory: String?
    @ObservedObject var quoteManager = QuoteManager()
    @State private var isDayTime = true // Control for day/night mode
    
    let gridItems = [
        GridItem(.adaptive(minimum: 100), spacing: 20),
        GridItem(.adaptive(minimum: 140), spacing: 30)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    ScrollView {
                        VStack {
                            Spacer()
                            Text("Sky Is The Limit")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .padding(.top, 60)
                            Spacer()
                            
                            LazyVGrid(columns: gridItems, spacing: 30) {
                                ForEach(quoteManager.categories, id: \.self) { category in
                                    NavigationLink(destination: ErasScreen(category: category, isDayTime: isDayTime)) {
                                        VStack {
                                            Spacer()
                                            Image(systemName: systemImageName(for: category))
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 60, height: 60)
                                                .foregroundColor(.white)
                                                .padding(.bottom, 5)
                                            
                                            Text(category)
                                                .font(.caption)
                                                .foregroundColor(.white)
                                        }
                                        .padding()
                                        .background(Color.yellow.opacity(0.8))
                                        .cornerRadius(10)
                                    }
                                    .frame(height: 120)
                                }
                            }
                            .padding(.top, 60)
                            .padding()
                        }
                    }
                    
                    NavigationLink(destination: ARExperienceSelectionScreen()) {
                        Text("Explore AR Experiences")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(.bottom, 20)
                    }
                }
                .applyBackground(isDayTime: isDayTime)
            }
            .ignoresSafeArea()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isDayTime.toggle()
                    }) {
                        Text(isDayTime ? "Switch to Night" : "Switch to Day")
                    }
                }
                
            }
            .navigationBarBackButtonHidden(true) // Hide the back button
        }
    }
    
    private func systemImageName(for category: String) -> String {
        switch category {
        case "Authors": return "book.fill"
        case "Music": return "music.note"
        case "Movies": return "film.fill"
        case "TV": return "tv.fill"
        case "BlackLeaders": return "person.3.fill"
        case "Poetry": return "text.quote"
        case "Cartoons": return "photo.tv"
        case "Entrepreneurs": return "building.columns.fill"
        default: return "questionmark.circle"
        }
    }
}

#Preview {
    QuotesCategorySelectionScreen()
        .environmentObject(UserAccountModel()) // Add this for preview
}
