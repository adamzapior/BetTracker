import Foundation

class BetDetailsVM: ObservableObject {
    @Published
    var isShowingAlert = false
    
    var currency = UserDefaults.standard.object(forKey: "defaultCurrency") as? String ?? ""

    func deleteBet(bet: BetModel) {
        BetDao.deleteBet(bet: bet)
    }
    
    // Predicted profit of bet
    func betProfit(bet: BetModel) -> NSDecimalNumber {
        let amount = bet.amount
        let odds = bet.odds
        let tax = bet.tax.dividing(by: 100)
        
        let taxCorrected = NSDecimalNumber(value: 1).subtracting(tax)

        let predictedWin = amount
            .multiplying(by: odds)
            .multiplying(by: taxCorrected)
        print(predictedWin)
        return predictedWin
    }
}
