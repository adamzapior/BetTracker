import Foundation

struct BetslipModel: Identifiable, Hashable {

    init(
        id: Int64?,
        date: Date,
        name: String,
        amount: NSDecimalNumber,
        odds: NSDecimalNumber,
        category: Category,
        tax: NSDecimalNumber,
        profit: NSDecimalNumber,
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
    let tax: NSDecimalNumber
    let profit: NSDecimalNumber
    let isWon: Bool?
    let betNotificationID: String?
    let score: NSDecimalNumber?
}