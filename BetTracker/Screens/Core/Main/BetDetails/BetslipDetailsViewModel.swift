import Foundation
import LifetimeTracker

class BetslipDetailsViewModel: ObservableObject, BetsDetailsViewModelsProtocol {
    @Injected(\.repository) var repository
    @Injected(\.userDefaults) var userDefaults

    let betslip: BetslipModel
    var defaultCurrency: Currency = .usd
    var buttonState: BetStatus = .uncleared
    var isAlertSet: Bool = false

    init(betslip: BetslipModel) {
        self.betslip = betslip
        setupViewModel()

        #if DEBUG
        trackLifetime()
        #endif
    }

    // MARK: -  Public

    /// Updates the betslip result in the repository.
    /// - Parameter result: New bet result (.won or .lost).
    /// Changes bet status, updates profit, and removes notification if exists.
    func setBetslipTo(_ result: BetResult) {
        if betslip.isWon == nil {
            deleteBetNotification()
        }

        switch result {
        case .won:
            let newScore = (betslip.profit).subtracting(betslip.amount)
            repository.markBetStatus(model: betslip, isWon: true, tableName: TableName.betslip.rawValue)
            repository.updateProfit(model: betslip, score: newScore, tableName: TableName.betslip.rawValue)

        case .lost:
            let newScore = (betslip.amount).multiplying(by: -1)
            repository.markBetStatus(model: betslip, isWon: false, tableName: TableName.betslip.rawValue)
            repository.updateProfit(model: betslip, score: newScore, tableName: TableName.betslip.rawValue)
        }
    }

    func deleteBet() {
        repository.deleteBet(model: betslip)
    }

    // Delete notification
    func deleteBetNotification() {
        UserNotificationsService().removeNotification(notificationId: betslip.betNotificationID ?? "")
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
        switch betslip.isWon {
        case nil:
            buttonState = .uncleared
        case true?:
            buttonState = .won
        case false?:
            buttonState = .lost
        }
    }

    private func checkIsAlertExsist() {
        if let notificationID = betslip.betNotificationID, !notificationID.isEmpty {
            UserNotificationsService()
                .isNotificationDateInFuture(notificationId: notificationID) { isInFuture in
                    DispatchQueue.main.async { [unowned self] in
                        self.isAlertSet = isInFuture
                    }
                }
        }
    }
}

extension BetslipDetailsViewModel: LifetimeTrackable {
    class var lifetimeConfiguration: LifetimeConfiguration {
        return LifetimeConfiguration(maxCount: 1, groupName: "ViewModels")
    }
}
