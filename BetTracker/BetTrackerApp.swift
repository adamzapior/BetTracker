import SwiftUI

@main
struct BetTrackerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

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
    
    // Notification acces to user options: [.x, y. etc...]
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
