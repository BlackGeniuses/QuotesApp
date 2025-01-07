//
//  ARExperienceSelectionScreen.swift
//  Quotes
//
//  Created by Donovan Holmes on 8/19/24.
//
import SwiftUI

struct ARExperienceSelectionScreen: View {
    @State private var selectedExperience: ARCategory?

    var body: some View {
            ZStack {
                // Background
                StarryBackground()

                VStack {
                    Text("Select AR Experience")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.top, 60)

                    List {
                        ForEach(ARCategory.allCases) { experience in
                            NavigationLink(
                                destination: ARExperienceSubSelection(category: experience),
                                label: {
                                    HStack {
                                        Text(experience.displayName)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Spacer()
                                        Image(systemName: experience.systemImageName)
                                            .foregroundColor(.white)
                                    }
                                    .padding()
                                    .background(Color.yellow.opacity(0.8))
                                    .cornerRadius(10)
                                }
                            )
                            .padding(.vertical, 5)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
                .padding()
                .ignoresSafeArea()
            }
            .navigationBarHidden(true)
            
        }
    }


