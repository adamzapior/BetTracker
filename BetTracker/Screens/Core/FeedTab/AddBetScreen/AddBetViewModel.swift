import Combine
import Foundation
import LifetimeTracker
import SwiftUI

final class AddBetViewModel: ObservableObject {
    @Injected(\.repository) var repository
    @Injected(\.userDefaults) var userDefaults

    @Published var betType: BetType = .singlebet

    // MARK: - SINGLE BET

    @Published var selectedTeam = SelectedTeam.team1
    @Published var team1: String = "" { didSet { team1IsError = false } }
    @Published var team2: String = "" { didSet { team2IsError = false } }
    @Published var amount: String = "" { didSet { amountIsError = false } }
    @Published var odds: String = "" { didSet { oddsIsError = false } }
    @Published var tax = "" { didSet { taxIsError = false } }
//    @Published var league: String = "" { didSet { team1IsError = false } }

    // MARK: - BETSLIP

    @Published var betslipName = "" { didSet { betslipNameIsError = false } }
    @Published var betslipAmount = "" { didSet { betslipAmountIsError = false } }
    @Published var betslipOdds = "" { didSet { betslipOddsIsError = false } }
    @Published var betslipTax = "" { didSet { betslipTaxIsError = false } }

    // MARK: - MERGED varbiables for bets

    @Published var selectedCategory = Category.football
    @Published var note: String = ""

    @Published var selectedDate = Date.now
    @Published var selectedNotificationDate = Date.now
    var betNotificationID = UUID().uuidString // DB always save ID, but it's used to save notification if reminderState =/= .saved

    @Published var defaultCurrency: Currency = .eur
    @Published var profit: NSDecimalNumber = 0
    @Published var score: NSDecimalNumber = .zero

    // MARK: - Error handling

    @Published var team1IsError = false
    @Published var team2IsError = false
    @Published var betslipNameIsError = false
    @Published var amountIsError = false
    @Published var betslipAmountIsError = false
    @Published var oddsIsError = false
    @Published var betslipOddsIsError = false
    @Published var taxIsError = false
    @Published var betslipTaxIsError = false
    @Published var notificationIsError = false
    @Published var validationErrors: [BetsValidationErrors] = []

    // MARK: - Picker properties

    var categories = Category.allCases
    var betResultCases = SelectedTeam.allCases

