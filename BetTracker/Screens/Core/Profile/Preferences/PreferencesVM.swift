import Combine
import Foundation
import SwiftUI
import UIKit

class PreferencesVM: ObservableObject {

    let defaults = UserDefaultsManager.path

    let respository = Respository()

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
    var taxStatus = DefaultTax.taxUnsaved

    @Published
    var defaultCurrency: Currency = Currency.usd

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

    init() {
        loadSavedPreferences()
    }

    func exportToCSV() {
        var betWrappers: [BetWrapper] = [
            .bet(BetModel(
                id: Int64(),
                date: Date.now,
                team1: "team1",
                team2: "team2",
                selectedTeam: SelectedTeam.team1,
                league: "",
                amount: 12,
                odds: 12,
                category: Category.f1,
                tax: 0,
                profit: 100,
                note: "",
                isWon: true,
                betNotificationID: "",
                score: 100
            ))
        ]

        // Define the CSV header
        var csvText = "id,date,team1,team2,name,amount,isWon\n"

        // Loop through the BetWrapper array to construct each row
        for betWrapper in betWrappers {
            let id = betWrapper.id
            let date = betWrapper.date.description
            let team1 = betWrapper.team1 ?? "N/A"
            let team2 = betWrapper.team2 ?? "N/A"
            let name = betWrapper.name ?? "N/A"
            let amount = betWrapper.amount.stringValue
            let isWon = betWrapper.isWon.map { $0 ? "True" : "False" } ?? "N/A"

            let newLine = "\(id),\(date),\(team1),\(team2),\(name),\(amount),\(isWon)\n"
            csvText.append(contentsOf: newLine)
        }

        // Write to a file (e.g., in the app's Documents directory)
        do {
            let fileManager = FileManager.default
            let documentDirectory = try fileManager.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            )
            
            let new = "myfile.csv"
            let fileURL = documentDirectory.appendingPathComponent("BetWrapperData.csv")
            let fileName = getDocumentsDirectory().appendingPathComponent("OutputD.csv")
            let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(new)
            
            
            

            try csvText.write(to: path!, atomically: true, encoding: .utf8)
            
            print("CSV file saved successfully!")
            print("CSV file saved at path: \(fileURL.path)")
            print("Number of elements in exampleData: \(betWrappers.count)")
            
            if FileManager.default.fileExists(atPath: fileURL.path) {
                  print("File exists.")
              } else {
                  print("File does not exist.")
              }
        } catch {
            print("Failed to write CSV file: \(error)")
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func taxSaved() {
        taxStatus = .taxSaved
    }

    func taxUnsaved() {
        taxStatus = .taxUnsaved
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
        defaults.set(.defaultCurrency, to: defaultCurrency.rawValue)
    }

    func loadSavedPreferences() {
        username = defaults.get(.username)
        isDefaultTaxOn = defaults.get(.isDefaultTaxOn)
        defaultTax = defaults.get(.defaultTax)
        defaultCurrency = Currency(
            rawValue: UserDefaults.standard
                .string(forKey: "defaultCurrency") ?? "usd"
        )!
    }

    enum DefaultTax {
        case taxSaved
        case taxUnsaved
    }

}
