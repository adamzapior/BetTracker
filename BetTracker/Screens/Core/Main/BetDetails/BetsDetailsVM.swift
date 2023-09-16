import Foundation

class BetsDetailsVM: ObservableObject {

    let bet: BetModel
    let respository: Respository

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

//    @Published
//    var isShowingAlert: Bool = false

    init(bet: BetModel, respository: Respository) {
        self.bet = bet
        self.respository = respository

        setup()
    }

    deinit {
        print("VM is out")
    }

    // MARK: -  Bet edit/delete methods:

    func markBetWon() {
        let newScore = (bet.profit).subtracting(bet.amount)

        respository.markBetStatus(model: bet, isWon: true, tableName: TableName.bet.rawValue)
        respository.updateProfit(model: bet, score: newScore, tableName: TableName.bet.rawValue)
    }

    func markBetLost() {
        let newScore = (bet.amount).multiplying(by: -1)

        respository.markBetStatus(model: bet, isWon: false, tableName: TableName.bet.rawValue)
        respository.updateProfit(model: bet, score: newScore, tableName: TableName.bet.rawValue)
    }

    func deleteBet(bet: BetModel) {
        respository.deleteBet(model: bet)
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
