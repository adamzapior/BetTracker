//
//  NumbersExt.swift
//  BetTracker
//
//  Created by Adam Zapiór on 14/05/2023.
//

import Foundation

extension Double {
    func doubleWith2Digits() -> Double {
        return Double(String(format: "%.2f", self)) ?? self
    }
}

extension Double {
    func formattedWith2Digits() -> String {
        return String(format: "%.2f", self)
    }
}
