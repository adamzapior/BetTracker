import Combine
import Foundation
import SwiftUI

class AddBetVM: ObservableObject {

    let defaults = UserDefaultsManager.path
    let interactor = AddBetInteractor(BetDao: BetDao())

    init() {
        // Pass to publisher

        // propably to delete?
        savedDate = defaults.get(.savedNotificationDate)
        isReminderSaved = defaults.get(.isNotificationSaved)

        taxStatus = defaults.get(.isDefaultTaxOn) // Read isTaxOn from UserDefault
        configureTaxInput() // Pass to publisher

        // Predicted profit
//        updateProfit()
    }

    @Published
    var betType: BetType = .singlebet

    // MARK: - SINGLE BET

    @Published
    var team1: String = String() {
        didSet {
            team1IsError = false
        }
    }

    @Published
    var team2: String = String() {
        didSet {
            team2IsError = false
        }
    }

    @Published
    var selectedTeam = SelectedTeam.team1

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
            let cleanedOdds = filterDecimalInput(input: odds, oldValue: oldValue, filterType: .tax)
            if cleanedOdds != odds {
                odds = cleanedOdds
            }
        }
    }

    @Published
    var tax: String = "0.0" {
        didSet {
            updateProfit()
            let cleanedTax = filterDecimalInput(input: tax, oldValue: oldValue, filterType: .amount)
            if cleanedTax != tax {
                tax = cleanedTax
            }
        }
    }

    @Published
    var league: String = String()

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

    // MARK: - BETSLIP

    @Published
    var betslipName = ""

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
    var betslipCategory = ""

    @Published
    var betslipTax = "0.0" {
        didSet {
            updateProfit()
            let cleanedTax = filterDecimalInput(
                input: betslipTax,
                oldValue: oldValue,
                filterType: .amount
            )
            if cleanedTax != betslipTax {
                betslipTax = cleanedTax
            }
        }
    }

    @Published
    var betslipProfit: NSDecimalNumber = 0

    @Published
    var betslipNotificationID = UUID().uuidString

    @Published
    var betslipScore: NSDecimalNumber = 0

    // MARK: - MERGED varbiables for bets

    /// ReminderRowState methods:
    enum DateRowState {
        case closed
        case opened
    }

    @Published
    var selectedDate = Date()

    @Published
    var showDatePicker: Bool = false

    // MARK: Reminders

    /// ReminderRowState methods:
    enum ReminderRowState {
        case add
        case editing
        case delete
    }

    @Published
    var selectedNotificationDate = Date.now

    @Published
    var betNotificationID = UUID().uuidString

    var isReminderSaved: Bool

    var savedDate: Date //    TODO: !!!!!

    @Published
    var dateState: DateRowState = .closed

    @Published
    var reminderState: ReminderRowState = .add

    // MARK: Tax State

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

    // MARK: Error handling

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
    @Published
    var notificationIsError = false

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
    func configureTaxInput() {
        if taxStatus {
            isTaxInputDisabled = true
        } else {
            isTaxInputDisabled = false
        }
    }

    // EVENT DATE

    func openDate() {
        dateState = .opened
    }

    func closeDate() {
        dateState = .closed
    }

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

    // MARK: - Calculate methods

    // Predicted win methods:
    // Methods used to calculate data with Combine in Init

    /// TODO: FIX THIS SHIT
    func betProfitWithoutTex(
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

    func updateProfit() {
        switch betType {
        case .singlebet:
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

    // MARK: -  METHODS FOR ADD BET VIEWMODEL VARIABLES:

    /**
     The function saves the user's notification if the date is different from ' Date.now '
     - Parameter withID: Uniqe ID based on UUID.string variable
     - Parameter titleName: Name used for Reminder Title
     - Parameter notificationTriggerDate:Selected date to trigger notification
     */
    private func saveReminder() {
        UserNotificationsService().scheduleNotification(
            withID: betNotificationID,
            titleName: "\(team1 + team2)",
            // Corrected the concatenation as previously suggested
            notificationTriggerDate: selectedNotificationDate
        )
    }

    var reminderDateClosedRange: ClosedRange<Date> {
        let min = Date.now
        let max = Calendar.current.date(byAdding: .year, value: 1, to: Date())!
        return min ... max
    }

    // MARK: - Validate & Error handling methods

    enum filterType: CaseIterable {

        case amount
        case tax
        case standard
    }

    private func filterDecimalInput(
        input: String,
        oldValue: String,
        filterType: filterType
    ) -> String {
        var myinput = input

        if myinput.isEmpty {
            return myinput
        }
        let cleanedInput = myinput
            .replacingOccurrences(of: ",", with: ".")

        if cleanedInput != myinput {
            myinput = cleanedInput
            return myinput
        }

        switch filterType {
        case .amount:
            if cleanedInput
                .wholeMatch(of: /[1-9][0-9]{0,6}?((\.|,)[0-9]{,2})?/) ==
                nil { // 5.55, 1.22, 1.22, 10.<22>
                myinput = oldValue
            }
        case .tax:
            if cleanedInput
                .wholeMatch(of: /[1-9][0-9]{0,1}?((\.|,)[0-9]{,2})?/) ==
                nil { // 5.55, 1.22, 1.22, 10.<22>
                myinput = oldValue
            }
        case .standard:
            if cleanedInput
                .wholeMatch(of: /[1-9][0-9]{0,2}?((\.|,)[0-9]{,2})?/) ==
                nil { // 5.55, 1.22, 1.22, 10.<22>
                myinput = oldValue
            }
        }
        return myinput
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
        if amount.isEmpty {
            amountIsError = true
        }
    }

    private func validateBetslipTax() { }

    private func validateNotification() {
        if selectedNotificationDate < Date.now {
            notificationIsError = true
        }
    }
    
    enum ValidateError: CustomStringConvertible {
        case team1
        case team2
        case name
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
            case .odds:
                return "Błąd kursu"
            case .tax:
                return "Błąd podatku"
            case .notification:
                return "Błąd powiadomienia"
            }
        }       
    }
    
    func pass() {
        
    }

    // MARK: - Save bet/betslip to DB

    func saveBet() -> Bool {
        validateTeam1()
        validateTeam2()
        validateAmount()
        validateOdds()
        validateTax()
        validateNotification()

        if team1IsError || team2IsError || amountIsError || oddsIsError
            || taxIsError
            
//            || notificationIsError
        
        {
            return false
        }
        print("data saved")

        saveReminder()

        var newTax = tax

        if !taxStatus {
            newTax = NSDecimalNumber.zero.stringValue
        }

        interactor.savebetTest(
            id: nil,
            date: selectedDate,
            team1: team1,
            team2: team2,
            selectedTeam: selectedTeam,
            amount: NSDecimalNumber(string: amount),
            odds: NSDecimalNumber(string: odds),
            category: selectedCategory,
            league: league,
            selectedDate: selectedDate,
            tax: NSDecimalNumber(string: tax),
            profit: profit,
            isWon: nil,
            betNotificationID: betNotificationID,
            score: score
        )
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

     
        
        var betslip = BetslipModel(
            id: nil,
            date: selectedDate,
            name: betslipName,
            amount: NSDecimalNumber(string: betslipAmount),
            odds: NSDecimalNumber(string: betslipOdds),
            category: selectedCategory,
            tax: NSDecimalNumber(string: betslipTax),
            profit: betslipProfit,
            isWon: true,
            betNotificationID: betNotificationID,
            score: score
        )

        if !taxStatus {
            betslip.tax = NSDecimalNumber.zero
        }

        interactor.saveBet(model: betslip)
        return true
    }

    // MARK: - VM SETUP:

    // ** Methods are used to run inside .onApper and .onDissapear view methods **

    func saveTextfield() {
        interactor.saveTextfield(
            team1: team1,
            team2: team2,
            amount: amount,
            odds: odds,
            category: category,
            league: league,
            selectedDate: selectedDate
        )
    }

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

    case singlebet = "Single Bet"
    case betslip
}



