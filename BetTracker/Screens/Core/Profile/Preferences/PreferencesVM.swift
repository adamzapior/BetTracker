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
    var defaultCurrency = "PLN" {
        didSet {
            if defaultCurrency.isEmpty {
                return
            }
            if defaultCurrency.wholeMatch(of: /[A-Z]{,3}/) == nil {
                defaultCurrency = oldValue
            }
        }
    }

    func savePreferences() {
        defaults.set(.username, to: username)
        defaults.set(.defaultTax, to: defaultTax)
        defaults.set(.defaultCurrency, to: defaultCurrency)
    }

    func loadPreferences() {
        username = defaults.get(.username)
        defaultTax = defaults.get(.defaultTax)
        defaultCurrency = defaults.get(.defaultCurrency)
    }
}
