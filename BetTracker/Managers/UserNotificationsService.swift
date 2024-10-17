import Foundation
import SwiftUI
import UserNotifications
import LifetimeTracker

class UserNotificationsService {
    
    init() {
#if DEBUG
trackLifetime()
#endif
    }

    func scheduleNotification(
        withID id: String,
        titleName name: String,
        notificationTriggerDate date: Date
    ) {
        let content = UNMutableNotificationContent()

        let localizedStringNotificationTitle = NSLocalizedString(
            "%@ - your bet is waiting!",
            comment: ""
        )
        let finalStringNotificationTitle = String(format: localizedStringNotificationTitle, name)


        // ** Notification content **
        content.title = finalStringNotificationTitle
        content.body = NSLocalizedString(
            "Your bet is pending for settlement.",
            comment: ""
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
    
    func isNotificationDateInFuture(notificationId: String, completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            if let matchingRequest = requests.first(where: { $0.identifier == notificationId }),
               let trigger = matchingRequest.trigger as? UNCalendarNotificationTrigger {

                let notificationDate = trigger.nextTriggerDate()
                let now = Date()

                completion(notificationDate?.compare(now) == .orderedDescending)
            } else {
                completion(false)
            }
        }
    }
}

extension UserNotificationsService: LifetimeTrackable {
    class var lifetimeConfiguration: LifetimeConfiguration {
        return LifetimeConfiguration(maxCount: 1, groupName: "NotificationManager")
    }
}
