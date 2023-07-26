import Combine
import Foundation
import SwiftUI

final class AddBetVM: ObservableObject {

    let defaults = UserDefaultsManager.path

    init() {
        // propably to delete?
        savedDate = defaults.get(.savedNotificationDate)
        isReminderSaved = defaults.get(.isNotificationSaved)

        taxStatus = defaults.get(.isDefaultTaxOn) // Read isTaxOn from UserDefault
        configureTaxInput() // Pass to publisher

        // Predicted profit
        updateProfit()
    }
    
    func updateProfit() {
        switch betType {
        case .solobet:
            if taxStatus {
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
            if taxStatus {
                Publishers.CombineLatest3($betslipAmount, $betslipOdds, $betslipTax)
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
                    .assign(to: &$betslipProfit)
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
                    .assign(to: &$betslipProfit)
            }
        }
    }

    // MARK: - BET TYPE:

    @Published
    var betType: BetType = .solobet

    func switchBetTypeToBetSlip() {
        betType = .betslip
    }

    func switchBetTypeToSolobet() {
        betType = .solobet
    }

    // MARK: -  SOLOBET

    /// ** AddBet - User input Textfield's variables **
    @Published
    var team1 = "" {
        didSet {
            team1IsError = false
        }
    }

    @Published
    var team2 = "" {
        didSet {
            team2IsError = false
        }
    }

    @Published
    var amount = "" {
        didSet {
            updateProfit()
            amountIsError = false
            if amount.isEmpty {
                return
            }
            let cleanedAmount = amount
                .replacingOccurrences(of: ",", with: ".") // replace comma with dot
            if cleanedAmount != amount {
                amount =
                    cleanedAmount // set the cleaned odds as the new value if they are different
                return
            }

            if cleanedAmount.wholeMatch(of: /[1-9][0-9]{0,5}?((\.|,)[0-9]{,2})?/) == nil {
                amount =
                    oldValue // revert back to the old value if it doesn't match the regular
                // expression
            }
        }
    }

    @Published
    var odds = "" {
        didSet {
            updateProfit()
            oddsIsError = false
            if odds.isEmpty {
                return
            }
            let cleanedOdds = odds.replacingOccurrences(of: ",", with: ".")
            if cleanedOdds != odds {
                odds = cleanedOdds
                return
            }

            if cleanedOdds
                .wholeMatch(of: /[1-9][0-9]{0,2}?((\.|,)[0-9]{,2})?/) ==
                nil { // 5.55, 1.22, 1.22, 10.<22>
                odds = oldValue
            }
        }
    }

    @Published
    var tax = "0.0" {
        didSet {
            updateProfit()
            if tax.isEmpty {
                return
            }
            let cleanedTax = tax.replacingOccurrences(of: ",", with: ".")
            if cleanedTax != tax {
                tax = cleanedTax
                return
            }

            if cleanedTax
                .wholeMatch(of: /[1-9][0-9]{0,1}?((\.|,)[0-9]{,2})?/) ==
                nil { // 5.55, 1.22, 1.22, 10.<22>
                tax = oldValue
            }
        }
    }

    @Published
    var league = ""

    @Published
    var category = ""

    @Published
    var selectedCategory = Category.football

    /// AddBet non-edit Row's variables:
    @Published
    var defaultCurrency: Currency = Currency.usd // Used for overlay text at Textfield

    @Published
    var profit: NSDecimalNumber = 0

    @Published
    var score: NSDecimalNumber = .zero

    // MARK: - Selected checkmark team logic:

    @Published
    var selectedTeam = SelectedTeam.team1

    func onTeam1Selected() {
        selectedTeam = .team1
    }

    func onTeam2Selected() {
        selectedTeam = .team2
    }

    // MARK: - BETSLIP

    // ** Betslip variables **

    @Published
    var betslipName = ""

    @Published
    var betslipAmount = "" {
        didSet {
            updateProfit()
            betslipAmountIsError = false
            if betslipAmount.isEmpty {
                return
            }
            let cleanedAmount = betslipAmount
                .replacingOccurrences(of: ",", with: ".") // replace comma with dot
            if cleanedAmount != betslipAmount {
                betslipAmount =
                    cleanedAmount // set the cleaned odds as the new value if they are different
                return
            }

            if cleanedAmount.wholeMatch(of: /[1-9][0-9]{0,5}?((\.|,)[0-9]{,2})?/) == nil {
                betslipAmount =
                    oldValue // revert back to the old value if it doesn't match the regular
                // expression
            }
        }
    }

    @Published
    var betslipOdds = "" {
        didSet {
            updateProfit()
            betslipOddsIsError = false
            if betslipOdds.isEmpty {
                return
            }
            let cleanedOdds = betslipOdds.replacingOccurrences(of: ",", with: ".")
            if cleanedOdds != betslipOdds {
                betslipOdds = cleanedOdds
                return
            }

            if cleanedOdds
                .wholeMatch(of: /[1-9][0-9]{0,2}?((\.|,)[0-9]{,2})?/) ==
                nil { // 5.55, 1.22, 1.22, 10.<22>
                betslipOdds = oldValue
            }
        }
    }

    @Published
    var betslipCategory = ""

    @Published
    var betslipTax = "0.0" {
        didSet {
            updateProfit()
            if betslipTax.isEmpty {
                return
            }
            let cleanedTax = betslipTax.replacingOccurrences(of: ",", with: ".")
            if cleanedTax != betslipTax {
                betslipTax = cleanedTax
                return
            }

            if cleanedTax
                .wholeMatch(of: /[1-9][0-9]{0,1}?((\.|,)[0-9]{,2})?/) ==
                nil { // 5.55, 1.22, 1.22, 10.<22>
                betslipTax = oldValue
            }
        }
    }

    @Published
    var betslipProfit: NSDecimalNumber = 0

    @Published
    var betslipNotificationID = UUID().uuidString

    @Published
    var betslipScore: NSDecimalNumber = 0

    // MARK: - TAX STATE:

    enum taxRowState {
        case active
        case disable
    }

    /// #1 Current Row State && taxStatus var
    @Published
    var taxRowStateValue = taxRowState.disable

    var taxStatus: Bool

    /// #2 Variable to observe changes in taxStatus Variable (base
    @Published
    var isTaxInputDisabled: Bool = false {
        didSet {
            if isTaxInputDisabled {
                taxRowStateValue = .active
            } else {
                taxRowStateValue = .disable
            }
        }
    }

    /// 3 Read taxStatus from init
    /// Func run in init and set value of isTaxInputDisabled depend on taxStatus Value
    /// taxStatus is boolean value of default tax user settings.
    ///     1. taxStatus = true - the user has a default tax value set
    ///     2. taxStatus = false - user has no default tax value set
    func configureTaxInput() {
        if taxStatus {
            isTaxInputDisabled = true
        } else {
            isTaxInputDisabled = false
        }
    }

    // MARK: - EVENT DATE

    /// ReminderRowState methods:
    enum DateRowState {
        case closed
        case opened
    }

    @Published
    var dateState: DateRowState = .closed

    func openDate() {
        dateState = .opened
    }

    func closeDate() {
        dateState = .closed
    }

    @Published
    var selectedDate = Date()

    // MARK: - REMINDERS:

    @Published
    var showDatePicker: Bool = false

    @Published
    var selectedNotificationDate = Date.now

    @Published
    var betNotificationID = UUID().uuidString

    var isReminderSaved: Bool

    var savedDate: Date //    TODO: !!!!!

    /// ReminderRowState methods:
    enum ReminderRowState {
        case add
        case editing
        case delete
    }

    @Published
    var reminderState: ReminderRowState = .add

    func isAddClicked() {
        reminderState = .editing
    }

    func deleteRemind() {
        reminderState = .add
        selectedNotificationDate = Date()
    }

    func saveIsClicked() {
        reminderState = .delete
    }

    // MARK: -  METHODS FOR ADD BET VIEWMODEL VARIABLES:

    /**
     The function saves the user's notification if the date is different from ' Date.now '
     - Parameter withID: Uniqe ID based on UUID.string variable
     - Parameter titleName: Name used for Reminder Title
     - Parameter notificationTriggerDate:Selected date to trigger notification
     */
    private func saveReminder() {
        UserNotificationsService().scheduleNotification(
            withID: betNotificationID, // i need add this to BetDao
            titleName: "\(team1 + team1)",
            notificationTriggerDate: selectedNotificationDate
        )
    }

    var reminderDateClosedRange: ClosedRange<Date> {
        let min = Date.now
        let max = Calendar.current.date(byAdding: .year, value: 1, to: Date())!
        return min ... max
    }

    // Predicted win methods:
    // Methods used to calculate data with Combine in Init

    func betProfitWithoutTex(
        amountString: String?,
        oddsString: String?
    ) -> Decimal? {
        guard let amountString, !amountString.isEmpty,
              let oddsString, !oddsString.isEmpty
        else {
            print("One or more input values is null or empty")
            return nil
        }

        let amount = Decimal(string: amountString) ?? Decimal()
        let odds = Decimal(string: oddsString) ?? Decimal()

        let predictedWin = amount * odds
        return predictedWin
    }

    /// TODO: Ta funkcja nie działa i nie liczy poprawnie np 90
    func betProfitWithTax(
        amountString: String?,
        oddsString: String?,
        taxString: String?
    ) -> Decimal? {
        guard let amountString, !amountString.isEmpty,
              let oddsString, !oddsString.isEmpty,
              let taxString, !taxString.isEmpty, !taxString.contains("0")
        else {
            print("One or more input values is null or empty")
            return nil
        }

        let amount = Decimal(string: amountString) ?? Decimal()
        let odds = Decimal(string: oddsString) ?? Decimal()
        let tax = Decimal(string: taxString) ?? Decimal()

        let taxCorrected = 1.0 - tax / 100
        print(taxCorrected)

        let predictedWin = amount * odds * taxCorrected
        print(predictedWin)
        return predictedWin
    }

    // MARK: - ERROR HANDLING

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
    var betslipTaxsIsError = false

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
        if amount.isEmpty {
            amountIsError = true
        }
    }

