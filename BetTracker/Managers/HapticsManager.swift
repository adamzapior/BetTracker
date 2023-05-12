//
//  HapticsManager.swift
//  WaterMe
//
//  Created by Adam Zapiór on 12/05/2023.
//

import Foundation
import UIKit

class HapticManager {
    static private let generator = UINotificationFeedbackGenerator()

    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
}
