//
//  UsersAgeRange.swift
//  Quotes
//
//  Created by Donovan Holmes on 8/15/24.
//

import SwiftUI
import FirebaseFirestore

struct UsersAgeRange: View {
    @ObservedObject var userAccountModel: UserAccountModel
    @State private var selectedAgeRange: String? = nil
    @State private var navigateToQuotesPreference = false
    
    let ageRanges = ["14-18", "18-25", "25-34", "34-45", "45 and older"]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Select Your Age Range")
                    .font(.largeTitle)
                    .padding(.top)
                    .foregroundColor(.white)
                
                List {
                    ForEach(ageRanges, id: \.self) { ageRange in
                        Button(action: {
                            selectedAgeRange = ageRange
                        }) {
                            HStack {
                                Text(ageRange)
                                Spacer()
                                if selectedAgeRange == ageRange {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
                .background(Color.black) // Black background for the list
                .cornerRadius(10)
                
                Button(action: {
                    handleSubmit()
                }) {
                    Text("Continue")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .disabled(selectedAgeRange == nil)
                .padding(.bottom)
                .background(
                    NavigationLink(
                        destination: QuotePreferenceScreen(userAccountModel: userAccountModel),
                        isActive: $navigateToQuotesPreference,
                        label: { EmptyView() }
                    )
                )
                
                Spacer()
            }
            .padding()
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .onAppear {
                // Set the initial state for the selected age range if already available
                if let savedAgeRange = userAccountModel.ageRange {
                    selectedAgeRange = savedAgeRange
                }
            }
        }
    }
    
    private func handleSubmit() {
        guard let ageRange = selectedAgeRange else { return }
        
        // Update the userAccountModel's ageRange directly
        userAccountModel.ageRange = ageRange
        
        // Check if all steps are completed
        if userAccountModel.hasCompletedAllSteps() {
            // If all steps are completed, save user data and create UUID document
            userAccountModel.generateAndStoreUUID() // Ensure UUID is generated
            userAccountModel.saveUserData { success in
                if success {
                    print("Age range and other data saved successfully")
                    navigateToQuotesPreference = true
                } else {
                    print("Error saving user data")
                }
            }
        } else {
            // Proceed to the next screen
            navigateToQuotesPreference = true
        }
    }
}

#Preview {
    UsersAgeRange(userAccountModel: UserAccountModel())
}
