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

}
