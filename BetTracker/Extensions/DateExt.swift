//
//  DateExt.swift
//  BetTracker
//
//  Created by Adam Zapiór on 24/06/2023.
//

import Foundation

extension Date {
    func formatSelectedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d/M/yyyy"
        return dateFormatter.string(from: self)
    }
}
