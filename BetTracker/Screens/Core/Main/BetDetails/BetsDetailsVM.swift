import Foundation

class BetsDetailsVM: ObservableObject {

    let bet: BetModel
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

    @Published
    var isShowingAlert: Bool = false

    init(bet: BetModel) {
        self.bet = bet

        setup()
    }
    
    deinit {
        print("VM is out")
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

    // MARK: -  Bet edit/delete methods:

    // TODO: !!!!

    func deleteBet(bet: BetModel) {
        BetDao.deleteBet(bet: bet)
    }

    func removeNotification() {
        UserNotificationsService().removeNotification(notificationId: bet.betNotificationID ?? "")
    }

}
