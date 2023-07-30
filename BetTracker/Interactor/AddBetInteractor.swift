import Foundation



/// exmp for mock
protocol AddBetInteractorProtocol {

    var defaults: UserDefaults { set get }

    func savebetTest(
        id: Int64?,
        date: Date,
        team1: String,
        team2: String,
        selectedTeam: SelectedTeam,
        amount: NSDecimalNumber,
        odds: NSDecimalNumber,
        category: Category,
        league: String,
        selectedDate: Date,
        tax: NSDecimalNumber,
        profit: NSDecimalNumber,
        isWon: Bool?,
        betNotificationID: String,
        score: NSDecimalNumber
    )

    func saveBet<T: DatabaseModel>(model: T)

    func saveTextfield(
        team1: String,
        team2: String,
        amount: String,
        odds: String,
        category: String,
        league: String,
        selectedDate: Date
    )

    func loadTextfield()

}

/// use case
class AddBetInteractor: AddBetInteractorProtocol {
 
 
    
    func savebetTest(
        id: Int64?,
        date: Date,
        team1: String,
        team2: String,
        selectedTeam: SelectedTeam,
        amount: NSDecimalNumber,
        odds: NSDecimalNumber,
        category: Category,
        league: String,
        selectedDate: Date,
        tax: NSDecimalNumber,
        profit: NSDecimalNumber,
        isWon: Bool?,
        betNotificationID: String,
        score: NSDecimalNumber
    ) {
        var xd = BetModel(
            id: id,
            date: selectedDate,
            team1: team1,
            team2: team2,
            selectedTeam: .team1,
            league: league,
            amount: amount,
            odds: odds,
            category: category,
            tax: tax,
            profit: profit,
            isWon: isWon,
            betNotificationID: betNotificationID,
            score: score
        )
        
        saveBet(model: xd)
    }

    func saveTextfield(
        team1: String,
        team2: String,
        amount: String,
        odds: String,
        category: String,
        league: String,
        selectedDate: Date
    ) {
        defaults.set(.team1, to: team1)
        defaults.set(.team2, to: team2)
        defaults.set(.amount, to: amount)
        defaults.set(.odds, to: odds)
        defaults.set(.category, to: category)
        defaults.set(.league, to: league)
        defaults.set(.selectedDate, to: selectedDate)
    }

    func loadTextfield() { }

    var defaults: UserDefaults = UserDefaultsManager.path

    let BetDao: BetDao

    init(BetDao: BetDao) {
        self.BetDao = BetDao
    }

    func saveBet(model: some DatabaseModel) {
        BetDao.saveBet(bet: model)
    }
}
