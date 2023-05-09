//
//  UserDefaultsManager.swift
//  BetTracker
//
//  Created by Adam Zapiór on 09/05/2023.
//

import Foundation

final class UserDefaultsManager {
    static let useManager = UserDefaults.standard
    
    // MARK: Global variables from UserDefaults:
    static var defaultCurrencyValue = UserDefaults.standard.object(forKey: Keys.defaultCurrency) as? String ?? ""
    
    
    //MARK: - Keys used to store value
    
    enum Keys {
        //Onboarding Setup:
        static let hasSeenOnboarding = "hasSeenOnboarding"
        
        //Add bet:
        static let team1 = "team1"
        static let team2 = "team2"
        static let amount = "amount"
        static let odds = "odds"
        static let tax = "tax"
        static let category = "category"
        static let league = "league"
        static let selectedDate = "selectedDate"
        
        //Preferences
        static let username = "username"
        static let defaultCurrency = "defaultCurrency"
        static let defaultTax = "defaultTax"
    }
}
