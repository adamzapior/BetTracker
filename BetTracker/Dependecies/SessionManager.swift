import Foundation

public protocol LoginManager {
    var state: LoginState { get }
    func logIn()
    func logOut()
}

public class LoginState: ObservableObject {
    @Published var loggedIn: Bool = false
    @Published var userName: String? = nil
}

class AppLoginManager: LoginManager {

    
    public var state: LoginState = LoginState()
    
//    private var defaultsManager: UserDefaultsManager
    
    init(state: LoginState) {
        self.state = state
        self.setupValues()
    }
    
    private func setupValues() {
        self.state.loggedIn = UserDefaultsManager.path.get(.hasSeenOnboarding)
        self.state.userName = UserDefaultsManager.path.get(.username)
    }
    
    func logIn() {
        print("Do nothing at this moment")
    }
    
    func logOut() {
        print("Do nothing at this moment 2")

    }
}

// Define the mock in the same class, so it's easier to maintain
class MockLoginManager: LoginManager {
    var state: LoginState = LoginState()
    
    var didLogin = false
    var didLogOut = false
    
    func logIn() {
        self.didLogin = true
    }

    func logOut() {
        self.didLogOut = true
    }
}



// MARK: SESSION MANAGER

final class SessionManager: ObservableObject {

    let defaults = UserDefaultsManager.path

    enum CurrentState {
        case loggedIn
        case onboardingSetup
        case onboarding

    }

    @Published
    private(set) var currentState: CurrentState?

    func goToOnboardingSetup() {
        currentState = .onboardingSetup
    }

    func completeOnboarding() {
        currentState = .onboardingSetup
    }

    func completeOnboardingSetup() {
        currentState = .loggedIn
        defaults.set(.hasSeenOnboarding, to: true)
    }

    func configureCurrentState() {
        /*
         - User closes the app during the onboarding phase > Resume the app from the onboarding screen
         - User closes the app after viewing onboarding > Resume the app from the main view (main app)
         */

        let hasCompletedOnboarding = defaults.get(.hasSeenOnboarding)

        if hasCompletedOnboarding {
            currentState = .loggedIn
        } else {
            currentState = .onboarding
        }
    }
}
