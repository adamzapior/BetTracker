import Foundation
import LifetimeTracker

class UserDefaultsManager {
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        
#if DEBUG
trackLifetime()
#endif
    }
    
    func getValue<T: Defaultable>(for key: DefaultsKey<T>) -> T.Value {
        userDefaults.object(forKey: key.value) as? T.Value ?? T.defaultValue
    }
    
    func setValue<T>(_ value: T, for key: DefaultsKey<T>) {
        userDefaults.set(value, forKey: key.value)
    }
    
    // MARK: Global variables
    static var defaultCurrencyValue: String {
        get {
            UserDefaults.standard.string(forKey: "defaultCurrency") ?? "PLN"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "defaultCurrency")
        }
    }
}

extension UserDefaultsManager: LifetimeTrackable {
    class var lifetimeConfiguration: LifetimeConfiguration {
        return LifetimeConfiguration(maxCount: 1, groupName: "UserDefaultsManager")
    }
}


class DefaultsKeys { }

final class DefaultsKey<T>: DefaultsKeys {
    let value: String
    init(_ value: String) {
        self.value = value
    }
}

// MARK: UserDefaults Keys to save&load
extension DefaultsKeys {
    /// Onboarding:
    static let hasSeenOnboarding = DefaultsKey<Bool>("hasSeenOnboarding")
    /// Add bet texfields:
    static let team1 = DefaultsKey<String>("team1")
    static let team2 = DefaultsKey<String>("team2")
    static let amount = DefaultsKey<String>("amount")
    static let odds = DefaultsKey<String>("odds")
    static let tax = DefaultsKey<String>("tax")
    static let league = DefaultsKey<String>("league")
    static let selectedDate = DefaultsKey<Date>("selectedDate")
    
    static let betslipName = DefaultsKey<String>("betslipName")
    static let betslipAmount = DefaultsKey<String>("betslipAmount")
    static let betslipOdds = DefaultsKey<String>("betslipOdds")
    static let betslipTax = DefaultsKey<String>("betslipTax")
    /// UserPreferences:
    static let username = DefaultsKey<String>("username")
    static let isDefaultTaxOn = DefaultsKey<Bool>("isDefaultTaxOn")
    static let defaultTax = DefaultsKey<String>("defaultTax")
    static let defaultCurrency = DefaultsKey<String>("defaultCurrency")
}

public protocol Defaultable {
    associatedtype Value
    static var defaultValue: Value { get }
}

extension String: Defaultable {
    public static var defaultValue: String { "" }
}

extension Date: Defaultable {
    public static var defaultValue: Date { Date() }
}

extension Bool: Defaultable {
    public static var defaultValue: Bool { false }
}
