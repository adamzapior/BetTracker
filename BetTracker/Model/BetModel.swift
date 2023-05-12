//
//  BetModel.swift
//  BetTrackerUI
//
//  Created by Adam Zapiór on 22/02/2023.
//

import Foundation
import GRDB

struct BetModel: Identifiable, Hashable {
    
    let id: Int64?
    let date: Date
    let team1: String
    let team2: String
    let selectedTeam: SelectedTeam
    let league: String?
    let amount: NSDecimalNumber
    let odds: NSDecimalNumber
    let category: String?
    let tax: NSDecimalNumber
    let profit: String
    let isWon: Bool?
}


enum SelectedTeam: Int {
    case team1
    case team2
}

enum Category: String {
    case football
    case basketball
}

extension SelectedTeam: DatabaseValueConvertible { }
