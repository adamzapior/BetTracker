import Foundation

class BetDetailsVM: ObservableObject {
    
    enum BetButtonState {
        case uncleared
        case won
        case lost
    }
    
    
    let bet: BetModel
    
    init(bet: BetModel) {
        self.bet = bet
        
        checkButtonState()
    }
    
    var buttonState: BetButtonState = .uncleared
    
    @Published
    var isShowingAlert = false
    
    var currency = UserDefaultsManager.defaultCurrencyValue

    
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
