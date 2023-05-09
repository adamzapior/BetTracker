import Foundation

final class SessionManager: ObservableObject {

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
        UserDefaultsManager.useManager.set(true, forKey: UserDefaultsManager.Keys.hasSeenOnboarding)
    }

    func configureCurrentState() {
        /*
         - User closes the app during the onboarding phase > Resume the app from the onboarding screen
         - User closes the app after viewing onboarding > Resume the app from the log in screen (main app)
         */

        let hasCompletedOnboarding = UserDefaults.standard
            .bool(forKey: UserDefaultsManager.Keys.hasSeenOnboarding)

        if hasCompletedOnboarding {
            currentState = .loggedIn
        } else {
            currentState = .onboarding
        }
    }
}
