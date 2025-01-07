//
//  ContentView.swift
//  Quotes
//
//  Created by Donovan Holmes on 8/15/24.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var userAccountModel = UserAccountModel()
    @State private var navigateToQuotesCategoryScreen = false
    @State private var welcomeMessage: String?
    
    var body: some View {
        NavigationView {
            VStack {
                if navigateToQuotesCategoryScreen {
                    QuotesCategorySelectionScreen()
                        .environmentObject(userAccountModel)
                } else {
                    ReferralSourceScreen(userAccountModel: userAccountModel)
                }
            }
            .onAppear {
                checkUserStatus()
            }
            .navigationBarBackButtonHidden(true)
            .overlay(
                // Display welcome message if user exists
                VStack {
                    if let welcomeMessage = welcomeMessage {
                        Text(welcomeMessage)
                            .font(.title)
                            .foregroundColor(.green)
                            .padding()
                    }
                },
                alignment: .top
            )
        }
    }
    
    private func checkUserStatus() {
        userAccountModel.retrieveStoredUUID() // Retrieve UUID from UserDefaults
        userAccountModel.checkUserStatus { isSignedUp in
            DispatchQueue.main.async {
                if isSignedUp {
                    // User exists and has completed sign-up
                    welcomeMessage = "Welcome Back \(userAccountModel.username ?? "User")"
                    navigateToQuotesCategoryScreen = true
                } else {
                    // User does not exist or hasn't completed sign-up
                    navigateToQuotesCategoryScreen = false
                }
            }
        }
    }

}

#Preview {
    ContentView()
}
