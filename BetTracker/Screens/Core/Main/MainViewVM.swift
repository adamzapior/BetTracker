import Foundation

class MainViewVM: ObservableObject {

    @Published
    var pendingBets: [BetModel]? = []
    @Published
    var historyBets: [BetModel]? = []
    @Published
    var isSearchClicked: Bool = false

    var currency = UserDefaults.standard.object(forKey: "defaultCurrency") as? String ?? ""

    init() {
        BetDao.getPendingBets()
            .map { .some($0) }
            .assign(to: &$pendingBets)

        BetDao.getHistoryBets()
            .map { .some($0) }
            .assign(to: &$historyBets)
    }
}
