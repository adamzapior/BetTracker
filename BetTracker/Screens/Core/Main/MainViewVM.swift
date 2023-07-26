import Combine
import Foundation
import GRDB
import SwiftDate

class MainViewVM: ObservableObject {

    @Published
    var pendingBets: [BetModel]? = []

    @Published
    var historyBets: [BetModel]? = []

    @Published
    var betslipHistory: [BetslipModel]? = []

    @Published
    var mergedBets: [BetWrapper]? = []

    @Published
    var savedBets: [BetModel]? = []

    @Published
    var isSearchClicked: Bool = false

    @Published
    var getBetsAmountCancellables = Set<AnyCancellable>()
    
    @Published
    private var cancellables = Set<AnyCancellable>()

    let bet: [BetModel] = [
        BetModel(
            id: Int64(),
            date: Date(),
            team1: "test1",
            team2: "test2",
            selectedTeam: .team1,
            league: "",
            amount: 0.00,
            odds: 1,
            category: .football,
            tax: 1,
            profit: 24,
            isWon: nil,
            betNotificationID: "",
            score: 24
        )
    ]

    var currency = UserDefaultsManager.defaultCurrencyValue

    init() {
        getMerged()

        BetDao.getPendingBets()
            .map { .some($0) }
            .assign(to: &$pendingBets)

        BetDao.getHistoryBets()
            .map { .some($0) }
            .assign(to: &$historyBets)

        BetDao.getSavedBets()
            .map { .some($0) }
            .assign(to: &$savedBets)
        
        BetDao.getBetslipBets()
            .map { .some($0) }
            .assign(to: &$betslipHistory)
        
    }
    
    func getMerged() {
        Publishers.CombineLatest($historyBets, $betslipHistory)
                    .map { historyBets, betslipHistory -> [BetWrapper] in
                        let combinedBets = (historyBets?.map(BetWrapper.bet) ?? []) + (betslipHistory?.map(BetWrapper.betslip) ?? [])
                        return combinedBets.sorted(by: { $0.date > $1.date }) // Sort in descending order of date.
                    }
                    .assign(to: \.mergedBets, on: self)
                    .store(in: &cancellables)
    }
}
