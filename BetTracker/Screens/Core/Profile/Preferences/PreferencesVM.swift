import Combine
import Foundation
import SwiftUI
import UIKit

class PreferencesVM: ObservableObject {

    let defaults = UserDefaultsManager.path

    let repository: Repository

    @Published
    var username = "" {
        didSet {
            if username != oldValue {
                let cleanedName = filterInput(
                    input: username,
                    oldValue: oldValue,
                    filterType: .name
                )
                if cleanedName != username {
                    username = cleanedName
                }
            }
        }
    }

    @Published
    var isTaxTextfieldOn: Bool = false

    @Published
    var defaultTax = "" {
        didSet {
            let cleanedTax = filterInput(
                input: defaultTax,
                oldValue: oldValue,
                filterType: .tax
            )
            if cleanedTax != defaultTax {
                defaultTax = cleanedTax
            }
        }
    }

    @Published
    var taxStatus = DefaultTax.taxUnsaved

    @Published
    var defaultCurrency: Currency = Currency.eur

    @Published
    var isDefaultTaxOn: Bool = false

    @Published
    var historyMerged: [BetWrapper]? = []

    @Published
    private var cancellables = Set<AnyCancellable>()

    init(repository: Repository) {
        self.repository = repository
        
        loadSavedPreferences()
    }

    func saveTaxSettings() {
        if isTaxTextfieldOn, defaultTax.isEmpty {
            defaults.set(.isDefaultTaxOn, to: true)
            defaults.set(.defaultTax, to: "")
        } else if isTaxTextfieldOn, !defaultTax.isEmpty {
            defaults.set(.isDefaultTaxOn, to: true)
            defaults.set(.defaultTax, to: defaultTax)
        } else if !isTaxTextfieldOn {
            defaults.set(.isDefaultTaxOn, to: false)
            defaults.set(.defaultTax, to: "")
        }
    }

    func savePreferences() {
        defaults.set(.username, to: username)
        defaults.set(.defaultCurrency, to: defaultCurrency.rawValue)
    }

    func loadSavedPreferences() {
        username = defaults.get(.username)
        isDefaultTaxOn = defaults.get(.isDefaultTaxOn)
        defaultTax = defaults.get(.defaultTax)
        defaultCurrency = Currency(
            rawValue: UserDefaults.standard
                .string(forKey: "defaultCurrency") ?? "eur"
        )!

        if isDefaultTaxOn == true {
            isTaxTextfieldOn = true
        }
    }

    func exportToCSV() {
        getBetsData {
            self.generateCSVDataAndSave()
        }
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
        var savedBets: [BetWrapper] = historyMerged!

        var csvText =
            "id,date,team1,team2,name,amount,isWon,selectedTeam,odds,category,tax,profit,note,score\n"

        for bets in savedBets {
            let id = bets.id
            let date = bets.date.description
            let team1 = bets.team1 ?? "N/A"
            let team2 = bets.team2 ?? "N/A"
            let name = bets.name ?? "N/A"
            let amount = bets.amount.stringValue
            let isWon = bets.isWon.map { $0 ? "True" : "False" } ?? "N/A"
            let selectedTeam = bets.selectedTeam
                .map { $0 == .team1 ? "team1" : "team2" } ?? "N/A"
            let odds = bets.odds.stringValue
            let category = String(
                describing: bets
                    .category
            )
            let tax = bets.tax.stringValue
            let profit = bets.profit.stringValue
            let note = bets.note ?? "N/A"
            let score = bets.score?.stringValue ?? "N/A"

            let newLine =
                "\(id),\(date),\(team1),\(team2),\(name),\(amount),\(isWon),\(selectedTeam),\(odds),\(category),\(tax),\(profit),\(note),\(score)\n"
            csvText.append(contentsOf: newLine)
        }

        do {
            let fileManager = FileManager.default
            let documentDirectory = try fileManager.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            )

            let fileName = "BetsHistory"
            let currentDate = Date().description

            let finalfileName = fileName.appending(currentDate)
            let fileURL = documentDirectory.appendingPathComponent("\(finalfileName).csv")

            try csvText.write(to: fileURL, atomically: true, encoding: .utf8)

            print("CSV file saved successfully!")
            print("CSV file saved at path: \(fileURL.path)")

        } catch {
            print("Failed to write CSV file: \(error)")
        }
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    private func filterInput(
        input: String,
        oldValue: String,
        filterType: FilterType
    ) -> String {
        if input.isEmpty {
            return input
        }
        var cleanedInput = input
            .replacingOccurrences(of: ",", with: ".")

        switch filterType {
        case .tax:
            if input.first == "0" {
                return "0"
            }
            if cleanedInput
                .wholeMatch(of: /[0-9][0-9]{0,3}?((\.|,)[0-9]{,2})?/) ==
                nil {
                cleanedInput = oldValue
            }
        case .name:
            if input.first == " " {
                return ""
            }
            let regex = try? NSRegularExpression(pattern: "[ ]+", options: .caseInsensitive)
            cleanedInput = regex?.stringByReplacingMatches(
                in: cleanedInput,
                options: [],
                range: NSRange(
                    location: 0,
                    length: cleanedInput.count
                ),
                withTemplate: " "
            ) ?? cleanedInput

            if cleanedInput.wholeMatch(of: /^[\p{L}0-9 ]{1,24}$/) == nil {
                cleanedInput = oldValue
            }
        }

        return cleanedInput
    }

    enum DefaultTax {
        case taxSaved
        case taxUnsaved
    }

    private enum FilterType {
        case tax
        case name
    }

}
