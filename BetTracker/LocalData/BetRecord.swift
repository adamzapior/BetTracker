import Foundation
import GRDB

extension BetModel: TableRecord {
    static var databaseTableName = "bet"

    enum Columns: String, ColumnExpression {
        case id
        case date
        case team1
        case team2
        case selectedTeam
        case league
        case amount
        case odds
        case category
        case tax
        case profit
        case isWon
        case betNotificationID
        case score
    }
}

extension BetModel {
    init(row: Row) {
        id = row[Columns.id]
        date = row[Columns.date]
        team1 = row[Columns.team1]
        team2 = row[Columns.team2]
        selectedTeam = row[Columns.selectedTeam]
        league = row[Columns.league]
        amount = row[Columns.amount]
        odds = row[Columns.odds]
        category = row[Columns.category]
        tax = row[Columns.tax]
        profit = row[Columns.profit]
        isWon = row[Columns.isWon]
        betNotificationID = row[Columns.betNotificationID]
        score = row[Columns.score]
    }
}

extension BetModel: PersistableRecord {
    func encode(to container: inout PersistenceContainer) {
        container[Columns.id] = id
        container[Columns.date] = date
        container[Columns.team1] = team1
        container[Columns.team2] = team2
        container[Columns.selectedTeam] = selectedTeam
        container[Columns.league] = league
        container[Columns.amount] = amount
        container[Columns.odds] = odds
        container[Columns.category] = category
        container[Columns.tax] = tax
        container[Columns.profit] = profit
        container[Columns.isWon] = isWon
        container[Columns.betNotificationID] = betNotificationID
        container[Columns.score] = score
    }
}

extension BetslipModel: TableRecord {
    static var databaseTableName = "betslip"

    enum Columns: String, ColumnExpression {
        case id
        case name
        case date
        case amount
        case odds
        case category
        case tax
        case profit
        case isWon
        case betNotificationID
        case score
    }
}

extension BetslipModel: FetchableRecord {
    init(row: Row) {
        id = row[Columns.id]
        name = row[Columns.name]
        date = row[Columns.date]
        amount = row[Columns.amount]
        odds = row[Columns.odds]
        category = row[Columns.category]
        tax = row[Columns.tax]
        profit = row[Columns.profit]
        isWon = row[Columns.isWon]
        betNotificationID = row[Columns.betNotificationID]
        score = row[Columns.score]
    }
}

extension BetslipModel: PersistableRecord {
    func encode(to container: inout PersistenceContainer) throws {
        container[Columns.id] = id
        container[Columns.name] = name
        container[Columns.date] = date
        container[Columns.amount] = amount
        container[Columns.odds] = odds
        container[Columns.category] = category
        container[Columns.tax] = tax
        container[Columns.profit] = profit
        container[Columns.isWon] = isWon
        container[Columns.betNotificationID] = betNotificationID
        container[Columns.score] = score
    }
}
