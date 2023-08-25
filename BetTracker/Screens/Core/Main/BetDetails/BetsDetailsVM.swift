import Foundation

class BetsDetailsVM: ObservableObject {

//    let respository: MainInteractor
    let bet: BetModel

    var buttonState: BetButtonState = .uncleared

    @Published
    var isAlertSet: Bool = false
    
    @Published
    var isShowingAlert: Bool = false

    var currency = UserDefaultsManager.defaultCurrencyValue

    enum BetButtonState {
        case uncleared
        case won
        case lost
    }

    init(bet: BetModel) {
        self.bet = bet
//        self.respository = respository

        checkButtonState()
        isNotificationInFuture()
        print(isAlertSet.description)
    }

    func deleteBet(bet: BetModel) {
        BetDao.deleteBet(bet: bet)
    }
    
    func isNotificationInFuture() {
        if let notificationID = bet.betNotificationID, !notificationID.isEmpty {
            UserNotificationsService().isNotificationDateInFuture(notificationId: notificationID) { isInFuture in
                DispatchQueue.main.async {
                    self.isAlertSet = isInFuture
                }
                print("it is")
            }
        }
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
