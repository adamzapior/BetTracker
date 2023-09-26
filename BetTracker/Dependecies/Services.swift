//
//  Services.swift
//  BetTracker
//
//  Created by Adam Zapiór on 16/09/2024.
//

import Foundation

protocol Services {
//    var defaultsManager: UserDefaultsManager { get }
    var repository: Repository { get }
}

// I need to think about this - should it be final?
final class AppServices: Services {
//    var defaultsManager: UserDefaultsManager
    var repository: Repository
  
    
    init(repository: Repository) {
        self.repository = repository
    }
    
//    init(defaultsManager: UserDefaultsManager, repository: Repository) {
//        self.defaultsManager = defaultsManager
//        self.repository = repository
//    }
}

/// Class used for Unit Tests
//class MockServices: Services {
//    // to do
//}
