//
//  ReferralSourceScreen.swift
//  Quotes
//
//  Created by Donovan Holmes on 8/15/24.
//

import SwiftUI
import FirebaseFirestore

struct ReferralSourceScreen: View {
    @ObservedObject var userAccountModel: UserAccountModel
    @State private var selectedSource: String? = nil
    @State private var selectedDetail: String? = nil
    @State private var otherText: String = ""
    @State private var showOtherTextField: Bool = false
    @State private var showDetailPicker: Bool = false
    @State private var isSubmitted: Bool = false
    @State private var navigateToAgeRange = false

    let sources = ["Social Media", "Friend", "Advertisement", "Search Engine", "Other"]
    let socialMediaOptions = ["Facebook", "Instagram", "Twitter", "LinkedIn"]
    let searchEngineOptions = ["Google", "Bing", "Yahoo", "DuckDuckGo"]
    let advertisementOptions = ["TV", "Radio", "Billboard", "Online Ad"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Where did you hear about us?")
                    .font(.largeTitle)
                    .padding(.top)
                    .foregroundColor(.white)
                
                ZStack {
                    List {
                        ForEach(sources, id: \.self) { source in
                            Button(action: {
                                selectedSource = source
                                showOtherTextField = (source == "Other")
                                showDetailPicker = (source == "Social Media" || source == "Advertisement" || source == "Search Engine")
                                selectedDetail = nil // Reset detail selection
                            }) {
                                HStack {
                                    Text(source)
                                    Spacer()
                                    if selectedSource == source {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                        
                        if showDetailPicker {
                            Picker(selection: $selectedDetail, label: Text(detailPickerLabel())) {
                                ForEach(detailOptions(), id: \.self) { option in
                                    Text(option).tag(option as String?)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(height: 150)
                        }
                        
                        if showOtherTextField {
                            TextField("Please specify", text: $otherText)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)
                        }
                    }
                    .background(Color.black) // Black background for the list
                    .cornerRadius(10)
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
                .disabled(!canSubmit())
                .padding(.bottom)
                .background(
                    NavigationLink(
                        destination: UsersAgeRange(userAccountModel: userAccountModel),
                        isActive: $navigateToAgeRange,
                        label: { EmptyView() }
                    )
                )
                
                Spacer()
            }
            .padding()
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
    }

    private func detailOptions() -> [String] {
        switch selectedSource {
        case "Social Media":
            return socialMediaOptions
        case "Search Engine":
            return searchEngineOptions
        case "Advertisement":
            return advertisementOptions
        default:
            return []
        }
    }

    private func detailPickerLabel() -> String {
        switch selectedSource {
        case "Social Media":
            return "Select Social Media"
        case "Search Engine":
            return "Select Search Engine"
        case "Advertisement":
            return "Select Advertisement"
        default:
            return ""
        }
    }

    private func canSubmit() -> Bool {
        if showDetailPicker {
            return selectedDetail != nil
        } else if showOtherTextField {
            return !otherText.isEmpty
        } else {
            return selectedSource != nil
        }
    }
    private func handleSubmit() {
        var referralSource = selectedSource ?? ""
        
        if showDetailPicker {
            referralSource = selectedDetail ?? referralSource
        } else if showOtherTextField {
            referralSource = otherText
        }

        // Store the referral source in the model
        userAccountModel.hasCompletedReferral = true
        userAccountModel.referralSource = referralSource // Store in the model
        userAccountModel.storeTemporaryData(["referralSource": referralSource])
        
        if userAccountModel.hasCompletedAllSteps() {
            // Save data to Firestore
            userAccountModel.saveUserData { success in
                if success {
                    navigateToAgeRange = true
                } else {
                    print("Error saving referral source")
                }
            }
        } else {
            // Proceed without saving if all steps are not yet complete
            navigateToAgeRange = true
        }
    }
}

//#Preview {
//    ReferralSourceScreen(userAccountModel: UserAccountModel())
//}

