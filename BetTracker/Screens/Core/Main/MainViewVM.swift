import Foundation

class MainViewVM: ObservableObject {

    @Published
    var pendingBets: [BetModel]? = []

    @Published
    var historyBets: [BetModel]? = []

    @Published
    var savedBets: [BetModel]? = []

    @Published
    var isSearchClicked: Bool = false

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
            category: "",
            tax: 1,
            profit: "24",
            isWon: nil
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

        print(savedBets as Any)
    }

}
