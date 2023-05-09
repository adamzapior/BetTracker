import Foundation
import SwiftUI

class PreferencesVM: ObservableObject {

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
        UserDefaultsManager.useManager.set(
            username,
            forKey: UserDefaultsManager.Keys.username
        )
        UserDefaultsManager.useManager.set(
            defaultTax,
            forKey: UserDefaultsManager.Keys.defaultTax
        )
        UserDefaultsManager.useManager.set(
            defaultCurrency,
            forKey: UserDefaultsManager.Keys.defaultCurrency
        )
    }

    func loadPreferences() {
        username = UserDefaultsManager.useManager
            .object(forKey: UserDefaultsManager.Keys.username) as? String ?? ""
        defaultTax = UserDefaultsManager.useManager
            .object(forKey: UserDefaultsManager.Keys.defaultTax) as? String ?? ""
        defaultCurrency = UserDefaultsManager.useManager
            .object(forKey: UserDefaultsManager.Keys.defaultCurrency) as? String ?? ""
    }

}
