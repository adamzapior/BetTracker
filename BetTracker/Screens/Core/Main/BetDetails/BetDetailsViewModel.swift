import Foundation
import LifetimeTracker

class BetDetailsViewModel: ObservableObject {
    @Injected(\.repository) var repository
    @Injected(\.userDefaults) var userDefaults

    let bet: BetModel
    var defaultCurrency: Currency = .usd
    var buttonState: BetStatus = .uncleared
    var isAlertSet: Bool = false

    init(bet: BetModel) {
        self.bet = bet
        setupViewModel()

        #if DEBUG
        trackLifetime()
        #endif
    }

    // MARK: -  Public

    /// Updates the bet result in the repository.
    /// - Parameter result: New bet result (.won or .lost).
    /// Changes bet status, updates profit, and removes notification if exists.
    func setBetTo(_ result: BetResult) {
        if bet.isWon == nil {
            deleteBetNotification()
        }

        switch result {
        case .won:
            let newScore = (bet.profit).subtracting(bet.amount)
            repository.markBetStatus(model: bet, isWon: true, tableName: TableName.bet.rawValue)
            repository.updateProfit(model: bet, score: newScore, tableName: TableName.bet.rawValue)

        case .lost:
            let newScore = (bet.amount).multiplying(by: -1)
            repository.markBetStatus(model: bet, isWon: false, tableName: TableName.bet.rawValue)
            repository.updateProfit(model: bet, score: newScore, tableName: TableName.bet.rawValue)
        }
    }

    func deleteBet() {
        repository.deleteBet(model: bet)
    }

    func deleteBetNotification() {
        UserNotificationsService().removeNotification(notificationId: bet.betNotificationID ?? "")
    }

    // MARK: -  Private

    private func setupViewModel() {
        loadDefaultCurrency()
        setButtonType()
        checkIsAlertExsist()
    }

    // View model setup methods
    private func loadDefaultCurrency() {
        defaultCurrency = Currency(rawValue: userDefaults.getValue(for: .defaultCurrency)) ?? .usd
    }

    private func setButtonType() {
        switch bet.isWon {
        case nil:
            buttonState = .uncleared
        case true?:
            buttonState = .won
        case false?:
            buttonState = .lost
        }
    }

    private func checkIsAlertExsist() {
        if let notificationID = bet.betNotificationID, !notificationID.isEmpty {
            UserNotificationsService()
                .isNotificationDateInFuture(notificationId: notificationID) { isInFuture in
                    DispatchQueue.main.async { [unowned self] in
                        self.isAlertSet = isInFuture
                    }
                }
        }
    }
}

enum BetStatus {
    case uncleared
    case won
    case lost
}

enum BetResult {
    case won
    case lost
}

extension BetDetailsViewModel: LifetimeTrackable {
    class var lifetimeConfiguration: LifetimeConfiguration {
        return LifetimeConfiguration(maxCount: 1, groupName: "ViewModels")
    }
}
