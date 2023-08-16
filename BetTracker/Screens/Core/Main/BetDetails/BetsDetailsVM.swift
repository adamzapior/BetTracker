import Foundation

class BetsDetailsVM: ObservableObject {

    let respository: MainInteractor
    let bet: BetModel

    var buttonState: BetButtonState = .uncleared

    @Published
    var isShowingAlert = false

    var currency = UserDefaultsManager.defaultCurrencyValue

    enum BetButtonState {
        case uncleared
        case won
        case lost
    }

    init(respository: MainInteractor, bet: BetModel) {
        self.bet = bet
        self.respository = respository

        checkButtonState()
    }

    func deleteBet(bet: BetModel) {
        BetDao.deleteBet(bet: bet)
    }

    func removeNotification() {
        UserNotificationsService().removeNotification(notificationId: bet.betNotificationID ?? "")
    }

    func checkButtonState() {
        if bet.isWon == nil {
            buttonState = .uncleared
        } else if bet.isWon == true {
            buttonState = .won
        } else if bet.isWon == false {
            buttonState = .lost
        }
    }
}
