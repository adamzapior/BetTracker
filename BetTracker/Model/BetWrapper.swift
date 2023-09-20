import Foundation

enum BetWrapper: Identifiable, Hashable {
    case bet(BetModel)
    case betslip(BetslipModel)

    var id: String {
        switch self {
        case let .bet(bet): return "bet-\(String(describing: bet.id))-\(String(describing: bet.hashValue))"
        case let .betslip(betslip): return "betslip-\(String(describing: betslip.id))-\(String(describing: betslip.hashValue))"
        }
    }

    var date: Date {
        switch self {
        case let .bet(bet): return bet.date
        case let .betslip(betslip): return betslip.date
        }
    }

    var team1: String? {
        switch self {
        case let .bet(bet): return bet.team1
        case .betslip:
            return nil
        }
    }

    var team2: String? {
        switch self {
        case let .bet(bet): return bet.team2
        case .betslip:
            return nil
        }
    }

    var name: String? {
        switch self {
        case .bet:
            return nil
        case let .betslip(betslip): return betslip.name
        }
    }

    var amount: NSDecimalNumber {
        switch self {
        case let .bet(bet): return bet.amount
        case let .betslip(betslip): return betslip.amount
        }
    }

    var isWon: Bool? {
        switch self {
        case let .bet(bet): return bet.isWon
        case let .betslip(betslip): return betslip.isWon
        }
    }
    
    var selectedTeam: SelectedTeam? {
        switch self {
        case let .bet(bet): return bet.selectedTeam
        case .betslip: return nil
        }
    }

    var odds: NSDecimalNumber {
        switch self {
        case let .bet(bet): return bet.odds
        case let .betslip(betslip): return betslip.odds
        }
    }

    var category: Category {
        switch self {
        case let .bet(bet): return bet.category
        case let .betslip(betslip): return betslip.category
        }
    }

    var tax: NSDecimalNumber {
        switch self {
        case let .bet(bet): return bet.tax
        case let .betslip(betslip): return betslip.tax
        }
    }

    var profit: NSDecimalNumber {
        switch self {
        case let .bet(bet): return bet.profit
        case let .betslip(betslip): return betslip.profit
        }
    }

    var note: String? {
        switch self {
        case let .bet(bet): return bet.note
        case let .betslip(betslip): return betslip.note
        }
    }

    var score: NSDecimalNumber? {
        switch self {
        case let .bet(bet): return bet.score
        case let .betslip(betslip): return betslip.score
        }
    }

}
