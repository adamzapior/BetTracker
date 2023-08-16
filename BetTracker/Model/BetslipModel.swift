import Foundation

struct BetslipModel: Identifiable, Hashable, DatabaseModel {

    init(
        id: Int64?,
        date: Date,
        name: String,
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
        self.name = name
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
    let name: String
    var date: Date
    let amount: NSDecimalNumber
    let odds: NSDecimalNumber
    let category: Category
    var tax: NSDecimalNumber
    let profit: NSDecimalNumber
    let note: String?
    let isWon: Bool?
    let betNotificationID: String?
    let score: NSDecimalNumber?
}
