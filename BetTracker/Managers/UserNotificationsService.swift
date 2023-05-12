//
//  NotificationManager.swift
//  BetTracker
//
//  Created by Adam Zapiór on 10/05/2023.
//


import Foundation
import UserNotifications
import SwiftUI

struct UserNotificationsService {
    
    /// withID: we want to have the same id for plant and for notification in order to enable its deletion later.
    func scheduleNotification(withID id: String, titleName name: String, notificationTriggerDate date: Date) {
        let content = UNMutableNotificationContent()
        
        // Problem with localization notification title:
        // Temporary solution taken from stackOverflow (https://stackoverflow.com/questions/26684868/nslocalizedstring-with-variables-swift) -> I'm sure it can be done different.
        let localizedStringNotificationTitle = NSLocalizedString("%@ Your bet is waiting!", comment: "")
        let finalStringNotificationTitle = String(format: localizedStringNotificationTitle, name)
        
        let localizedStringNotificationBody = NSLocalizedString(" YYou have picked %@ and bet is still pending(Edytowano)Przywróć oryginał!", comment: "")
        let finalStringNotificationBody = String(format: localizedStringNotificationBody, name)
        
        
        
        /// ** Notification content **
        content.title = finalStringNotificationTitle
        content.body = NSLocalizedString("Your bet is pending for settlement.", comment: "Notification body")
        content.sound = UNNotificationSound.default
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day,.hour , .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        print("DEBUG: New Notification set at time: [\(dateComponents.description.uppercased())] with id: \(id)")
    }
    
    func removeNotification(notificationId: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationId])
        print("DEBUG: Removed notification with id: \(notificationId)")
    }
    
}
