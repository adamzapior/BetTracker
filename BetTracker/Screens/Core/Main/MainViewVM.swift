import Foundation

class MainViewVM: ObservableObject {

    @Published
    var pendingBets: [BetModel]? = []
    @Published
    var historyBets: [BetModel]? = []
    @Published
    var isSearchClicked: Bool = false

    var currency = UserDefaultsManager.defaultCurrencyValue

    init() {
        BetDao.getPendingBets()
            .map { .some($0) }
            .assign(to: &$pendingBets)

        BetDao.getHistoryBets()
            .map { .some($0) }
            .assign(to: &$historyBets)
    }
}
