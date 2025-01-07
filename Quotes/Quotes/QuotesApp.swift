//
//  QuotesApp.swift
//  Quotes
//
//  Created by Donovan Holmes on 8/15/24.
//

import SwiftUI
import UIKit
import Firebase


class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
                     launchOptions: [UIApplication.LaunchOptionsKey: Any]?) ->
    Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct QuotesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var quoteManager = QuoteManager.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(quoteManager)
        }
    }
}
