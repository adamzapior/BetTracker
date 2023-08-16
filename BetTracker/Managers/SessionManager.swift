import Foundation

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