    private func validateBetslipTax() { }

    // MARK: - SAVE TO DB

    /// ** Save data to DB **
    func saveBet() -> Bool {
        validateTeam1()
        validateTeam2()
        validateAmount()
        validateOdds()
        validateTax()

        if team1IsError || team2IsError || amountIsError || oddsIsError
            || taxIsError {
            return false
        }
        print("data saved")

        saveReminder()

        // run if:
        //     true: default tax is On
        //     false:  default tax is Off
        if taxStatus {
            BetDao.saveBet(bet: BetModel(
                id: nil,
                date: selectedDate,
                team1: team1,
                team2: team2,
                selectedTeam: selectedTeam,
                league: league,
                amount: NSDecimalNumber(string: amount),
                odds: NSDecimalNumber(string: odds),
                category: selectedCategory,
                tax: NSDecimalNumber(string: tax),
                profit: profit,
                isWon: nil,
                betNotificationID: betNotificationID,
                score: score

            ))
        } else {
            BetDao.saveBet(bet: BetModel(
                id: nil,
                date: selectedDate,
                team1: team1,
                team2: team2,
                selectedTeam: selectedTeam,
                league: league,
                amount: NSDecimalNumber(string: amount),
                odds: NSDecimalNumber(string: odds),
                category: selectedCategory,
                tax: NSDecimalNumber.zero,
                profit: profit,
                isWon: nil,
                betNotificationID: betNotificationID,
                score: score
            ))
        }

        return true
    }

