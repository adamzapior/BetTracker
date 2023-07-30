import Combine
import Foundation
import SwiftUI

class PreferencesVM: ObservableObject {

    private let interactor: PreferencesInteractor

    init(
        interactor: PreferencesInteractor
    ) {
        self.interactor = interactor

        get()
    }

    func save() {
        interactor.execute(
            username: username,
            isDefaultTaxOn: isDefaultTaxOn,
            defaultTax: "(\taxStatus)",
            defaultCurrency: defaultCurrency
        )
    }

    func get() {
        interactor.execute(username: username, isDefaultTaxOn: isDefaultTaxOn, defaultTax: defaultTax, defaultCurrency: defaultCurrency)
        self.username = username
        self.isDefaultTaxOn = isDefaultTaxOn
        self.defaultTax = defaultTax
        self.defaultCurrency = defaultCurrency
    }

    let defaults = UserDefaultsManager.path

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

    @Published
    var taxStatus = DefaultTax.taxUnsaved

    func taxSaved() {
        taxStatus = .taxSaved
    }

    func taxUnsaved() {
        taxStatus = .taxUnsaved
    }

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
    var defaultCurrency: Currency = Currency.usd

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
        UserDefaults.standard.set(defaultCurrency.rawValue, forKey: "defaultCurrency")
    }

    func loadPreferences() {
        username = defaults.get(.username)
        isDefaultTaxOn = defaults.get(.isDefaultTaxOn)
        defaultTax = defaults.get(.defaultTax)
        UserDefaults.standard.object(forKey: "defaultCurrency")
    }

    func getDefaultCurrency() {
        defaultCurrency = Currency(
            rawValue: UserDefaults.standard
                .string(forKey: "defaultCurrency") ?? "usd"
        )!
    }
}

class PreferencesInteractor: SavePreferencesUseCase, LoadPreferencesUseCase {
    func execute() -> (username: String, isDefaultTaxOn: Bool, defaultTax: String, defaultCurrency: Currency) {
        let username = defaults.get(.username)
        let isDefaultTaxOn = defaults.get(.isDefaultTaxOn)
        let defaultTax = defaults.get(.defaultTax)
        let defaultCurrency = Currency(
            rawValue: UserDefaults.standard
                .string(forKey: "defaultCurrency") ?? "usd"
        )!

        return (username, isDefaultTaxOn, defaultTax, defaultCurrency)
    }
    
    let defaults = UserDefaultsManager.path

    func execute(
        username: String,
        isDefaultTaxOn: Bool,
        defaultTax: String,
        defaultCurrency: Currency
    ) {
        defaults.set(.username, to: username)
        defaults.set(.isDefaultTaxOn, to: isDefaultTaxOn)
        defaults.set(.defaultTax, to: defaultTax)
        UserDefaults.standard.set(defaultCurrency.rawValue, forKey: "defaultCurrency")
    }

}

protocol SavePreferencesUseCase {
    func execute(
        username: String,
        isDefaultTaxOn: Bool,
        defaultTax: String,
        defaultCurrency: Currency
    )
}

protocol LoadPreferencesUseCase {
    func execute()
        -> (username: String, isDefaultTaxOn: Bool, defaultTax: String, defaultCurrency: Currency)
}
