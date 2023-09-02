import Foundation

final class UserDefaultsManager {
    static let path = UserDefaults.standard
    var value: String

    init(_ value: String) {
        self.value = value
    }

    // MARK: Global variables from UserDefaults:

    static var defaultCurrencyValue = "PLN"

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
    static let savedNotificationDate = DefaultsKey<Date>("savedNotificationDate")
    static let isNotificationSaved = DefaultsKey<Bool>("isNotificationSaved")

    /// UserPreferences:
    static let username = DefaultsKey<String>("username")
    static let isDefaultTaxOn = DefaultsKey<Bool>("isDefaultTaxOn")
    static let defaultTax = DefaultsKey<String>("defaultTax")
    static let defaultCurrency = DefaultsKey<String>("defaultCurrency")
}

// MARK: UserDefaults methods

extension UserDefaults {

    func get<T: Defaultable>(_ key: DefaultsKey<T>) -> T.Value {
        object(forKey: key.value) as? T.Value ?? T.defaultValue
    }

    func set<T>(_ key: DefaultsKey<T>, to value: T) {
        set(value, forKey: key.value)
    }
}

extension String: Defaultable {
    public static var defaultValue: String { "" }
}

extension Date: Defaultable {
    public static var defaultValue: Date { Date() }
}

extension Bool: Defaultable {
    public static var defaultValue: Bool = false
}

public protocol Defaultable {
    associatedtype Value
    static var defaultValue: Value { get }
}
