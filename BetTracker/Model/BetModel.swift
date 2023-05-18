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
    let category: Category
    let tax: NSDecimalNumber
    let profit: NSDecimalNumber
    let isWon: Bool?
    let betNotificationID: String?
    let score: NSDecimalNumber?
    

    
    
    var dateString: String {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "M/d/yyyy"
      return dateFormatter.string(from: date)
    }

}



enum SelectedTeam: Int {
    case team1
    case team2
}

enum Category: String, CaseIterable {
    case football
    case basketball
    case f1
    case tenis
    case volleyball
}

extension SelectedTeam: DatabaseValueConvertible { }

extension Category: DatabaseValueConvertible { }


