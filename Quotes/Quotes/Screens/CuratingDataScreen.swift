//
//  CuratingDataScreen.swift
//  Quotes
//
//  Created by Donovan Holmes on 8/15/24.

import SwiftUI
import FirebaseFirestore

struct CuratingDataScreen: View {
    @State private var isCurating = true
    @State private var navigateToQuotesCategory = false
    @State private var displayedText = ""
    @EnvironmentObject var userAccountModel: UserAccountModel
    
    private var fullText: String {
        "Curating \(userAccountModel.username ?? "your") data to provide the best possible experience..."
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                Text(fullText)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer()
                
                HStack {
                    Spacer()
                    VStack {
                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                        
                        TextBubbleView(text: displayedText)
                            .padding(.top, 10)
                    }
                    .padding(.bottom, 20)
                    Spacer()
                }
                
                NavigationLink(
                    destination: QuotesCategorySelectionScreen()
                        .environmentObject(userAccountModel),
                    isActive: $navigateToQuotesCategory,
                    label: { EmptyView() }
                )
            }
            .onAppear {
                startCuratingProcess()
                animateText()
            }
            .navigationBarBackButtonHidden(true) // Hide the back button
            .navigationTitle("")       // Removes the navigation title
        }
    }
    
    private func startCuratingProcess() {
        guard let username = userAccountModel.username else {
            print("Username is not set")
            return
        }
        
        let db = Firestore.firestore()
        let userDocumentID = username
        
        let userData: [String: Any] = [
            "username": username,
            "referralSource": "Sample Source",
            "categories": ["Music", "Movies"],
            "ageRange": "18-25",
            "personalityType": "Happy"
        ]
        
        db.collection("users").document(userDocumentID).setData(userData) { error in
            if let error = error {
                print("Error saving user data: \(error)")
            } else {
                print("User data curated successfully")
                isCurating = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    navigateToQuotesCategory = true
                }
            }
        }
    }
    
    private func animateText() {
        var index = 0
        let words = fullText.split(separator: " ")
        
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { timer in
            if index < words.count {
                withAnimation {
                    displayedText += (index > 0 ? " " : "") + words[index]
                }
                index += 1
            } else {
                timer.invalidate()
            }
        }
    }
}

struct TextBubbleView: View {
    let text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(text)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(15)
                .frame(width: 300, alignment: .leading)
                .overlay(
                    Triangle()
                        .fill(Color.blue)
                        .frame(width: 15, height: 15)
                        .offset(x: 0, y: 10),
                    alignment: .bottomLeading
                )
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX - 7.5, y: rect.maxY - 7.5))
        path.addLine(to: CGPoint(x: rect.midX + 7.5, y: rect.maxY - 7.5))
        path.closeSubpath()
        return path
    }
}

#Preview {
    CuratingDataScreen().environmentObject(UserAccountModel())
}
