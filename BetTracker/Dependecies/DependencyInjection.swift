//
//  DependencyInjection.swift
//  BetTracker
//
//  Created by Adam Zapiór on 16/09/2024.
//

import Foundation
import SwiftUI

//struct AppState1 {
//    var loginState: LoginState = .init()
//}

public final class DependencyInjection {
    private(set) var repository: Repository
    private(set) var userDefaults: UserDefaultsManager
    
    init(
         repository: Repository,
         userDefaults: UserDefaultsManager
    )
    {
      
        self.repository = repository
        self.userDefaults = userDefaults
    }
}

extension DependencyInjection {
    static var assembly: DependencyInjection = {
        // Use mocks for previews
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            return DependencyInjection.allMocks()
        } else {
            return DependencyInjection.assembleRealApp()
        }
    }()
        
    static func assembleRealApp() -> DependencyInjection {
        let repository = Repository()
        let userDefaults = UserDefaultsManager()
        
        return .init(
                     repository: repository,
                     userDefaults: userDefaults)
    }
    
    static func allMocks() -> DependencyInjection {
        let repository = Repository()
        let userDefaults = UserDefaultsManager()

        return .init(
                     repository: repository,
                     userDefaults: userDefaults)
    }
}
