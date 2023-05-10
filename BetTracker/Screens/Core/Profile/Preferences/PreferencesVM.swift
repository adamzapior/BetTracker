import Foundation
import SwiftUI
import Combine

class PreferencesVM: ObservableObject {

    let defaults = UserDefaultsManager.path
    
    
    @Published
    var isDefaultTaxOn: Bool = false {
        didSet {
            if isDefaultTaxOn {
                taxStatus = .taxUnsaved
            } else {
                taxStatus = .taxSaved
                clearTaxTextField()
                print(isDefaultTaxOn)
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
        defaults.set(.defaultCurrency, to: defaultCurrency)
    }

    func loadPreferences() {
        username = defaults.get(.username)
        isDefaultTaxOn = defaults.get(.isDefaultTaxOn)
        defaultTax = defaults.get(.defaultTax)
        defaultCurrency = defaults.get(.defaultCurrency)
    }
}


extension Binding {
    /// Execute block when value is changed.
    ///
    /// Example:
    ///
    ///     Slider(value: $amount.didSet { print($0) }, in: 0...10)
    func didSet(execute: @escaping (Value) ->Void) -> Binding {
        return Binding(
            get: {
                return self.wrappedValue
            },
            set: {
                self.wrappedValue = $0
                execute($0)
            }
        )
    }
}
