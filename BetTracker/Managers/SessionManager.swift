//
//  SessionManager.swift
//  BetTracker
//
//  Created by Adam Zapiór on 09/05/2023.
//

import Foundation

final class SessionManager: ObservableObject {
    
    enum UserDefaultKeys {
        static let hasSeenOnboarding = "hasSeenOnboarding"
    }
    
    enum CurrentState {
        case loggedIn
        case onboardingSetup
        case onboarding

    }
    
    @Published private(set) var currentState: CurrentState?
    
    
    func goToOnboardingSetup() {
        currentState = .onboardingSetup
    }
    
//    func signIn() {
//        currentState = .loggedIn
//        UserDefaults.standard.set(true, forKey: UserDefaultKeys.hasCompletedSignUpFlow)
//    }

    
    func completeOnboarding() {
        currentState = .onboardingSetup
//        UserDefaults.standard.set(true, forKey: UserDefaultKeys.hasSeenOnboarding)
    }
    
    
    
    func completeOnboardingSetup() {
        currentState = .loggedIn
        UserDefaults.standard.set(true, forKey: UserDefaultKeys.hasSeenOnboarding)
    }
    
    func configureCurrentState() {
        
        /**
         - User closes the app during the onboarding phase > Resume the app from the onboarding screens
         - User closes the app during the sign up phase > Resume the app from the sign up screens
         - User closes the app after viewing onboarding and sign up phase > Resume the app from the log in screen
         */
        
        let hasCompletedOnboarding = UserDefaults.standard.bool(forKey: UserDefaultKeys.hasSeenOnboarding)
        
        if hasCompletedOnboarding {
            currentState = .loggedIn
        } else {
            currentState = .onboarding
        }
    }
}

