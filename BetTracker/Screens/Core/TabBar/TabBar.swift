import SwiftUI

struct Destination: Equatable {
    static func ==(lhs: Destination, rhs: Destination) -> Bool {
        lhs.icon == rhs.icon
    }

    let icon: String
    let view: () -> any View
}

struct CloseTabAction: EnvironmentKey {
    static var defaultValue = { }
}

extension EnvironmentValues {
    var closeTab: () -> Void {
        get {
            self[CloseTabAction.self]
        }
        set {
            self[CloseTabAction.self] = newValue
        }
    }
}

struct TabBar: View {
    @State
    var selectedTab = destinations.first!
    @Environment(\.isPresented)
    var isPresented

    private func closeTab() {
        selectedTab = TabBar.destinations.first!
    }

    private static let destinations = [
        Destination(icon: "house", view: { MainView() }),
        Destination(icon: "plus", view: { AddBetScreen() }),
        Destination(icon: "heart", view: { ProfileView() })
    ]

    @State
    private var isKeyboardShown = false


    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    AnyView(selectedTab.view()).environment(\.closeTab, closeTab)
                }
                .safeAreaInset(edge: .bottom) {
                    if selectedTab != TabBar.destinations[1], !isKeyboardShown {
                        HStack(spacing: 0) {
                            NavigationLink(destination: PreferencesView()) {
                                Image(systemName: "plus")
                                    .renderingMode(.template)
                                    .foregroundColor(Color.ui.secondary.opacity(1))
                                    .padding()
                            }

                            ForEach(TabBar.destinations, id: \.icon) { tab in
                                Spacer()
                                TabBarButton(
                                    tab: tab,
                                    isSelected: tab == selectedTab
                                )
                                .onTapGesture {
                                    selectedTab = tab
                                }
                                Spacer()
                            }
                        }
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                        .padding(.horizontal, 25)
                        .padding(.vertical, 5)
                        .background(Material.ultraThinMaterial)
                        .clipShape(Capsule())
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: 5)
                        .padding(.horizontal)
                    }
                }
            }

//            .onReceive(
//                NotificationCenter.default
//                    .publisher(for: UIResponder.keyboardWillShowNotification)
//            ) { _ in
//                // Keyboard will show
//                isKeyboardShown = true
//            }
//            .onReceive(
//                NotificationCenter.default
//                    .publisher(for: UIResponder.keyboardWillHideNotification)
//            ) { _ in
//                // Keyboard will hide
//                isKeyboardShown = false
//            }
        }
    }

    var tabs = ["house", "plus", "heart"]

    struct TabBarButton: View {
        let tab: Destination
        let isSelected: Bool

        var body: some View {
            Image(systemName: tab.icon)
                .renderingMode(.template)
                .foregroundColor(isSelected ? Color.ui.scheme : Color.ui.secondary.opacity(1))
                .padding()
        }
    }

    struct TabBar_Previews: PreviewProvider {
        static var previews: some View {
            TabBar()
        }
    }
}
