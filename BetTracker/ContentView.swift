import SwiftUI

// struct ContentView: View {
//
//    @EnvironmentObject
//    var session: SessionManager
//
//    var body: some View {
//        ZStack {
//            switch session.currentState {
//            case .loggedIn:
//                TabBar()
//                    .transition(.move(edge: .bottom))
//            case .onboardingSetup:
//                OnboardingSetupView(
//                    vm: PreferencesVM(),
//                    action: session.completeOnboardingSetup
//                )
//                .animation(.easeInOut, value: 0.5)
//            case .onboarding:
//                OnboardingView(action: session.completeOnboarding)
//                    .transition(
//                        .move(edge: .bottom)
//                    )
//            default:
//                ProgressView()
//            }
//        }
//        .animation(.easeInOut, value: session.currentState)
//        .onAppear(perform: session.configureCurrentState)
//    }
// }

// struct ContentView_Previews: PreviewProvider {
//    var bet: BetModel
//
//    static var previews: some View {
//        ContentView()
//    }
// }

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_: UIGestureRecognizer) -> Bool {
        viewControllers.count > 1
    }
}

struct ContentView: View {
    enum Tab: String, CaseIterable {
        case a, b, c

        var icon: String {
            switch self {
            case .a: return "house"
            case .b: return "plus"
            case .c: return "heart"
            }
        }

        var title: String {
            switch self {
            case .a: return "Feed"
            case .b: return "Add bet"
            case .c: return "Profile"
            }
        }
    }

    @Environment(AppRouter.self) private var appRouter
    @State private var selectedTab: Tab = .a

    var body: some View {
        @Bindable var appRouter = appRouter

//        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
//                MainView()
//                    .tag(Tab.a)
//                    .environment(appRouter.tabARouter)
//
//                AddBetScreen()
//                    .tag(Tab.b)
//                    .environment(appRouter.tabBRouter)
//
//                ProfileView()
//                    .tag(Tab.c)
//                    .environment(appRouter.tabCRouter)

                MainView()
                    .tag(Tab.a)
                    .tabItem {
                        Image(systemName: Tab.a.icon)
                        Text(Tab.a.title)
                    }
                    .environment(appRouter.tabARouter)

                ProfileScreen()
                    .tag(Tab.c)
                    .tabItem {
                        Image(systemName: Tab.c.icon)
                        Text(Tab.c.title)
                    }
                    .environment(appRouter.tabCRouter)
            }
            .tint(Color.ui.scheme)
            .environment(\.currentTab, $appRouter.selectedTab)

//            .onAppear {
//                UITabBar.appearance().isHidden = true
//            }
//
//            CustomTabBar(selectedTab: $selectedTab)
//        }
//        .edgesIgnoringSafeArea(.bottom)
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: ContentView.Tab

    var body: some View {
        HStack(spacing: 64) {
            ForEach(ContentView.Tab.allCases, id: \.self) { tab in
                TabBarButton(tab: tab, isSelected: selectedTab == tab) {
                    selectedTab = tab
                }
            }
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 5)
        .background(Material.ultraThinMaterial)
        .clipShape(Capsule())
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: 5)
        .padding(.horizontal)
        .padding(.bottom, 20)
    }
}

struct TabBarButton: View {
    let tab: ContentView.Tab
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: tab.icon)
                .renderingMode(.template)
                .font(.system(size: 18))
                .foregroundColor(isSelected ? .blue : .gray)
                .frame(width: 44, height: 44)
                .background(isSelected ? Color.blue.opacity(0.2) : Color.clear)
                .clipShape(Circle())
        }
    }
}
