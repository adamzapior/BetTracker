import Combine
import Foundation
import SwiftUI
import LifetimeTracker

final class AddBetVM: ObservableObject {
    
    @Injected(\.repository) var repository

    let defaults = UserDefaultsManager.path

    var isDefaultTaxSet: Bool

    var reminderDateClosedRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .minute, value: 1, to: Date())!
        let max = Calendar.current.date(byAdding: .year, value: 1, to: Date())!
        return min ... max
    }

    @Published
    var betType: BetType = .singlebet

    // MARK: - SINGLE BET

    @Published
    var selectedTeam = SelectedTeam.team1

    @Published
    var team1: String = "" {
        didSet {
            if team1 != oldValue {
                team1IsError = false
                let cleanedName = filterInput(
                    input: team1,
                    oldValue: oldValue,
                    filterType: .name
                )
                if cleanedName != team1 {
                    team1 = cleanedName
                }
            }
        }
    }

    @Published
    var team2: String = "" {
        didSet {
            team2IsError = false
            let cleanedName = filterInput(
                input: team2,
                oldValue: oldValue,
                filterType: .name
            )
            if cleanedName != team2 {
                team2 = cleanedName
            }
        }
    }

    @Published
    var amount: String = "" {
        didSet {
            updateProfit()
            amountIsError = false
            let cleanedAmount = filterInput(
                input: amount,
                oldValue: oldValue,
                filterType: .amount
            )
            if cleanedAmount != amount {
                amount = cleanedAmount
            }
        }
    }

    @Published
    var odds: String = "" {
        didSet {
            updateProfit()
            oddsIsError = false
            let cleanedOdds = filterInput(
                input: odds,
                oldValue: oldValue,
                filterType: .tax
            )
            if cleanedOdds != odds {
                odds = cleanedOdds
            }
        }
    }

    @Published
    var tax = "" {
        didSet {
            updateProfit()
            taxIsError = false
            let cleanedTax = filterInput(
                input: tax,
                oldValue: oldValue,
                filterType: .tax
            )
            if cleanedTax != tax {
                tax = cleanedTax
            }
        }
    }

    @Published
    var league: String = String()

    @Published
    var selectedCategory = Category.football

    /// AddBet non-edit Row's variables:
    @Published
    var defaultCurrency: Currency = Currency.eur

    @Published
    var profit: NSDecimalNumber = 0

    @Published
    var score: NSDecimalNumber = .zero

    // MARK: - BETSLIP

    @Published
    var betslipName = "" {
        didSet {
            betslipNameIsError = false
            let cleanedName = filterInput(
                input: betslipName,
                oldValue: oldValue,
                filterType: .name
            )
            if cleanedName != betslipName {
                betslipName = cleanedName
            }
        }
    }

    @Published
    var betslipAmount = "" {
        didSet {
            updateProfit()
            betslipAmountIsError = false
            let cleanedAmount = filterInput(
                input: betslipAmount,
                oldValue: oldValue,
                filterType: .amount
            )
            if cleanedAmount != betslipAmount {
                betslipAmount = cleanedAmount
            }
        }
    }

    @Published
    var betslipOdds = "" {
        didSet {
            updateProfit()
            betslipOddsIsError = false
            let cleanedOdds = filterInput(
                input: betslipOdds,
                oldValue: oldValue,
                filterType: .amount
            )
            if cleanedOdds != betslipOdds {
                betslipOdds = cleanedOdds
            }
        }
    }

    @Published
    var validationErrors: [ValidateError] = []

    // MARK: - MERGED varbiables for bets

    // ReminderRowState methods:

    @Published
    var selectedDate = Date()

    @Published
    var showDatePicker: Bool = false

    // MARK: Reminders

    // ReminderRowState methods:

    @Published
    var selectedNotificationDate = Date.now

    @Published
    var betNotificationID = UUID()
        .uuidString
    // DB always save ID, but it's used to save notification if reminderState =/= .saved

    @Published
    var isReminderSaved: Bool = false

    @Published
    var dateState: DateRowState = .closed

    @Published
    var reminderState: ReminderRowState = .add

    // MARK: Tax State

    /// #1 Current Row State && taxStatus var
    @Published
    var taxRowStateValue = taxRowState.disable

    /// #2 Variable to observe changes in taxStatus Variable (base
    @Published
    var isTaxInputOn: Bool = false {
        didSet {
            if isTaxInputOn {
                taxRowStateValue = .active
            } else {
                taxRowStateValue = .disable
            }
        }
    }

    // MARK: Note

    @Published
    var noteState: NoteState = .closed

    @Published
    var note: String = ""

    // MARK: - Error handling

    @Published
    var team1IsError = false
    @Published
    var team2IsError = false
    @Published
    var betslipNameIsError = false
    @Published
    var amountIsError = false
    @Published
    var betslipAmountIsError = false
    @Published
    var oddsIsError = false
    @Published
    var betslipOddsIsError = false
    @Published
    var taxIsError = false
    @Published
    var notificationIsError = false

    init() {
        isDefaultTaxSet = defaults.get(.isDefaultTaxOn)
        configureTaxInput()
        loadDefaultCurrency()
        
#if DEBUG
trackLifetime()
#endif
    }

    // MARK: - State Navigation

    /// Bet type
    func switchBetTypeToBetSlip() {
        betType = .betslip
    }

    func switchBetTypeToSolobet() {
        betType = .singlebet
    }

    /// Selected checkmark team logic:
    func onTeam1Selected() {
        selectedTeam = .team1
    }

    func onTeam2Selected() {
        selectedTeam = .team2
    }

    // EVENT DATE

    func openDate() {
        dateState = .opened
    }

    func closeDate() {
        dateState = .closed
    }

    func addReminder() {
        reminderState = .editing
    }

    func deleteReminder() {
        reminderState = .add
        selectedNotificationDate = Date()
        isReminderSaved = false
    }

    func saveReminder() {
        reminderState = .saved
        isReminderSaved = true
    }

    // Note methods

    func openNote() {
        noteState = .opened
    }

    func closeNote() {
        noteState = .closed
    }

    // MARK: - Save bet/betslip to DB

    func saveBet() -> Bool {
        validationErrors = []
        resetValidationFlags()

        validateTeam1()
        validateTeam2()
        validateAmount()
        validateOdds()
        validateTax()
        validateNotification()

        if team1IsError {
            validationErrors.append(.team1)
        }

        if team2IsError {
            validationErrors.append(.team2)
        }

        if amountIsError {
            validationErrors.append(.amount)
        }
        if oddsIsError {
            validationErrors.append(.odds)
        }
        if taxIsError {
            validationErrors.append(.tax)
        }

        if notificationIsError {
            validationErrors.append(.notification)
        }

        if !validationErrors.isEmpty {
            return false
        }

        var newTax = tax

        if !isDefaultTaxSet {
            newTax = NSDecimalNumber.zero.stringValue
        }

        if reminderState == .saved {
            let bet = BetModel(
                id: nil,
                date: selectedDate,
                team1: team1,
                team2: team2,
                selectedTeam: selectedTeam,
                league: league,
                amount: NSDecimalNumber(string: amount),
                odds: NSDecimalNumber(string: odds),
                category: selectedCategory,
                tax: NSDecimalNumber(string: newTax),
                profit: profit,
                note: note,
                isWon: nil,
                betNotificationID: betNotificationID,
                score: score
            )
            saveSelectedReminder(betType: .singlebet)
            repository.saveBet(model: bet)
        } else {
            let bet = BetModel(
                id: nil,
                date: selectedDate,
                team1: team1,
                team2: team2,
                selectedTeam: selectedTeam,
                league: league,
                amount: NSDecimalNumber(string: amount),
                odds: NSDecimalNumber(string: odds),
                category: selectedCategory,
                tax: NSDecimalNumber(string: newTax),
                profit: profit,
                note: note,
                isWon: nil,
                betNotificationID: betNotificationID,
                score: score
            )
            repository.saveBet(model: bet)
        }

        return true
    }

    func saveBetslip() -> Bool {
        validationErrors = []
        resetValidationFlags()

        validateBetslipName()
        validateBetslipAmount()
        validateBetslipOdds()
        validateTax()
        validateNotification()

        if betslipNameIsError {
            validationErrors.append(.name)
        }

        if betslipAmountIsError {
            validationErrors.append(.amount)
        }

        if betslipOddsIsError {
            validationErrors.append(.odds)
        }
        if taxIsError {
            validationErrors.append(.tax)
        }

        if notificationIsError {
            validationErrors.append(.notification)
        }

        if !validationErrors.isEmpty {
            return false
        }

        var newTax = tax

        if !isDefaultTaxSet {
            newTax = NSDecimalNumber.zero.stringValue
        }

        if reminderState == .saved {
            let betslip = BetslipModel(
                id: nil,
                date: selectedDate,
                name: betslipName,
                amount: NSDecimalNumber(string: betslipAmount),
                odds: NSDecimalNumber(string: betslipOdds),
                category: selectedCategory,
                tax: NSDecimalNumber(string: newTax),
                profit: profit,
                note: note,
                isWon: nil,
                betNotificationID: betNotificationID,
                score: score
            )
            saveSelectedReminder(betType: .betslip)
            repository.saveBet(model: betslip)
        } else {
            let betslip = BetslipModel(
                id: nil,
                date: selectedDate,
                name: betslipName,
                amount: NSDecimalNumber(string: betslipAmount),
                odds: NSDecimalNumber(string: betslipOdds),
                category: selectedCategory,
                tax: NSDecimalNumber(string: newTax),
                profit: profit,
                note: note,
                isWon: nil,
                betNotificationID: betNotificationID,
                score: score
            )
            repository.saveBet(model: betslip)
        }

        return true
    }

    // ** Methods used to run inside .onApper and .onDissapear view methods **

    func saveTextInTexfield() {
        defaults.set(.team1, to: team1)
        defaults.set(.team2, to: team2)
        defaults.set(.amount, to: amount)
        defaults.set(.odds, to: odds)

        defaults.set(.betslipName, to: betslipName)
        defaults.set(.betslipAmount, to: betslipAmount)
        defaults.set(.betslipOdds, to: betslipOdds)
    }

    func loadTextInTextfield() {
        team1 = defaults.get(.team1)
        team2 = defaults.get(.team2)
        amount = defaults.get(.amount)
        odds = defaults.get(.odds)

        tax = defaults.get(.defaultTax) // load default Tax to field

        betslipName = defaults.get(.betslipName)
        betslipAmount = defaults.get(.betslipAmount)
        betslipOdds = defaults.get(.betslipOdds)
    }

    func clearTextField() {
        team1 = ""
        team2 = ""
        amount = ""
        odds = ""
        tax = ""
        betslipName = ""
        betslipAmount = ""
        betslipOdds = ""
    }

    // MARK: - Calculate methods

    // Predicted win methods:
    // Methods used to calculate data with Combine in Init

    private func betProfitWithoutTex(
        amountString: String?,
        oddsString: String?
    ) -> Decimal? {
        guard let amountString, !amountString.isEmpty,
              let oddsString, !oddsString.isEmpty
        else {
            return nil
        }

        let amount = Decimal(string: amountString) ?? Decimal()
        let odds = Decimal(string: oddsString) ?? Decimal()

        let predictedWin = amount * odds
        return predictedWin
    }

    private func betProfitWithTax(
        amountString: String?,
        oddsString: String?,
        taxString: String?
    ) -> Decimal? {
        guard let amountString, !amountString.isEmpty,
              let amount = Decimal(string: amountString),
              let oddsString, !oddsString.isEmpty,
              let odds = Decimal(string: oddsString),
              let taxString, !taxString.isEmpty,
              let tax = Decimal(string: taxString)
        else {
            return nil
        }

        let taxCorrected = 1.0 - tax / 100

        let predictedWin = amount * odds * taxCorrected

        return predictedWin
    }

    private func updateProfit() {
        switch betType {
        case .singlebet:
            if isDefaultTaxSet {
                Publishers.CombineLatest3($amount, $odds, $tax)
                    .map { [weak self] amount, odds, tax in
                        guard let self else {
                            return 0
                        }
                        let profit = self.betProfitWithTax(
                            amountString: amount,
                            oddsString: odds,
                            taxString: tax
                        ) ?? Decimal()
                        return profit as NSDecimalNumber
                    }
                    .assign(to: &$profit)
            } else {
                Publishers.CombineLatest($amount, $odds)
                    .map { [weak self] amount, odds in
                        guard let self else {
                            return 0
                        }
                        let profit = self.betProfitWithoutTex(
                            amountString: amount,
                            oddsString: odds
                        ) ?? Decimal()
                        return profit as NSDecimalNumber
                    }
                    .assign(to: &$profit)
            }
        case .betslip:
            if isDefaultTaxSet {
                Publishers.CombineLatest3($betslipAmount, $betslipOdds, $tax)
                    .map { [weak self] betslipAmount, betslipOdds, betslipTax in
                        guard let self else {
                            return 0
                        }
                        let profit = self.betProfitWithTax(
                            amountString: betslipAmount,
                            oddsString: betslipOdds,
                            taxString: betslipTax
                        ) ?? Decimal()
                        return profit as NSDecimalNumber
                    }
                    .assign(to: &$profit)
            } else {
                Publishers.CombineLatest($betslipAmount, $betslipOdds)
                    .map { [weak self] betslipAmount, betslipOdds in
                        guard let self else {
                            return 0
                        }
                        let profit = self.betProfitWithoutTex(
                            amountString: betslipAmount,
                            oddsString: betslipOdds
                        ) ?? Decimal()
                        return profit as NSDecimalNumber
                    }
                    .assign(to: &$profit)
            }
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
        switch betType {
        case .singlebet:
            if selectedTeam == .team1 {
                UserNotificationsService().scheduleNotification(
                    withID: betNotificationID,
                    titleName: "\(team1)",
                    notificationTriggerDate: selectedNotificationDate
                )

            } else if selectedTeam == .team2 {
                UserNotificationsService().scheduleNotification(
                    withID: betNotificationID,
                    titleName: "\(team2)",
                    notificationTriggerDate: selectedNotificationDate
                )
            }
        case .betslip:
            UserNotificationsService().scheduleNotification(
                withID: betNotificationID,
                titleName: "\(betslipName)",
                notificationTriggerDate: selectedNotificationDate
            )
        }
    }

    // MARK: - Validate & Error handling methods

    private func filterInput(
        input: String,
        oldValue: String,
        filterType: filterType
    ) -> String {
        if input.isEmpty {
            return input
        }
        var cleanedInput = input
            .replacingOccurrences(of: ",", with: ".")

        switch filterType {
        case .amount:
            if cleanedInput
                .wholeMatch(of: /[1-9][0-9]{0,6}?((\.|,)[0-9]{,2})?/) ==
                nil {
                cleanedInput = oldValue
            }
        case .tax:
            if input.first == "0" {
                return "0"
            }
            if cleanedInput
                .wholeMatch(of: /[0-9][0-9]{0,3}?((\.|,)[0-9]{,2})?/) ==
                nil {
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

    private func validateTeam1() {
        if team1.isEmpty {
            team1IsError = true
        } else if team1.wholeMatch(of: /\s+/) != nil {
            team1IsError = true
        } else if team1.count < 3 {
            team1IsError = true
        }
    }

    private func validateTeam2() {
        if team2.isEmpty {
            team2IsError = true
        } else if team2.wholeMatch(of: /\s+/) != nil {
            team2IsError = true
        } else if team2.count < 3 {
            team2IsError = true
        }
    }

    private func validateBetslipName() {
        if betslipName.isEmpty {
            betslipNameIsError = true
        } else if betslipName.wholeMatch(of: /\s+/) != nil {
            betslipNameIsError = true
        } else if betslipName.count < 3 {
            betslipNameIsError = true
        }
    }

    private func validateAmount() {
        if amount.isEmpty {
            amountIsError = true
        }
    }

    private func validateBetslipAmount() {
        if betslipAmount.isEmpty {
            betslipAmountIsError = true
        }
    }

    private func validateOdds() {
        if odds.isEmpty {
            oddsIsError = true
        }
    }

    private func validateBetslipOdds() {
        if betslipOdds.isEmpty {
            betslipOddsIsError = true
        }
    }

    private func validateTax() {
        if isDefaultTaxSet {
            if tax.isEmpty {
                taxIsError = true
            }
        }
    }

    private func validateNotification() {
        if selectedNotificationDate <= Date(), isReminderSaved == true {
            notificationIsError = true
        }
    }

    private func resetValidationFlags() {
        team1IsError = false
        team2IsError = false
        betslipNameIsError = false
        amountIsError = false
        betslipAmountIsError = false
        oddsIsError = false
        betslipOddsIsError = false
        taxIsError = false
        notificationIsError = false
    }

    /// TAX STATE: Read taxStatus from init, func run in init and set value of isTaxInputDisabled
    /// depend on taxStatus Value
    /// taxStatus is boolean value of default tax user settings.
    ///     1. taxStatus = true - the user has a default tax value set
    ///     2. taxStatus = false - user has no default tax value set
    private func configureTaxInput() {
        if isDefaultTaxSet {
            isTaxInputOn = true
        } else {
            isTaxInputOn = false
        }
    }

    private func loadDefaultCurrency() {
        defaultCurrency = Currency(rawValue: defaults.get(.defaultCurrency)) ?? .eur
    }

    enum DateRowState {
        case closed
        case opened
    }

    enum ReminderRowState {
        case add
        case editing
        case saved
    }

    enum taxRowState {
        case active
        case disable
    }

    enum NoteState {
        case closed
        case opened
    }

    enum filterType: CaseIterable {
        case amount
        case tax
        case name
    }

    enum ValidateError: CustomStringConvertible {
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

}

enum BetType: String, CaseIterable, Identifiable {
    var id: String { rawValue }

    case singlebet = "Single Bet"
    case betslip
}

extension AddBetVM: LifetimeTrackable {
    class var lifetimeConfiguration: LifetimeConfiguration {
        return LifetimeConfiguration(maxCount: 1, groupName: "ViewModels")
    }
}
