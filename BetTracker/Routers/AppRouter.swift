//
//  AppRouter.swift
//  BetTracker
//
//  Created by Adam Zapiór on 30/09/2024.
//

import Foundation
import LifetimeTracker
import SwiftUI


@Observable class AppRouter {
    // MARK: - App states

//    var presentedSheet: PresentedSheet?
    var selectedTab: ContentView.Tab = .a

    // MARK: - Routers

    var tabARouter = FeedTabRouter()
    var tabBRouter = ProfileTabRouter()
}

@Observable class ProfileTabRouter: BaseRouter {
    enum Destination: Codable, RouterDestination {
        var description: String {
            switch self {
            case .settings: "Settings"
            }
        }
        
        case settings
    }
    
    @ObservationIgnored override var routerDestinationTypes: [any RouterDestination.Type] {
        return [Destination.self]
    }
    
    // MARK: - Public

    func navigate(to destination: Destination) {
        path.append(destination)
    }
}

@Observable class FeedTabRouter: BaseRouter {
    typealias betType = BetType
    
    enum Destination: Codable, RouterDestination {
        case bet(BetModel)
        case betslip(BetslipModel)
        case search
        case add
        
        var description: String {
            switch self {
            case .bet: return "Bet"
            case .betslip: return "Betslip"
            case .search: return "Search"
            case .add: return "Add bet"
            }
        }
        
        var title: String {
            switch self {
            case .bet: return "Bet"
            case .betslip: return "Betslip"
            case .search: return "Search"
            case .add: return "Add bet"
            }
        }
        
        private enum CodingKeys: String, CodingKey {
            case bet, betslip, search, add
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            switch self {
            case .bet(let betModel):
                try container.encode(betModel, forKey: .bet)
            case .betslip(let betslipModel):
                try container.encode(betslipModel, forKey: .betslip)
            case .search:
                try container.encodeNil(forKey: .search)
            case .add:
                try container.encodeNil(forKey: .add)
            }
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if let betModel = try? container.decode(BetModel.self, forKey: .bet) {
                self = .bet(betModel)
            } else if let betslipModel = try? container.decode(BetslipModel.self, forKey: .betslip) {
                self = .betslip(betslipModel)
            } else if container.contains(.search) {
                self = .search
            } else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: container.codingPath,
                        debugDescription: "Invalid Destination"
                    )
                )
            }
        }
    }
    
    @ObservationIgnored override var routerDestinationTypes: [any RouterDestination.Type] {
        return [Destination.self]
    }
    
    // MARK: - Public

    func navigate(to destination: Destination) {
        path.append(destination)
    }
}

// Rozszerzenia dla BetModel i BetslipModel, aby konformowały do Codable
extension BetModel: Codable {
    enum CodingKeys: String, CodingKey {
        case id, date, team1, team2, selectedTeam, league, amount, odds, category, tax, profit, note, isWon, betNotificationID, score
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(team1, forKey: .team1)
        try container.encode(team2, forKey: .team2)
        try container.encode(selectedTeam.rawValue, forKey: .selectedTeam)
        try container.encode(league, forKey: .league)
        try container.encode(amount.stringValue, forKey: .amount)
        try container.encode(odds.stringValue, forKey: .odds)
        try container.encode(category.rawValue, forKey: .category)
        try container.encode(tax.stringValue, forKey: .tax)
        try container.encode(profit.stringValue, forKey: .profit)
        try container.encode(note, forKey: .note)
        try container.encode(isWon, forKey: .isWon)
        try container.encode(betNotificationID, forKey: .betNotificationID)
        try container.encode(score?.stringValue, forKey: .score)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int64?.self, forKey: .id)
        date = try container.decode(Date.self, forKey: .date)
        team1 = try container.decode(String.self, forKey: .team1)
        team2 = try container.decode(String.self, forKey: .team2)
        selectedTeam = try SelectedTeam(rawValue: container.decode(Int.self, forKey: .selectedTeam)) ?? .team1
        league = try container.decodeIfPresent(String.self, forKey: .league)
        amount = try NSDecimalNumber(string: container.decode(String.self, forKey: .amount))
        odds = try NSDecimalNumber(string: container.decode(String.self, forKey: .odds))
        category = try Category(rawValue: container.decode(String.self, forKey: .category)) ?? .other
        tax = try NSDecimalNumber(string: container.decode(String.self, forKey: .tax))
        profit = try NSDecimalNumber(string: container.decode(String.self, forKey: .profit))
        note = try container.decodeIfPresent(String.self, forKey: .note)
        isWon = try container.decodeIfPresent(Bool.self, forKey: .isWon)
        betNotificationID = try container.decodeIfPresent(String.self, forKey: .betNotificationID)
        score = try container.decodeIfPresent(String.self, forKey: .score).flatMap { NSDecimalNumber(string: $0) }
    }
}

extension BetslipModel: Codable {
    enum CodingKeys: String, CodingKey {
        case id, date, name, amount, odds, category, tax, profit, note, isWon, betNotificationID, score
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(name, forKey: .name)
        try container.encode(amount.stringValue, forKey: .amount)
        try container.encode(odds.stringValue, forKey: .odds)
        try container.encode(category.rawValue, forKey: .category)
        try container.encode(tax.stringValue, forKey: .tax)
        try container.encode(profit.stringValue, forKey: .profit)
        try container.encode(note, forKey: .note)
        try container.encode(isWon, forKey: .isWon)
        try container.encode(betNotificationID, forKey: .betNotificationID)
        try container.encode(score?.stringValue, forKey: .score)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int64?.self, forKey: .id)
        date = try container.decode(Date.self, forKey: .date)
        name = try container.decode(String.self, forKey: .name)
        amount = try NSDecimalNumber(string: container.decode(String.self, forKey: .amount))
        odds = try NSDecimalNumber(string: container.decode(String.self, forKey: .odds))
        category = try Category(rawValue: container.decode(String.self, forKey: .category)) ?? .other
        tax = try NSDecimalNumber(string: container.decode(String.self, forKey: .tax))
        profit = try NSDecimalNumber(string: container.decode(String.self, forKey: .profit))
        note = try container.decodeIfPresent(String.self, forKey: .note)
        isWon = try container.decodeIfPresent(Bool.self, forKey: .isWon)
        betNotificationID = try container.decodeIfPresent(String.self, forKey: .betNotificationID)
        score = try container.decodeIfPresent(String.self, forKey: .score).flatMap { NSDecimalNumber(string: $0) }
    }
}
