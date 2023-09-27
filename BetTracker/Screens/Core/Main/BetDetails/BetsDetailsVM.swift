import Foundation

class BetsDetailsVM: ObservableObject {

    let bet: BetModel
    let repository: Repository

    let defaults = UserDefaultsManager.path
    var defaultCurrency: Currency = .usd

    enum BetButtonState {
        case uncleared
        case won
        case lost
    }

    var buttonState: BetButtonState = .uncleared

    @Published
    var isAlertSet: Bool = false

    init(bet: BetModel, repository: Repository) {
        self.bet = bet
        self.repository = repository

        setup()
    }

    // MARK: -  Bet edit/delete methods:

    func markBetWon() {
        let newScore = (bet.profit).subtracting(bet.amount)

        repository.markBetStatus(model: bet, isWon: true, tableName: TableName.bet.rawValue)
        repository.updateProfit(model: bet, score: newScore, tableName: TableName.bet.rawValue)
    }

    func markBetLost() {
        let newScore = (bet.amount).multiplying(by: -1)

        repository.markBetStatus(model: bet, isWon: false, tableName: TableName.bet.rawValue)
        repository.updateProfit(model: bet, score: newScore, tableName: TableName.bet.rawValue)
    }

    func deleteBet(bet: BetModel) {
        repository.deleteBet(model: bet)
    }

    func removeNotification() {
        UserNotificationsService().removeNotification(notificationId: bet.betNotificationID ?? "")
    }

    // MARK: -  VM setup methods:

    private func setup() {
        checkButtonState()
        isNotificationInFuture()
        loadDefaultCurrency()
    }

    private func checkButtonState() {
        switch bet.isWon {
        case nil:
            buttonState = .uncleared
        case true?:
            buttonState = .won
        case false?:
            buttonState = .lost
        }
    }

    private func isNotificationInFuture() {
        if let notificationID = bet.betNotificationID, !notificationID.isEmpty {
            UserNotificationsService()
                .isNotificationDateInFuture(notificationId: notificationID) { isInFuture in
                    DispatchQueue.main.async {
                        self.isAlertSet = isInFuture
                    }
                }
        }
    }

    private func loadDefaultCurrency() {
        defaultCurrency = Currency(rawValue: defaults.get(.defaultCurrency)) ?? .usd
    }

}
