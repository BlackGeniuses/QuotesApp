//
//  PersonalityTypeScreen.swift
//  Quotes
//
//  Created by Donovan Holmes on 8/15/24.
//

import SwiftUI
import FirebaseFirestore


struct PersonalityTypeScreen: View {
    @ObservedObject var userAccountModel: UserAccountModel
    @State private var selectedPersonalityTypes: Set<String> = []
    @State private var navigateToNotificationsScreen = false
    
    let personalityTypes = ["Happy", "Sad", "Angry", "Focused", "Relaxed", "Calm", "Motivated"]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Select Your Personality Types")
                    .font(.largeTitle)
                    .padding(.top)
                
                List {
                    ForEach(personalityTypes, id: \.self) { type in
                        Button(action: {
                            toggleSelection(of: type)
                        }) {
                            HStack {
                                Text(type)
                                Spacer()
                                if selectedPersonalityTypes.contains(type) {
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
                .disabled(selectedPersonalityTypes.isEmpty)
                .padding(.bottom)
                .background(
                    NavigationLink(
                        destination: NotificationsTimeSelectionScreen(userAccountModel: userAccountModel),
                        isActive: $navigateToNotificationsScreen,
                        label: { EmptyView() }
                    )
                )
                
                Spacer()
            }
            .padding()
            .onAppear {
                if let savedTypes = userAccountModel.personalityType?.split(separator: ",").map({ $0.trimmingCharacters(in: .whitespaces) }) {
                    selectedPersonalityTypes = Set(savedTypes)
                }
            }
        }
    }
    
    private func toggleSelection(of type: String) {
        if selectedPersonalityTypes.contains(type) {
            selectedPersonalityTypes.remove(type)
        } else {
            selectedPersonalityTypes.insert(type)
        }
    }
    
    private func handleSubmit() {
        let personalityTypes = selectedPersonalityTypes.joined(separator: ", ")
        userAccountModel.personalityType = personalityTypes
        
        if userAccountModel.hasCompletedAllSteps() {
            // Save data to Firestore
            userAccountModel.saveUserData { success in
                if success {
                    print("Personality types and other data saved successfully")
                    navigateToNotificationsScreen = true
                } else {
                    print("Error saving data")
                }
            }
        } else {
            // Temporarily store the data and move to the next step
            navigateToNotificationsScreen = true
        }
    }
}

#Preview {
    PersonalityTypeScreen(userAccountModel: UserAccountModel())
}
