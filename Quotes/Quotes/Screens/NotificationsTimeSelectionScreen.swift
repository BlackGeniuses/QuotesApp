//
//  NotificationsTimeSelectionScreen.swift
//  Quotes
//
//  Created by Donovan Holmes on 8/15/24.
//

import SwiftUI
import FirebaseFirestore

struct NotificationsTimeSelectionScreen: View {
    @ObservedObject var userAccountModel: UserAccountModel
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var selectedFrequency = "Every Hour"
    @State private var showStartTimePicker = false
    @State private var showEndTimePicker = false
    @State private var navigateToUserNameInputScreen = false
    
    let frequencies = ["Every 30 Minutes", "Every Hour", "Every 4 Hours", "Every 8 Hours"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Select Your Notification Preferences")
                    .font(.largeTitle)
                    .padding(.top)
                
                VStack(spacing: 10) {
                    Button(action: {
                        showStartTimePicker.toggle()
                    }) {
                        HStack {
                            Text("Start Time: \(formatTime(startTime))")
                            Spacer()
                            Image(systemName: "clock")
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    }
                    .sheet(isPresented: $showStartTimePicker) {
                        TimePickerView(selectedTime: $startTime, title: "Start Time") {
                            showStartTimePicker = false
                        }
                    }
                    
                    Button(action: {
                        showEndTimePicker.toggle()
                    }) {
                        HStack {
                            Text("End Time: \(formatTime(endTime))")
                            Spacer()
                            Image(systemName: "clock")
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    }
                    .sheet(isPresented: $showEndTimePicker) {
                        TimePickerView(selectedTime: $endTime, title: "End Time") {
                            showEndTimePicker = false
                        }
                    }
                }
                
                Picker("Notification Frequency", selection: $selectedFrequency) {
                    ForEach(frequencies, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Button(action: {
                    handleSubmit()
                }) {
                    Text("Submit")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .disabled(!areTimesValid())
                .padding(.bottom)
                .background(
                    NavigationLink(
                        destination: UserNameInputScreen()
                            .environmentObject(userAccountModel),
                        isActive: $navigateToUserNameInputScreen,
                        label: { EmptyView() }
                    )
                )
                
                Spacer()
            }
            .padding()
            .onAppear {
                // Load saved notification preferences if available
                startTime = userAccountModel.notificationStartTime ?? Date()
                endTime = userAccountModel.notificationEndTime ?? Date()
                selectedFrequency = userAccountModel.notificationFrequency ?? "Every Hour"
            }
        }
    }
    
    private func handleSubmit() {
        // Log the values to verify they are being set correctly
        print("Saving notification preferences:")
        print("Start Time: \(startTime)")
        print("End Time: \(endTime)")
        print("Frequency: \(selectedFrequency)")

        // Populate notification preferences into the userAccountModel
        userAccountModel.notificationStartTime = startTime
        userAccountModel.notificationEndTime = endTime
        userAccountModel.notificationFrequency = selectedFrequency

        // Save notification preferences as temporary data
        userAccountModel.storeTemporaryData([
            "notificationStartTime": startTime,
            "notificationEndTime": endTime,
            "notificationFrequency": selectedFrequency
        ])
        
        // Navigate to UserNameInputScreen
        navigateToUserNameInputScreen = true
    }

    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func areTimesValid() -> Bool {
        return startTime < endTime
    }
}

struct TimePickerView: View {
    @Binding var selectedTime: Date
    var title: String
    var onDone: () -> Void
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .padding()
            
            DatePicker(
                "Select Time",
                selection: $selectedTime,
                displayedComponents: .hourAndMinute
            )
            .labelsHidden()
            .datePickerStyle(WheelDatePickerStyle())
            .padding()
            
            Button(action: {
                onDone()
            }) {
                Text("Done")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

#Preview {
    NotificationsTimeSelectionScreen(userAccountModel: UserAccountModel())
}
