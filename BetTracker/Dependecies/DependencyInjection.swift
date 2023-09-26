//
//  DependencyInjection.swift
//  BetTracker
//
//  Created by Adam Zapiór on 16/09/2024.
//

import Foundation
import SwiftUI

struct AppState {
    var loginState: LoginState = LoginState()
}

public final class DependencyInjection {
    
    private(set) var loginManager: any LoginManager
    private(set) var appState: AppState
    private(set) var repository: Repository
    
    internal init(appState: AppState,
                  loginManager: any LoginManager,
                  repository: Repository
    ) {
        self.appState = appState
        self.loginManager = loginManager
        self.repository = repository
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
        
        return .init(appState: appState,
                     loginManager: AppLoginManager(
                        state: appState.loginState),
                        repository: repository
        )
    }
    
    static func allMocks() -> DependencyInjection {
        let appState = AppState()
        let repository = Repository()
        
        return .init(appState: appState,
                     loginManager: MockLoginManager(), repository: repository)
    }

}
