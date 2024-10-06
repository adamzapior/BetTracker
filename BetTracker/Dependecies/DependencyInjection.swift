//
//  DependencyInjection.swift
//  BetTracker
//
//  Created by Adam Zapiór on 16/09/2024.
//

import Foundation
import SwiftUI

struct AppState {
    var loginState: LoginState = .init()
}

public final class DependencyInjection {
    private(set) var loginManager: any LoginManager
    private(set) var appState: AppState
    private(set) var repository: Repository
    private(set) var userDefaults: UserDefaultsManager
    
    init(appState: AppState,
         loginManager: any LoginManager,
         repository: Repository,
         userDefaults: UserDefaultsManager
    )
    {
        self.appState = appState
        self.loginManager = loginManager
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
        let appState = AppState()
        let repository = Repository()
        let userDefaults = UserDefaultsManager()
        
        return .init(appState: appState,
                     loginManager: AppLoginManager(
                         state: appState.loginState),
                     repository: repository,
                     userDefaults: userDefaults)
    }
    
    static func allMocks() -> DependencyInjection {
        let appState = AppState()
        let repository = Repository()
        let userDefaults = UserDefaultsManager()

        return .init(appState: appState,
                     loginManager: MockLoginManager(), 
                     repository: repository,
                     userDefaults: userDefaults)
    }
}