    func saveBetslip() -> Bool {
        validateBetslipName()
        validateBetslipAmount()
        validateBetslipOdds()
        validateBetslipTax()

        if betslipNameIsError || betslipAmountIsError || betslipOddsIsError || betslipTaxsIsError {
            return false
        }
        print("data saved")

        saveReminder()

        if taxStatus {
            BetDao.saveBetslip(bet: BetslipModel(
                id: nil,
                date: selectedDate, name: betslipName,
                amount: NSDecimalNumber(string: betslipAmount),
                odds: NSDecimalNumber(string: betslipOdds),
                category: selectedCategory,
                tax: NSDecimalNumber(string: betslipTax),
                profit: betslipProfit,
                isWon: nil,
                betNotificationID: betNotificationID,
                score: score

            ))
        } else {
            BetDao.saveBetslip(bet: BetslipModel(
                id: nil,
                date: selectedDate, name: betslipName,
                amount: NSDecimalNumber(string: betslipAmount),
                odds: NSDecimalNumber(string: betslipOdds),
                category: selectedCategory,
                tax: NSDecimalNumber.zero,
                profit: betslipProfit,
                isWon: nil,
                betNotificationID: betNotificationID,
                score: score
            ))
        }

        return true
    }

    // MARK: - VIEW SETUP:

    // ** Methods are used to run inside .onApper and .onDissapear view methods **

    func saveTextInTexfield() {
        defaults.set(.team1, to: team1)
        defaults.set(.team2, to: team2)
        defaults.set(.amount, to: amount)
        defaults.set(.odds, to: odds)
        defaults.set(.category, to: category)
        defaults.set(.league, to: league)
        defaults.set(.selectedDate, to: selectedDate)
    }

    func loadTextInTextfield() {
        team1 = defaults.get(.team1)
        team2 = defaults.get(.team2)
        amount = defaults.get(.amount)
        odds = defaults.get(.odds)
        tax = defaults.get(.defaultTax) // load default Tax to field
        defaultCurrency = Currency(
            rawValue: UserDefaults.standard
                .string(forKey: "defaultCurrency") ?? "usd"
        )!
        category = defaults.get(.category)
        league = defaults.get(.league)
        selectedDate = defaults.get(.selectedDate)
    }

    func clearTextField() {
        team1 = ""
        team2 = ""
        amount = ""
        odds = ""
        tax = ""
        category = ""
        league = ""
        selectedDate = Date.now
    }

}

enum BetType: String, CaseIterable, Identifiable {
    var id: String { rawValue }

    case solobet = "Single Bet"
    case betslip
}
