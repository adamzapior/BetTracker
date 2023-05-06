import Combine
import Foundation
import SwiftUI

class AddBetVM: ObservableObject {

    init() {
        Publishers.CombineLatest3($amount, $odds, $tax)
            .map { [weak self] amount, odds, tax in
                guard let self else {
                    return "0.0"
                }
                let profit = self.betProfit(
                    amountString: amount,
                    oddsString: odds,
                    taxString: tax
                ) ?? Decimal()
                return String(describing: profit)
            }
            .assign(to: &$profit)
    }

    private let defaults = UserDefaults.standard

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
            // swiftlint:disable opening_brace
            if !amount.isEmpty,
               amount.wholeMatch(of: /[0-9]|[1-9][0-9]{0,5}+\.?[0-9]{,2}/) == nil {
                amount = oldValue
            }
            amountIsError = false
        }
    }
    
    @Published
    var defaultCurrency = ""

    @Published
    var selectedDate = Date()

    @Published
    var odds = "" {
        didSet {
            oddsIsError = false
            if odds.isEmpty {
                return
            }
            // swiftlint:disable opening_brace
            if odds
                .wholeMatch(of: /[1-9][0-9]{0,2}?(\.[0-9]{,2})?/) == nil { // 5.55, 1.22, 1.22, 10.<22>
                odds = oldValue
            }
        }
    }

    @Published
    var tax = "" {
        didSet {
            taxIsError = false
            if tax.isEmpty {
                return
            }
            // swiftlint:disable opening_brace
            if tax.wholeMatch(of: /[1-9][0-9]?(\.[0-9]{,2})?/) == nil {
                tax = oldValue
            }
        }
    }

    @Published
    var selectedTeam = SelectedTeam.team1

    func onTeam1Selected() {
        selectedTeam = .team1
    }

    func onTeam2Selected() {
        selectedTeam = .team2
    }

    @Published
    var category = ""

    @Published
    var league = ""

    @Published
    var profit = "0.0"

    @Published
    var team1IsError = false
    @Published
    var team2IsError = false
    @Published
    var amountIsError = false
    @Published
    var oddsIsError = false
    @Published
    var taxIsError = false
    @Published
    var leagueIsError = false

    func betProfit(
        amountString: String?,
        oddsString: String?,
        taxString: String?
    ) -> Decimal? {
        guard let amountString, !amountString.isEmpty,
              let oddsString, !oddsString.isEmpty,
              let taxString, !taxString.isEmpty
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

    private func validateAmount() {
        if amount.isEmpty {
            amountIsError = true
        }
    }

    private func validateOdds() {
        if odds.isEmpty {
            oddsIsError = true
        }
    }

    private func validateTax() {
        if tax.isEmpty {
            taxIsError = true
        }
    }

    func saveBet() -> Bool {
        validateTeam1()
        validateTeam2()
        validateAmount()
        validateOdds()
        validateTax()

        if team1IsError || team2IsError || amountIsError || oddsIsError ||
            taxIsError {
            return false
        }

        BetDao.saveBet(bet: BetModel(
            id: nil,
            date: selectedDate,
            team1: team1,
            team2: team2,
            selectedTeam: selectedTeam,
            league: league,
            amount: NSDecimalNumber(string: amount),
            odds: NSDecimalNumber(string: odds),
            category: category,
            tax: NSDecimalNumber(string: tax),
            profit: profit,
            isWon: nil
        ))

        return true
    }

    func saveTextInTexfield() {
        defaults.set(team1, forKey: "team1")
        defaults.set(team2, forKey: "team2")
        defaults.set(amount, forKey: "amount")
        defaults.set(odds, forKey: "odds")
        defaults.set(category, forKey: "category")
        defaults.set(league, forKey: "league")
        defaults.set(selectedDate, forKey: "selectedDate")
    }

    func loadTextInTextfield() {
        team1 = defaults.object(forKey: "team1") as? String ?? ""
        team2 = defaults.object(forKey: "team2") as? String ?? ""
        amount = defaults.object(forKey: "amount") as? String ?? ""
        odds = defaults.object(forKey: "odds") as? String ?? ""
        tax = defaults.object(forKey: "defaultTax") as? String ?? ""
        defaultCurrency = defaults.object(forKey: "defaultCurrency") as? String ?? ""
        category = defaults.object(forKey: "category") as? String ?? ""
        league = defaults.object(forKey: "league") as? String ?? ""
        selectedDate = defaults.object(forKey: "selectedDate") as? Date ?? Date.now
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
    
    // MARK: idk gdzie to powinno być w pliku XD

    enum Category: String, CaseIterable {
        case football = "Football"
        case basketball = "Basketball"
        case f1 = "F1"
    }

}

extension String {
    func nilIfEmpty() -> String? {
        if isEmpty {
            return nil
        }
        return self
    }

    func trim() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
