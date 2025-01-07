//
//  UserAccountModel.swift
//  Quotes
//
//  Created by Donovan Holmes on 8/16/24.
//
import SwiftUI
import FirebaseFirestore

class UserAccountModel: ObservableObject {
    @Published var documentId: String?
    @Published var username: String?
    @Published var uuid: String? // Added UUID property
    @Published var hasCompletedReferral: Bool = false
    @Published var referralSource: String? // Added referralSource field
    @Published var ageRange: String?
    @Published var selectedCategories: [String] = []
    @Published var personalityType: String?
    @Published var notificationPreferences: [String: Any]?
    @Published var notificationStartTime: Date?
    @Published var notificationEndTime: Date?
    @Published var notificationFrequency: String?

    private let db = Firestore.firestore()
    private let collectionName = "users"
    
    var temporaryData: [String: Any] = [:]

    // Generate and store a UUID for the user
    func generateAndStoreUUID() {
        if uuid == nil {
            uuid = UUID().uuidString
            UserDefaults.standard.set(uuid, forKey: "userUUID")
        }
    }


    func saveUserData(completion: @escaping (Bool) -> Void) {
        // Ensure the UUID is generated
        generateAndStoreUUID()
        
        guard let uuid = uuid, !uuid.isEmpty,
              let username = username, !username.isEmpty,
              let notificationStartTime = notificationStartTime,
              let notificationEndTime = notificationEndTime,
              !(notificationFrequency?.isEmpty ?? true) else {
            print("UUID, username, or notification preferences are incomplete, cannot create user document")
            completion(false)
            return
        }
        
        // Handle nil or empty values properly
        var data: [String: Any] = [
            "username": username,
            "hasCompletedReferral": hasCompletedReferral,
            "referralSource": referralSource ?? "",  // Fallback to an empty string
            "ageRange": ageRange ?? "",  // Fallback to an empty string
            "categories": selectedCategories,
            "personalityType": personalityType ?? "",  // Fallback to an empty string
            "notificationPreferences": notificationPreferences ?? [:],  // Fallback to an empty dictionary
            "notificationStartTime": notificationStartTime,
            "notificationEndTime": notificationEndTime,
            "notificationFrequency": notificationFrequency ?? ""
        ]
        
        let documentRef = db.collection(collectionName).document(uuid)
        
        documentRef.setData(data) { error in
            if let error = error {
                print("Error saving user data: \(error)")
                completion(false)
            } else {
                print("User data saved successfully")
                completion(true)
            }
        }
    }


    // Check if the user has completed all the steps
    func hasCompletedAllSteps() -> Bool {
        let isReferralSourceComplete = referralSource != nil && !referralSource!.isEmpty
        let isAgeRangeComplete = ageRange != nil && !ageRange!.isEmpty
        let isPersonalityTypeComplete = personalityType != nil && !personalityType!.isEmpty
        var isNotificationPreferencesComplete: Bool {
            // Safely unwrap notificationFrequency and check if it is not empty
            if let frequency = notificationFrequency, !frequency.isEmpty {
                return notificationStartTime != nil && notificationEndTime != nil
            }
            return false
        }


        print("hasCompletedReferral: \(hasCompletedReferral)")
        print("isReferralSourceComplete: \(isReferralSourceComplete)")
        print("isAgeRangeComplete: \(isAgeRangeComplete)")
        print("isPersonalityTypeComplete: \(isPersonalityTypeComplete)")
        print("isNotificationPreferencesComplete: \(isNotificationPreferencesComplete)")
        print("selectedCategories: \(selectedCategories)")

        return hasCompletedReferral && isReferralSourceComplete && isAgeRangeComplete && !selectedCategories.isEmpty && isPersonalityTypeComplete && isNotificationPreferencesComplete
    }

    // Temporarily store data
    func storeTemporaryData(_ data: [String: Any]) {
        temporaryData.merge(data) { _, new in new }
    }

    // Retrieve stored UUID
    func retrieveStoredUUID() {
        uuid = UserDefaults.standard.string(forKey: "userUUID")
    }

    // Method to check if user data is already completed
    func checkUserStatus(completion: @escaping (Bool) -> Void) {
        // Ensure UUID is retrieved or generated
        retrieveStoredUUID()
        
        guard let uuid = uuid else {
            completion(false)
            return
        }
        
        let documentRef = db.collection(collectionName).document(uuid)
        
        documentRef.getDocument { document, error in
            if let document = document, document.exists {
                // Check if all necessary fields are present and completed
                if let data = document.data() {
                    self.username = data["username"] as? String
                    self.hasCompletedReferral = data["hasCompletedReferral"] as? Bool ?? false
                    self.referralSource = data["referralSource"] as? String // Retrieve referral source
                    self.ageRange = data["ageRange"] as? String
                    self.selectedCategories = data["categories"] as? [String] ?? []
                    self.personalityType = data["personalityType"] as? String
                    self.notificationPreferences = data["notificationPreferences"] as? [String: Any]
                    
                    // Check if the user has completed all steps
                    if self.hasCompletedAllSteps() {
                        completion(true) // User has completed sign-up
                    } else {
                        completion(false) // User has not completed sign-up
                    }
                } else {
                    completion(false) // Document exists but no data found
                }
            } else {
                if let error = error {
                    print("Error retrieving user data: \(error)")
                }
                completion(false) // User does not exist
            }
        }
    }
}
