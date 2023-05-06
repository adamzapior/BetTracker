import Foundation
import SwiftUI

class PreferencesVM: ObservableObject {

    let defaults = UserDefaults.standard

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
        defaults.set(defaultTax, forKey: "defaultTax")
        defaults.set(defaultCurrency, forKey: "defaultCurrency")
    }

    func loadPreferences() {
        defaultTax = defaults.object(forKey: "defaultTax") as? String ?? ""
        defaultCurrency = defaults.object(forKey: "defaultCurrency") as? String ?? ""
    }

}
