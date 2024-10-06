//
//  Services.swift
//  BetTracker
//
//  Created by Adam Zapiór on 16/09/2024.
//

import Foundation

protocol Services {
    var defaultsManager: UserDefaultsManager { get }
    var repository: Repository { get }
}

final class AppServices: Services {
    var repository: Repository
    var defaultsManager: UserDefaultsManager
  
    
    init(repository: Repository, defaultsManager: UserDefaultsManager) {
        self.repository = repository
        self.defaultsManager = defaultsManager
    }
}

/// Class used for Unit Tests
//class MockServices: Services {
//    // to do
//}
