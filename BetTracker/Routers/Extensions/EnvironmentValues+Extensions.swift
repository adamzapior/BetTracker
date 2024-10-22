
import SwiftUI

struct CurrentTabKey: EnvironmentKey {
    static var defaultValue: Binding<ContentView.Tab> = .constant(.a)
}

// MARK: FeedTabRouter keys

struct BetsDetailsRouterKey: EnvironmentKey {
    static let defaultValue: any BetsDetailsNavigationProtocol = FeedTabRouter()
}

struct BetslipDetailsRouterKey: EnvironmentKey {
    static let defaultValue: any BetslipDetailsNavigationProtocol = FeedTabRouter()
}

// MARK: ProfileTabRouter keys

struct PreferencesRouterKey: EnvironmentKey {
    static let defaultValue: any PreferencesNavigationProtocol = ProfileTabRouter()
}


extension EnvironmentValues {
    var currentTab: Binding<ContentView.Tab> {
        get { self[CurrentTabKey.self] }
        set { self[CurrentTabKey.self] = newValue }
    }

    var betsDetailsRouter: any BetsDetailsNavigationProtocol {
        get { self[BetsDetailsRouterKey.self] }
        set { self[BetsDetailsRouterKey.self] = newValue }
    }

    var betslipDetailsRouter: any BetslipDetailsNavigationProtocol {
        get { self[BetslipDetailsRouterKey.self] }
        set { self[BetslipDetailsRouterKey.self] = newValue }
    }
    
    var preferencesRouter: any PreferencesNavigationProtocol {
        get { self[PreferencesRouterKey.self] }
        set { self[PreferencesRouterKey.self] = newValue }
    }

//
//    var presentedSheet: Binding<PresentedSheet?> {
//        get { self[PresentedSheetKey.self] }
//        set { self[PresentedSheetKey.self] = newValue }
//    }
}


