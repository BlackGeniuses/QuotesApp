//
//  UserNameInputScreen.swift
//  Quotes
//
//  Created by Donovan Holmes on 8/20/24.
//
import SwiftUI

struct UserNameInputScreen: View {
    @State private var userName: String = ""
    @State private var navigateToCuratingData = false
    @State private var isSavingData = false
    @EnvironmentObject var userAccountModel: UserAccountModel

    var body: some View {
        NavigationView {
            VStack {
                Text("Enter Your Name")
                    .font(.largeTitle)
                    .padding(.top, 40)
                
                TextField("Your name", text: $userName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.words)
                
                Button(action: {
                    handleContinue()
                }) {
                    if isSavingData {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        Text("Continue")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .disabled(userName.isEmpty || isSavingData)
                .padding(.top, 20)
                
                Spacer()
                
                // Navigation link to CuratingDataScreen
                navigationLink
            }
            .navigationTitle("Welcome")
        }
    }

    private func handleContinue() {
        isSavingData = true // Start loading state
        userAccountModel.username = userName
        
        // Save user data
        userAccountModel.saveUserData { success in
            DispatchQueue.main.async {
                isSavingData = false // Stop loading state
                if success && userAccountModel.hasCompletedAllSteps() {
                    navigateToCuratingData = true
                } else {
                    print("Failed to save user data or complete all steps")
                }
            }
        }
    }
    
    // Navigation link to CuratingDataScreen
    private var navigationLink: some View {
        NavigationLink(
            destination: CuratingDataScreen()
                .environmentObject(userAccountModel), // Pass the environment object here
            isActive: $navigateToCuratingData,
            label: { EmptyView() }
        )
    }
}

#Preview {
    UserNameInputScreen()
}