    var reminderDateClosedRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .minute, value: 1, to: Date())!
        let max = Calendar.current.date(byAdding: .year, value: 1, to: Date())!
        return min ... max
    }

    // MARK: - View states

    var taxFieldState = TaxFieldVisibility.hidden
    var reminderPickerState: ReminderPickerVisibility = .closed

    init() {
        configureTaxInput()
        loadDefaultCurrency()
        setupProfitCalculation()

        #if DEBUG
        trackLifetime()
        #endif
    }

    func addReminder() {
        reminderPickerState = .active
    }

    func deleteReminder() {
        reminderPickerState = .closed
        selectedNotificationDate = Date()
    }

    func filterInput(input: String, oldValue: String, filterType: BetsTextfieldsFilterType) -> String {
        if input.isEmpty {
            return input
        }
        var cleanedInput = input
            .replacingOccurrences(of: ",", with: ".")

        switch filterType {
        case .amount, .odds:
            if cleanedInput
                .wholeMatch(of: /[1-9][0-9]{0,6}?((\.|,)[0-9]{,2})?/) ==
                nil
            {
                cleanedInput = oldValue
            }
        case .tax:
            if input.first == "0" {
                return "0"
            }
            if cleanedInput
                .wholeMatch(of: /[0-9][0-9]{0,1}?((\.|,)[0-9]{,2})?/) ==
                nil
            {
                cleanedInput = oldValue
            }
        case .name:
            if input.first == " " {
                return ""
            }
            let regex = try? NSRegularExpression(pattern: "[ ]+", options: .caseInsensitive)
            cleanedInput = regex?.stringByReplacingMatches(
                in: cleanedInput,
                options: [],
                range: NSRange(
                    location: 0,
                    length: cleanedInput.count
                ),
                withTemplate: " "
            ) ?? cleanedInput

            if cleanedInput.wholeMatch(of: /^[\p{L}0-9 ]{1,24}$/) == nil {
                cleanedInput = oldValue
            }
        }

        return cleanedInput
    }

    // MARK: - Save bet/betslip to DB

    func saveBet() -> Bool {
        guard validateInputs() else { return false }

        let bet = createBetModel()
        if reminderPickerState == .active {
            saveSelectedReminder(betType: .singlebet)
        }
        repository.saveBet(model: bet)

        return true
    }

    func saveBetslip() -> Bool {
        guard validateBetslipInputs() else { return false }

        let betslip = createBetslipModel()
        if reminderPickerState == .active {
            saveSelectedReminder(betType: .betslip)
        }
        repository.saveBet(model: betslip)

        return true
    }

    // ** Methods used to run inside .onApper and .onDissapear view methods **

    func saveTextInTextfield() {
        userDefaults.setValue(team1, for: .team1)
        userDefaults.setValue(team2, for: .team2)
        userDefaults.setValue(amount, for: .amount)
        userDefaults.setValue(odds, for: .odds)

        userDefaults.setValue(betslipName, for: .betslipName)
        userDefaults.setValue(betslipAmount, for: .betslipAmount)
        userDefaults.setValue(betslipOdds, for: .betslipOdds)
    }

    func loadTextInTextfield() {
        team1 = userDefaults.getValue(for: .team1)
        team2 = userDefaults.getValue(for: .team2)
        amount = userDefaults.getValue(for: .amount)
        odds = userDefaults.getValue(for: .odds)
        tax = userDefaults.getValue(for: .defaultTax) // load default Tax to field
        betslipName = userDefaults.getValue(for: .betslipName)
        betslipAmount = userDefaults.getValue(for: .betslipAmount)
        betslipOdds = userDefaults.getValue(for: .betslipOdds)
    }

    // MARK: - Calculate methods

    private func setupProfitCalculation() {
        let profitPublisher = Publishers.CombineLatest4($betType, $amount, $odds, $tax)
            .map { [weak self] betType, amount, odds, tax in
                guard let self = self else { return NSDecimalNumber.zero }
                switch betType {
                case .singlebet:
                    return self.calculateProfit(amount: amount, odds: odds, tax: tax)
                case .betslip:
                    return self.calculateProfit(amount: self.betslipAmount, odds: self.betslipOdds, tax: tax)
                }
            }

        profitPublisher
            .assign(to: &$profit)
    }

    private func calculateProfit(amount: String, odds: String, tax: String) -> NSDecimalNumber {
        guard let amount = Decimal(string: amount),
              let odds = Decimal(string: odds)
        else {
            return NSDecimalNumber.zero
        }

        let predictedWin = NSDecimalNumber(decimal: amount * odds)

        if taxFieldState == .visible, let tax = Decimal(string: tax) {
            let taxCorrected = NSDecimalNumber(decimal: 1.0 - tax / 100)
            return predictedWin.multiplying(by: taxCorrected)
        } else {
            return predictedWin
        }
    }

    // MARK: -  METHODS FOR ADD BET VIEWMODEL VARIABLES:

    /**
     The function saves the user's notification if the date is different from ' Date.now '
     - Parameter withID: Uniqe ID based on UUID.string variable
     - Parameter titleName: Name used for Reminder Title
     - Parameter notificationTriggerDate:Selected date to trigger notification
     */

    private func saveSelectedReminder(betType: BetType) {
        let titleName: String
        let notificationService = UserNotificationsService()
        switch betType {
        case .singlebet:
            titleName = selectedTeam == .team1 ? team1 : team2
        case .betslip:
            titleName = betslipName
        }

        notificationService.scheduleNotification(
            withID: betNotificationID,
            titleName: titleName,
            notificationTriggerDate: selectedNotificationDate
        )
    }

    // MARK: - Validate & Error handling methods

    private func validateInputs() -> Bool {
        validationErrors.removeAll()

        validateTeam1()
        validateTeam2()
        validateAmount()
        validateOdds()
        validateTax()
        validateNotification()

        return validationErrors.isEmpty
    }

    private func validateBetslipInputs() -> Bool {
        validationErrors.removeAll()

        validateBetslipName()
        validateBetslipAmount()
        validateBetslipOdds()
        validateBetslipTax()
        validateNotification()

        return validationErrors.isEmpty
    }

    // MARK: - Validation methods

    private func validateTeam1() {
        if team1.isEmpty || team1.wholeMatch(of: /\s+/) != nil || team1.count < 3 {
            validationErrors.append(.team1)
            team1IsError = true
        }
    }

    private func validateTeam2() {
        if team2.isEmpty || team2.wholeMatch(of: /\s+/) != nil || team2.count < 3 {
            validationErrors.append(.team2)
            team2IsError = true
        }
    }

    private func validateBetslipName() {
        if betslipName.isEmpty || betslipName.wholeMatch(of: /\s+/) != nil || betslipName.count < 3 {
            validationErrors.append(.name)
            betslipNameIsError = true
        }
    }

    private func validateAmount() {
        if amount.isEmpty {
            validationErrors.append(.amount)
            amountIsError = true
        }
    }

    private func validateBetslipAmount() {
        if betslipAmount.isEmpty {
            validationErrors.append(.amount)
            betslipAmountIsError = true
        }
    }

    private func validateOdds() {
        if odds.isEmpty {
            validationErrors.append(.odds)
            oddsIsError = true
        }
    }

    private func validateBetslipOdds() {
        if betslipOdds.isEmpty {
            validationErrors.append(.odds)
            betslipOddsIsError = true
        }
    }

    private func validateTax() {
        if taxFieldState == .visible && tax.isEmpty {
            validationErrors.append(.tax)
            taxIsError = true
        }
    }

    private func validateBetslipTax() {
        if taxFieldState == .visible && tax.isEmpty {
            validationErrors.append(.tax)
            betslipTaxIsError = true
        }
    }

    private func validateNotification() {
        if selectedNotificationDate <= Date() && reminderPickerState == .active {
            validationErrors.append(.notification)
            notificationIsError = true
        }
    }

    // MARK: - Set up ViewModel

    private func configureTaxInput() {
        let isTaxFieldActive = userDefaults.getValue(for: .isDefaultTaxOn)

        switch isTaxFieldActive {
        case true:
            taxFieldState = .visible
        case false:
            taxFieldState = .hidden
        }
    }

    private func loadDefaultCurrency() {
        defaultCurrency = Currency(rawValue: userDefaults.getValue(for: .defaultCurrency)) ?? .eur
    }
}

