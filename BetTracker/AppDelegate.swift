//
//  AppDelegate.swift
//  BetTracker
//
//  Created by Adam Zapiór on 12/05/2023.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    configureUserNotifications()
//      - wyłączenie tej funkcji powoduje, że nie działają akcje
    return true
  }
}


// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void
  ) {
    completionHandler(.banner)
  }
  
  // tego nie musze !!!
  private func configureUserNotifications() {
    UNUserNotificationCenter.current().delegate = self
    // 1
    let dismissAction = UNNotificationAction(
      identifier: "dismiss",
      title: "Dismiss",
      options: []
    )
    let markAsDone = UNNotificationAction(
      identifier: "markAsDone",
      title: "Mark As Done",
      options: []
    )
    // 2
    let category = UNNotificationCategory(
      identifier: "OrganizerPlusCategory",
      actions: [dismissAction, markAsDone],
      intentIdentifiers: [],
      options: []
    )
    // 3
    UNUserNotificationCenter.current().setNotificationCategories([category]) // powoduje ∑łączenie opcji tak aby sie wyswietlaly
  }

  // 1
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    completionHandler()
  }
}
