//
//  BetTrackerApp.swift
//  BetTracker
//
//  Created by Adam Zapiór on 20/03/2023.
//

import SwiftUI

@main
struct BetTrackerApp: App {
    
    @StateObject private var session = SessionManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(session)
        }
    }
}
