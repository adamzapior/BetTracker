import Foundation

class SearchVM: ObservableObject {

    @Published
    var bets: [BetModel]? = []

    @Published
    private(set) var searchResults: [BetModel]? = nil

    @Published
    var searchText: String = ""

    @Published
    var selectedSortOption: SortOption = .all
    let sortOptions: [SortOption] = [.all, .oldest, .won, .lost, .amount]

    var currency: Currency = .usd
    init() {
        $searchText
            .combineLatest($bets)
            .map { searchText, bets in
                bets?.filter { bets in
                    if searchText.isEmpty {
                        return true
                    }

                    let team1 = bets.team1
                    let team2 = bets.team2

                    return team1.localizedStandardContains(searchText) ||
                        team2.localizedStandardContains(searchText)
                }
            }
            .assign(to: &$searchResults)

        BetDao.getSavedBets()
            .map {
                .some($0)
            }
            .assign(to: &$bets)
        
        loadCurrency()
    }

    // MARK: Sorting logic

    enum SortOption: String, CaseIterable, Identifiable {
        case all
        case oldest
        case won
        case lost
        case amount

        var id: String { rawValue }
    }

    // MARK: Database GET methods:

    func getSavedBets() {
        BetDao.getSavedBets()
            .map { .some($0) }
            .assign(to: &$bets)
    }

    func getBetsFormTheOldestDate() {
        BetDao.getBetsFormTheOldestDate()
            .map { .some($0) }
            .assign(to: &$bets)
    }

    func getWonBets() {
        BetDao.getWonBets()
            .map { .some($0) }
            .assign(to: &$bets)
    }

    func getLostBets() {
        BetDao.getLostBets()
            .map { .some($0) }
            .assign(to: &$bets)
    }

    func getBetsByAmount() {
        BetDao.getBetsByHiggestAmount()
            .map { .some($0) }
            .assign(to: &$bets)
    }

    func loadCurrency() {
        currency = UserDefaults.standard.object(forKey: currency.self.rawValue) as! Currency
    }

}
