import Foundation

class BetDetailsVM: ObservableObject {
    
    @Published
    var isShowingAlert = false
    
    var currency = UserDefaultsManager.defaultCurrencyValue

    
    func deleteBet(bet: BetModel) {
        BetDao.deleteBet(bet: bet)
    }
}
