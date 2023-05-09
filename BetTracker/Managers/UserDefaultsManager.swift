import Foundation

final class UserDefaultsManager {
    static let path = UserDefaults.standard
    let userDefaults: UserDefaults?
    var value: String

    init(_ value: String) {
        userDefaults = UserDefaults.standard
        self.value = value
    }

    // MARK: Global variables from UserDefaults:

    static var defaultCurrencyValue = path.get(.defaultCurrency)

    // MARK: - Keys used to store value
}

class DefaultsKeys {}

final class DefaultsKey<T>: DefaultsKeys {
    let value: String

    init(_ value: String) {
        self.value = value
    }
}

extension UserDefaults {
    
//    enum defaultValue: String, Date {
//        case string = ""
//        case Date = Date.now()
//    }
//
//    func get<T>(_ key: DefaultsKey<T>) -> T? {
//        return object(forKey: key.value) as? T ?? T.defaultValue
//    }

    
    
    func set<T>(_ key: DefaultsKey<T>, to value: T) {
        set(value, forKey: key.value)
    }
}

extension DefaultsKeys {
    static let hasSeenOnboarding = DefaultsKey<Bool>("hasSeenOnboarding")
    static let team1 = DefaultsKey<String>("team1")
    static let team2 = DefaultsKey<String>("team2")
    static let amount = DefaultsKey<String>("amount")
    static let odds = DefaultsKey<String>("odds")
    static let tax = DefaultsKey<String>("tax")
    static let category = DefaultsKey<String>("category")
    static let league = DefaultsKey<String>("league")
    static let selectedDate = DefaultsKey<Date>("selectedDate")
    static let username = DefaultsKey<String>("username")
    static let defaultCurrency = DefaultsKey<String>("defaultCurrency")
    static let defaultTax = DefaultsKey<String>("defaultTax")
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

extension UserDefaults {
    func get<T: Defaultable>(_ key: DefaultsKey<T>) -> T.Value {
        return object(forKey: key.value) as? T.Value ?? T.defaultValue
    }
}
