//
//  QuotePreferenceScreen.swift
//  Quotes
//
//  Created by Donovan Holmes on 8/15/24.
//
import SwiftUI
import FirebaseFirestore

struct QuotePreferenceScreen: View {
    @ObservedObject var userAccountModel: UserAccountModel
    @State private var selectedCategories: [String] = []
    @State private var navigateToPersonalityScreen = false
    
    let categories = ["Music", "Movies", "TV Shows", "Poets", "Authors", "Philosophers", "Black Leaders", "Cartoons"]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Preferences")
                    .font(.largeTitle)
                    .padding(.top)
                
                List {
                    ForEach(categories, id: \.self) { category in
                        Button(action: {
                            toggleSelection(of: category)
                        }) {
                            HStack {
                                Text(category)
                                Spacer()
                                if selectedCategories.contains(category) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
                
                Button(action: {
                    handleSubmit()
                }) {
                    Text("Continue")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .disabled(selectedCategories.isEmpty)
                .padding(.bottom)
                .background(
                    NavigationLink(
                        destination: PersonalityTypeScreen(userAccountModel: userAccountModel),
                        isActive: $navigateToPersonalityScreen,
                        label: { EmptyView() }
                    )
                )
                
                Spacer()
            }
            .padding()
            .onAppear {
                selectedCategories = userAccountModel.selectedCategories
            }
        }
    }
    
    private func toggleSelection(of category: String) {
        if selectedCategories.contains(category) {
            selectedCategories.removeAll { $0 == category }
        } else {
            selectedCategories.append(category)
        }
    }
    
    private func handleSubmit() {
        userAccountModel.selectedCategories = selectedCategories
        
        if userAccountModel.hasCompletedAllSteps() {
            // Save data to Firestore
            userAccountModel.saveUserData { success in
                if success {
                    print("Categories and other data saved successfully")
                    navigateToPersonalityScreen = true
                } else {
                    print("Error saving data")
                }
            }
        } else {
            // Temporarily store the data and move to the next step
            navigateToPersonalityScreen = true
        }
    }
}
#Preview {
    QuotePreferenceScreen(userAccountModel: UserAccountModel())
}