// MARK: - Helper methods

extension AddBetViewModel {
    private func createBetModel() -> BetModel {
        BetModel(
            id: nil,
            date: selectedDate,
            team1: team1,
            team2: team2,
            selectedTeam: selectedTeam,
            league: "", // Add league property if needed
            amount: NSDecimalNumber(string: amount),
            odds: NSDecimalNumber(string: odds),
            category: selectedCategory,
            tax: NSDecimalNumber(string: taxFieldState == .visible ? tax : "0"),
            profit: profit,
            note: note,
            isWon: nil,
            betNotificationID: betNotificationID,
            score: score
        )
    }

    private func createBetslipModel() -> BetslipModel {
        BetslipModel(
            id: nil,
            date: selectedDate,
            name: betslipName,
            amount: NSDecimalNumber(string: betslipAmount),
            odds: NSDecimalNumber(string: betslipOdds),
            category: selectedCategory,
            tax: NSDecimalNumber(string: taxFieldState == .visible ? tax : "0"),
            profit: profit,
            note: note,
            isWon: nil,
            betNotificationID: betNotificationID,
            score: score
        )
    }
}

enum ReminderPickerVisibility {
    case closed
    case active
}

enum TaxFieldVisibility {
    case visible
    case hidden
}

enum BetsTextfieldsFilterType: CaseIterable {
    case amount
    case odds
    case tax
    case name
}

enum BetsValidationErrors: CustomStringConvertible {
    case team1
    case team2
    case name
    case amount
    case odds
    case tax
    case notification

    var description: String {
        switch self {
        case .team1:
            return "Team 1 error: you need to enter three characters."
        case .team2:
            return "Team 2 error: you need to enter three characters."
        case .name:
            return "Name error: you need to enter three characters."
        case .amount:
            return "Amount error: the amount input can't be empty."
        case .odds:
            return "Odds error: the odds input can't be empty."
        case .tax:
            return "Tax error: the tax input can't be empty."
        case .notification:
            return "Reminder error: the reminder date must be in the future."
        }
    }
}

enum BetType: String, CaseIterable, Identifiable {
    var id: String { rawValue }

    case singlebet = "Single Bet"
    case betslip
}

extension AddBetViewModel: LifetimeTrackable {
    class var lifetimeConfiguration: LifetimeConfiguration {
        return LifetimeConfiguration(maxCount: 1, groupName: "ViewModels")
    }
}
