import Combine
import Foundation
import SwiftUI

final class AddBetVM: ObservableObject {

    let defaults = UserDefaultsManager.path
    let respository = Respository()

    var isDefaultTaxSet: Bool

    @Published
    var isReminderSaved: Bool = false

    var savedDate: Date //    TODO: !!!!! delete???

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
                let cleanedName = filterDecimalInput(
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
            let cleanedName = filterDecimalInput(
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
            let cleanedAmount = filterDecimalInput(
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
            let cleanedOdds = filterDecimalInput(
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
            let cleanedTax = filterDecimalInput(
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
    var defaultCurrency: Currency = Currency.usd // Used for overlay text at Textfield

    @Published
    var profit: NSDecimalNumber = 0

    @Published
    var score: NSDecimalNumber = .zero

    // MARK: - BETSLIP

    @Published
    var betslipName = "" {
        didSet {
            betslipNameIsError = false
            let cleanedName = filterDecimalInput(
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
            let cleanedAmount = filterDecimalInput(
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
            let cleanedOdds = filterDecimalInput(
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
    var betNotificationID = UUID().uuidString

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

    /// ** Define variables **
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
        savedDate = defaults.get(.savedNotificationDate) // delete?
        isReminderSaved = defaults.get(.isNotificationSaved) // delete?

        isDefaultTaxSet = defaults.get(.isDefaultTaxOn)
        configureTaxInput()
        loadDefaultCurrency()
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

    /// TAX STATE:
    /// Read taxStatus from init
    /// Func run in init and set value of isTaxInputDisabled depend on taxStatus Value
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
        reminderState = .delete
        isReminderSaved = true
    }

    // Note methods

    func openNote() {
        noteState = .opened
    }

    func closeNote() {
        noteState = .closed
    }

    // MARK: - Calculate methods

    // Predicted win methods:
    // Methods used to calculate data with Combine in Init

    /// TODO: FIX THIS SHIT
    private func betProfitWithoutTex(
        amountString: String?,
        oddsString: String?
    ) -> Decimal? {
        guard let amountString, !amountString.isEmpty,
              let oddsString, !oddsString.isEmpty
        else {
            print("One or more input values is null or empty222")
            return nil
        }

        let amount = Decimal(string: amountString) ?? Decimal()
        let odds = Decimal(string: oddsString) ?? Decimal()

        let predictedWin = amount * odds
        return predictedWin
    }

    /// TODO: Ta funkcja nie działa i nie liczy poprawnie np 90
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
            print("One or more input values is null, empty, or cannot be converted to Decimal")
            return nil
        }

        let taxCorrected = 1.0 - tax / 100
        print("Tax corrected: \(taxCorrected)")

        let predictedWin = amount * odds * taxCorrected
        print("Predicted win: \(predictedWin)")

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
    private func saveSelectedReminder() {
        UserNotificationsService().scheduleNotification(
            withID: betNotificationID,
            titleName: "\(team1 + team2)",
            // Corrected the concatenation as previously suggested
            notificationTriggerDate: selectedNotificationDate
        )
    }

    // MARK: - Validate & Error handling methods

    private func filterDecimalInput(
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
                nil { // 5.55, 1.22, 1.22, 10.<22>
                cleanedInput = oldValue
            }
        case .tax:
            if input.first == "0" {
                return "0"
            }
            if cleanedInput
                .wholeMatch(of: /[0-9][0-9]{0,3}?((\.|,)[0-9]{,2})?/) ==
                nil { // 5.55, 1.22, 1.22, 10.<22>
                cleanedInput = oldValue
            }
        case .standard:
            if cleanedInput
                .wholeMatch(of: /[1-9][0-9]{0,2}?((\.|,)[0-9]{,2})?/) ==
                nil { // 5.55, 1.22, 1.22, 10.<22>
                cleanedInput = oldValue
            }
        case .name:
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

    // TODO(azapior): zmiana
    // STOPSHIP

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

        print("data saved")

        var newTax = tax

        if !isDefaultTaxSet {
            newTax = NSDecimalNumber.zero.stringValue
        }

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

        saveSelectedReminder()
        respository.saveBet(model: bet)

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

        saveSelectedReminder()
        respository.saveBet(model: betslip)

        return true
    }

    // MARK: - VM SETUP:

    private func loadDefaultCurrency() {
        defaultCurrency = Currency(rawValue: defaults.get(.defaultCurrency)) ?? .usd
    }

    // ** Methods used to run inside .onApper and .onDissapear view methods **

    func saveTextInTexfield() {
        defaults.set(.team1, to: team1)
        defaults.set(.team2, to: team2)
        defaults.set(.amount, to: amount)
        defaults.set(.odds, to: odds)
        defaults.set(.league, to: league)
        defaults.set(.selectedDate, to: selectedDate)
    }

    func loadTextInTextfield() {
        team1 = defaults.get(.team1)
        team2 = defaults.get(.team2)
        amount = defaults.get(.amount)
        odds = defaults.get(.odds)
        tax = defaults.get(.defaultTax) // load default Tax to field
        league = defaults.get(.league)
        selectedDate = defaults.get(.selectedDate)
    }

    func clearTextField() {
        team1 = ""
        team2 = ""
        amount = ""
        odds = ""
        tax = ""
        league = ""
        selectedDate = Date.now
    }

    enum DateRowState {
        case closed
        case opened
    }

    enum ReminderRowState {
        case add
        case editing
        case delete
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
        case standard
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
                return "Błąd zespołu 1"
            case .team2:
                return "Błąd zespołu 2"
            case .name:
                return "Błąd nazwy"
            case .amount:
                return "Błąd amount"
            case .odds:
                return "Błąd kursu"
            case .tax:
                return "Błąd podatku"
            case .notification:
                return "Błąd powiadomienia"
            }
        }
    }

}

enum BetType: String, CaseIterable, Identifiable {
    var id: String { rawValue }

    case singlebet = "Single Bet"
    case betslip
}
