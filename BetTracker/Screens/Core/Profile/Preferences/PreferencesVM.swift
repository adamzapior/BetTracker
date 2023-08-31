import Combine
import Foundation
import SwiftUI

class PreferencesVM: ObservableObject {

    let defaults = UserDefaultsManager.path

    @Published
    var username = ""

    @Published
    var defaultTax = "" {
        didSet {
            if defaultTax.isEmpty {
                return
            }
            if defaultTax.wholeMatch(of: /[1-9][0-9]?(\.[0-9]{,2})?/) == nil {
                defaultTax = oldValue
            }
        }
    }

    @Published
    var taxStatus = DefaultTax.taxUnsaved
    
    @Published
    var defaultCurrency: Currency = Currency.usd

    init() {
        loadSavedPreferences()
    }

    @Published
    var isDefaultTaxOn: Bool = false {
        didSet {
            if isDefaultTaxOn {
                taxStatus = .taxUnsaved
            } else {
                taxStatus = .taxSaved
                clearTaxTextField()
            }
        }
    }

    enum DefaultTax {
        case taxSaved
        case taxUnsaved
    }

    func taxSaved() {
        taxStatus = .taxSaved
    }

    func taxUnsaved() {
        taxStatus = .taxUnsaved
    }

    func clearTaxTextField() {
        let taxString = ""
        defaultTax = taxString
    }

    func setDefaultTaxTo0() {
        let taxString = "0"
        defaults.set(.defaultTax, to: taxString)
    }

    func ifTaxEmpty() {
        let tax = defaultTax

        if tax.isEmpty {
            isDefaultTaxOn = false
        }
    }

    func savePreferences() {
        defaults.set(.username, to: username)
        defaults.set(.isDefaultTaxOn, to: isDefaultTaxOn)
        defaults.set(.defaultTax, to: defaultTax)
        defaults.set(.defaultCurrency, to: defaultCurrency.rawValue)
    }

    func loadSavedPreferences() {
        username = defaults.get(.username)
        isDefaultTaxOn = defaults.get(.isDefaultTaxOn)
        defaultTax = defaults.get(.defaultTax)
        defaultCurrency = Currency(
            rawValue: UserDefaults.standard
                .string(forKey: "defaultCurrency") ?? "usd"
        )!
    }

}
