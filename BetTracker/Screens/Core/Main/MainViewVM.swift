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
    var savedBets: [BetModel]? = []

    @Published
    var isSearchClicked: Bool = false

    @Published
    var getBetsAmountCancellables = Set<AnyCancellable>()

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
        BetDao.getPendingBets()
            .map { .some($0) }
            .assign(to: &$pendingBets)

        BetDao.getHistoryBets()
            .map { .some($0) }
            .assign(to: &$historyBets)

        BetDao.getSavedBets()
            .map { .some($0) }
            .assign(to: &$savedBets)
    }

}
