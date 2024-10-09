import Foundation
import LifetimeTracker

//public protocol LoginManager {
//    var state: LoginState { get }
//    func logIn()
//    func logOut()
//}
//
//public class LoginState: ObservableObject {
//    @Published var loggedIn: Bool = false
//    @Published var userName: String? = nil
//}
//
//class AppLoginManager: LoginManager {
//    @Injected(\.userDefaults) var userDefaults
//
//    public var state: LoginState = .init()
//
////    private var defaultsManager: UserDefaultsManager
//
//    init(state: LoginState) {
//        self.state = state
////        self.setupValues()
//    }
//
//    private func setupValues() {
//        state.loggedIn = userDefaults.getValue(for: .hasSeenOnboarding)
//        state.userName = userDefaults.getValue(for: .username)
//    }
//
//    func logIn() {
//        print("Do nothing at this moment")
//    }
//
//    func logOut() {
//        print("Do nothing at this moment 2")
//    }
//}
//
//// Define the mock in the same class, so it's easier to maintain
//class MockLoginManager: LoginManager {
//    var state: LoginState = .init()
//
//    var didLogin = false
//    var didLogOut = false
//
//    func logIn() {
//        didLogin = true
//    }
//
//    func logOut() {
//        didLogOut = true
//    }
//}
//
//// MARK: SESSION MANAGER


final class SessionManager: ObservableObject {
    @Injected(\.userDefaults) var userDefaults

    @Published private(set) var currentState: AppState?

    init() {
        configureCurrentState()
        #if DEBUG
        trackLifetime()
        #endif
    }

    func goToOnboardingSetup() {
        currentState = .onboardingSetup
        print("yeah")
    }

    func completeOnboarding() {
        currentState = .onboardingSetup
    }

    func completeOnboardingSetup() {
        currentState = .loggedIn
        userDefaults.setValue(true, for: .hasSeenOnboarding)
    }

    func configureCurrentState() {
        /*
         - User closes the app during the onboarding phase > Resume the app from the onboarding screen
         - User closes the app after viewing onboarding > Resume the app from the main view (main app)
         */

        let hasCompletedOnboarding = userDefaults.getValue(for: .hasSeenOnboarding)

        if hasCompletedOnboarding {
            currentState = .loggedIn
        } else {
            currentState = .onboarding
        }
    }
}

enum AppState {
    case launching
    case loggedIn
    case onboardingSetup
    case onboarding
}


extension SessionManager: LifetimeTrackable {
    class var lifetimeConfiguration: LifetimeConfiguration {
        return LifetimeConfiguration(maxCount: 1, groupName: "SessionManager")
    }
}
