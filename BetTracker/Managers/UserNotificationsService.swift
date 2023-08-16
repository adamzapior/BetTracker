import Foundation
import SwiftUI
import UserNotifications

struct UserNotificationsService {

    func scheduleNotification(
        withID id: String,
        titleName name: String,
        notificationTriggerDate date: Date
    ) {
        let content = UNMutableNotificationContent()

        let localizedStringNotificationTitle = NSLocalizedString(
            "%@ Your bet is waiting!",
            comment: ""
        )
        let finalStringNotificationTitle = String(format: localizedStringNotificationTitle, name)

        let localizedStringNotificationBody = NSLocalizedString(
            " YYou have picked %@ and bet is still pending(Edytowano)Przywróć oryginał!",
            comment: ""
        )
        let finalStringNotificationBody = String(format: localizedStringNotificationBody, name)

        // ** Notification content **
        content.title = finalStringNotificationTitle
        content.body = NSLocalizedString(
            "Your bet is pending for settlement.",
            comment: "Notification body"
        )
        content.sound = UNNotificationSound.default

        let dateComponents = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: date
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        print(
            "DEBUG: New Notification set at time: [\(dateComponents.description.uppercased())] with id: \(id)"
        )
    }

    func removeNotification(notificationId: String) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [notificationId])
        print("DEBUG: Removed notification with id: \(notificationId)")
    }

}
