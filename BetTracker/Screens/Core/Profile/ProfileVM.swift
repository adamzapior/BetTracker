import Combine
import CoreTransferable
import PhotosUI
import SwiftUI

@MainActor
class ProfileVM: ObservableObject {

    @Published
    var isShowingPreferences = false

    @Published
    var allBetsAmount: NSDecimalNumber = .zero
    @Published
    var getBetsAmountCancellables = Set<AnyCancellable>()

    init() {
        getBetsAmount()
        print("\(isShowingPreferences)")
    }

    // MARK: - Querries to DB for values stored in @Published variables.

    func getBetsAmount() {
        BetDao.allBetsAmount()
            .sink(
                receiveCompletion: { completion in
                    print("getLostBetsSum(): Sink completed with \(completion)")
                },
                receiveValue: { sum in
                    print("getLostBetsSum(): Sink received value: \(sum)")
                    self.allBetsAmount = sum
                }
            )
            .store(in: &getBetsAmountCancellables)
    }

    // MARK: - Stats calaculation metods:

    func betProfit(
        amountString: String?,
        oddsString: String?,
        taxString: String?
    ) -> Decimal? {
        guard let amountString, !amountString.isEmpty,
              let oddsString, !oddsString.isEmpty,
              let taxString, !taxString.isEmpty
        else {
            print("One or more input values is null or empty")
            return nil
        }

        let amount = Decimal(string: amountString) ?? Decimal()
        let odds = Decimal(string: oddsString) ?? Decimal()
        let tax = Decimal(string: taxString) ?? Decimal()

        let taxCorrected = 1.0 - tax / 100
        print(taxCorrected)

        let predictedWin = amount * odds * taxCorrected
        print(predictedWin)
        return predictedWin
    }
}
