import Combine
import Foundation
import LifetimeTracker
import SwiftUI

class PreferencesViewModel: ObservableObject {
    @Injected(\.repository) private var repository
    @Injected(\.userDefaults) private var userDefaults

    @Published var username: String = ""
    @Published var defaultTax: String = ""

    @Published var isTaxTextfieldOn = false
    @Published var defaultCurrency: Currency = .eur
    @Published private(set) var historyMerged: [BetWrapper] = []

    private var cancellables = Set<AnyCancellable>()

    init() {
        loadSavedPreferences()
        #if DEBUG
        trackLifetime()
        #endif
    }

    // MARK: - Public methods

    func filterNameInput(_ input: String) -> String {
        let trimmedInput = input.trimmingCharacters(in: .whitespaces)
        let regex = try! NSRegularExpression(pattern: "^[\\p{L}0-9 ]{1,24}$")
        let range = NSRange(location: 0, length: trimmedInput.utf16.count)

        if regex.firstMatch(in: trimmedInput, options: [], range: range) != nil {
            return trimmedInput.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        } else {
            let validCharacters = trimmedInput.prefix { char in
                char.isLetter || char.isNumber || char == " "
            }
            let truncated = String(validCharacters.prefix(24))
            return truncated.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        }
    }

    func filterTaxInput(_ input: String) -> String {
        let sanitizedInput = input.replacingOccurrences(of: ",", with: ".")
        let regex = try! NSRegularExpression(pattern: "^\\d{1,2}([.]\\d{0,2})?$")
        let range = NSRange(location: 0, length: sanitizedInput.utf16.count)

        if regex.firstMatch(in: sanitizedInput, options: [], range: range) != nil {
            return sanitizedInput
        } else {
            var validPrefix = ""
            for char in sanitizedInput {
                let testString = validPrefix + String(char)
                let testRange = NSRange(location: 0, length: testString.utf16.count)
                if regex.firstMatch(in: testString, options: [], range: testRange) != nil {
                    validPrefix = testString
                } else {
                    break
                }
            }
            return validPrefix
        }
    }

    func savePreferences() {
        userDefaults.setValue(username, for: .username)
        userDefaults.setValue(defaultCurrency.rawValue, for: .defaultCurrency)
        saveTaxSettings()
    }

    func loadSavedPreferences() {
        username = userDefaults.getValue(for: .username)
        defaultTax = userDefaults.getValue(for: .defaultTax)
        isTaxTextfieldOn = userDefaults.getValue(for: .isDefaultTaxOn)

        if let currencyString = UserDefaults.standard.string(forKey: "defaultCurrency"),
           let currency = Currency(rawValue: currencyString)
        {
            defaultCurrency = currency
        }
    }

    func exportToCSV() {
        getBetsData { [weak self] in
            self?.generateCSVDataAndSave()
        }
    }

    // MARK: - Private methods

    private func saveTaxSettings() {
        userDefaults.setValue(isTaxTextfieldOn, for: .isDefaultTaxOn)
        userDefaults.setValue(isTaxTextfieldOn ? defaultTax : "", for: .defaultTax)
    }

    private func getBetsData(completion: @escaping () -> Void) {
        let historyBetsPublisher = repository.getHistoryBets(model: BetModel.self, tableName: TableName.bet.rawValue)
        let betslipHistoryPublisher = repository.getHistoryBets(model: BetslipModel.self, tableName: TableName.betslip.rawValue)

        Publishers.Zip(historyBetsPublisher, betslipHistoryPublisher)
            .map { historyBets, betslipHistory -> [BetWrapper] in
                let combinedBets = (historyBets.map(BetWrapper.bet)) + (betslipHistory.map(BetWrapper.betslip))
                return combinedBets.sorted(by: { $0.date > $1.date })
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completionStatus in
                switch completionStatus {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: publishers zip error", error)
                }
            }, receiveValue: { [weak self] value in
                self?.historyMerged = value
                completion()
            })
            .store(in: &cancellables)
    }

    private func generateCSVDataAndSave() {
        let csvText = generateCSVText()
        saveCSVFile(csvText)
    }

    private func generateCSVText() -> String {
        let header = "id,date,team1,team2,name,amount,isWon,selectedTeam,odds,category,tax,profit,note,score\n"
        let rows = historyMerged.map { bet in
            [
                bet.id,
                bet.date.description,
                bet.team1 ?? "N/A",
                bet.team2 ?? "N/A",
                bet.name ?? "N/A",
                bet.amount.stringValue,
                bet.isWon.map { $0 ? "True" : "False" } ?? "N/A",
                bet.selectedTeam.map { $0 == .team1 ? "team1" : "team2" } ?? "N/A",
                bet.odds.stringValue,
                String(describing: bet.category),
                bet.tax.stringValue,
                bet.profit.stringValue,
                bet.note ?? "N/A",
                bet.score?.stringValue ?? "N/A"
            ].joined(separator: ",")
        }.joined(separator: "\n")

        return header + rows
    }

    private func saveCSVFile(_ csvText: String) {
        do {
            let fileURL = try getCSVFileURL()
            try csvText.write(to: fileURL, atomically: true, encoding: .utf8)
            print("CSV file saved successfully at path: \(fileURL.path)")
        } catch {
            print("Failed to write CSV file: \(error)")
        }
    }

    private func getCSVFileURL() throws -> URL {
        let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileName = "BetsHistory\(Date().description).csv"
        return documentDirectory.appendingPathComponent(fileName)
    }
}

extension PreferencesViewModel: LifetimeTrackable {
    static var lifetimeConfiguration: LifetimeConfiguration {
        LifetimeConfiguration(maxCount: 1, groupName: "ViewModels")
    }
}

private enum PreferencesFilterType {
    case tax
    case name
}
