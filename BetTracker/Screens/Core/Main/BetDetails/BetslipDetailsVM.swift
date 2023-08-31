import Foundation

class BetslipDetailsVM: ObservableObject {

    let bet: BetslipModel
    let defaults = UserDefaultsManager.path

    var defaultCurrency: Currency = .usd

    enum BetButtonState {
        case uncleared
        case won
        case lost
    }

    var buttonState: BetButtonState = .uncleared

    @Published
    var isShowingAlert = false

    init(bet: BetslipModel) {
        self.bet = bet

        setup()
    }

    // MARK: -  VM setup methods:

    private func setup() {
//        checkButtonState()
//        isNotificationInFuture()
        loadDefaultCurrency()
    }

    private func loadDefaultCurrency() {
        defaultCurrency = Currency(rawValue: defaults.get(.defaultCurrency)) ?? .usd
    }

    // MARK: -  Bet edit/delete methods:

    // TODO: !!!!

}
