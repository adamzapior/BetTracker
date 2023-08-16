import SwiftUI

@main
struct BetTrackerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self)
    var appDelegate

    @StateObject
    private var session = SessionManager()

    init() {
        requestNotificationPermission()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(session)
        }
    }

    // TODO: Przeniesienie tej usługi do dodania powiadomienia/ustawień deeplink
    func requestNotificationPermission() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                if granted {
                    print("DEBUG: Permission for notifications granted")
                } else if let error {
                    print(
                        "DEBUG: Error getting authorization for notifications: \(error.localizedDescription)"
                    )
                }
            }
    }

}
