import SwiftUI

struct ContentView: View {
    @EnvironmentObject var sessionManager: SessionManager

    @Environment(AppRouter.self) private var appRouter
    @State private var selectedTab: Tab = .a
    var body: some View {
        @Bindable var appRouter = appRouter

        TabView(selection: $selectedTab) {
            FeedScreen()
                .tag(Tab.a)
                .tabItem {
                    Image(systemName: Tab.a.icon)
                    Text(Tab.a.title)
                }
                .environment(appRouter.tabARouter)

            ProfileScreen()
                .tag(Tab.b)
                .tabItem {
                    Image(systemName: Tab.b.icon)
                    Text(Tab.b.title)
                }
                .environment(appRouter.tabBRouter)
        }
        .tint(Color.ui.scheme)
        .environment(\.currentTab, $appRouter.selectedTab)
        .overlay {
            overlayOnboarding()
        }
    }

    private func overlayOnboarding() -> some View {
        ZStack {
            switch sessionManager.currentState {
            case .loggedIn:
                EmptyView()
                    .transition(.move(edge: .bottom))
            case .onboardingSetup:
                OnboardingSetupScreen(
                    action: sessionManager.completeOnboardingSetup
                )
                .animation(.easeInOut, value: 0.5)
            case .onboarding:
                OnboardingScreen(action: sessionManager.goToOnboardingSetup)
                    .transition(
                        .move(edge: .bottom)
                    )
            default:
                ProgressView()
            }
        }
        .onChange(of: sessionManager.currentState) { oldValue, newValue in
            print("State changed from \(String(describing: oldValue)) to \(String(describing: newValue))")
        }
        .animation(.easeInOut, value: sessionManager.currentState)
        .onAppear(perform: sessionManager.configureCurrentState)
    }
}

extension ContentView {
    enum Tab: String, CaseIterable {
        case a, b

        var icon: String {
            switch self {
            case .a: return "house"
            case .b: return "heart"
            }
        }

        var title: String {
            switch self {
            case .a: return "Feed"
            case .b: return "Profile"
            }
        }
    }
}
