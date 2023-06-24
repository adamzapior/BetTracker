//
//  BetslipModel.swift
//  BetTracker
//
//  Created by Adam Zapiór on 24/06/2023.
//

import Foundation

struct BetslipModel: Identifiable, Hashable {
    let id: Int64
    let name: String
    let date: Date
    let amount: NSDecimalNumber
    let odds: NSDecimalNumber
    let category: Category
    let tax: NSDecimalNumber
    let profit: NSDecimalNumber
    let isWon: Bool?
    let betNotificationID: String?
    let score: NSDecimalNumber?
}
