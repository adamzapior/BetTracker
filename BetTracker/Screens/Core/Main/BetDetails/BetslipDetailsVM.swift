import Foundation

class BetslipDetailsVM: ObservableObject {

    let bet: BetslipModel
    let respository: Respository

    let defaults = UserDefaultsManager.path
    var defaultCurrency: Currency = .usd

    var buttonState: BetButtonState = .uncleared
    
    @Published
    var isAlertSet: Bool = false

    init(bet: BetslipModel, respository: Respository) {
        self.bet = bet
        self.respository = respository

        setup()
    }

    // MARK: -  Bet edit/delete methods:

    func markBetWon() {
        let newScore = (bet.profit).subtracting(bet.amount)
        
        respository.markBetStatus(model: bet, isWon: true, tableName: TableName.betslip.rawValue)
        respository.updateProfit(model: bet, score: newScore, tableName: TableName.betslip.rawValue)
    }
    
    func markBetLost() {
        let newScore = (bet.amount).multiplying(by: -1)
        
        respository.markBetStatus(model: bet, isWon: false, tableName: TableName.betslip.rawValue)
        respository.updateProfit(model: bet, score: newScore, tableName: TableName.betslip.rawValue)
    }

    func deleteBet(bet: BetslipModel) {
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

    enum BetButtonState {
        case uncleared
        case won
        case lost
    }
}
