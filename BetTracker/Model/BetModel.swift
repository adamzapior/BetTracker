import Foundation
import GRDB

struct BetModel: Identifiable, Hashable, DatabaseModel, FetchableRecord {
    init(
        id: Int64?,
        date: Date,
        team1: String,
        team2: String,
        selectedTeam: SelectedTeam,
        league: String?,
        amount: NSDecimalNumber,
        odds: NSDecimalNumber,
        category: Category,
        tax: NSDecimalNumber,
        profit: NSDecimalNumber,
        note: String?,
        isWon: Bool?,
        betNotificationID: String?,
        score: NSDecimalNumber?
    ) {
        self.id = id
        self.date = date
        self.team1 = team1
        self.team2 = team2
        self.selectedTeam = selectedTeam
        self.league = league
        self.amount = amount
        self.odds = odds
        self.category = category
        self.tax = tax
        self.profit = profit
        self.note = note
        self.isWon = isWon
        self.betNotificationID = betNotificationID
        self.score = score
    }

    var id: Int64?
    var date: Date
    let team1: String
    let team2: String
    let selectedTeam: SelectedTeam
    let league: String?
    let amount: NSDecimalNumber
    let odds: NSDecimalNumber
    let category: Category
    var tax: NSDecimalNumber
    let profit: NSDecimalNumber
    let note: String?
    let isWon: Bool?
    let betNotificationID: String?
    let score: NSDecimalNumber?

    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d/yyyy"
        return dateFormatter.string(from: date)
    }
}

extension BetModel {
    func getBetPickValue() -> String {
        switch self.selectedTeam {
        case .team1:
            return team1
        case .team2:
            return team2
        case .draw:
            return "Draw"
        }
    }
}

enum SelectedTeam: Int {
    case team1
    case team2
    case draw

    static var allCases: [SelectedTeam] {
        return [.team1, .team2, .draw]
    }
}

extension SelectedTeam {
    var displayName: String {
        switch self {
        case .team1: return "Team 1"
        case .team2: return "Team 2"
        case .draw: return "Draw"
        }
    }
}

extension SelectedTeam: DatabaseValueConvertible {}
