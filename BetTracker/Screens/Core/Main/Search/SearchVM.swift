import Combine
import Foundation

class SearchVM: ObservableObject {

    let defaults = UserDefaultsManager.path
    let respository: SearchInteractor

    @Published
    var bets: [BetModel]? = []

    @Published
    var betslips: [BetslipModel]? = []

    @Published
    var savedBets: [BetWrapper]? = []

    @Published
    private(set) var searchResults: [BetWrapper]? = nil

    @Published
    private(set) var searchAllResults: [BetWrapper]? = nil

    @Published
    var searchText: String = ""

    @Published
    var selectedSortOption: SortOption = .all
    let sortOptions: [SortOption] = [.all, .oldest, .won, .lost, .amount]

    var currency: Currency = .usd

    @Published
    private var cancellables = Set<AnyCancellable>()

    init(interactor: SearchInteractor) {
        self.respository = interactor

        loadCurrency()
        getSavedBets()

        findBet()
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

    func findBet() {
        $searchText
            .combineLatest($savedBets)
            .map { searchText, bets in
                bets?.filter { bets in
                    if searchText.isEmpty {
                        return true
                    }

                    let matchTeam1 = bets.team1?.localizedStandardContains(searchText) ?? false
                    let matchTeam2 = bets.team2?.localizedStandardContains(searchText) ?? false
                    let matchName = bets.name?.localizedStandardContains(searchText) ?? false

                    return matchTeam1 || matchTeam2 || matchName
                }
            }
            .assign(to: &$searchResults)
    }

    // MARK: Database GET methods:

    func getSavedBets() {
        respository.getSavedBets(model: BetModel.self)
            .map { .some($0) }
            .assign(to: &$bets)

        respository.getSavedBets(model: BetslipModel.self)
            .map { .some($0) }
            .assign(to: &$betslips)

        Publishers.CombineLatest($bets, $betslips)
            .map { historyBets, betslipHistory -> [BetWrapper] in
                let combinedBets = (historyBets?.map(BetWrapper.bet) ?? []) +
                    (betslipHistory?.map(BetWrapper.betslip) ?? [])
                return combinedBets.sorted(by: { $0.date > $1.date })
            }
            .assign(to: \.savedBets, on: self)
            .store(in: &cancellables)
    }

    func allBets() {
        $savedBets
            .assign(to: \.searchResults, on: self)
            .store(in: &cancellables)
    }

    func getBetsFormTheOldestDate() {
        $savedBets
            .map { savedBets in
                savedBets?.sorted { $0.date.compare($1.date) == .orderedAscending }
            }
            .assign(to: \.searchResults, on: self)
            .store(in: &cancellables)
    }

    func getWonBets() {
        $savedBets
            .map { savedBets in
                savedBets?.filter { BetWrapper in
                    BetWrapper.isWon != nil && BetWrapper.isWon! == true
                }
            }
            .assign(to: \.searchResults, on: self)
            .store(in: &cancellables)
    }

    func getLostBets() {
        $savedBets
            .map { savedBets in
                savedBets?.filter { BetWrapper in
                    BetWrapper.isWon != nil && BetWrapper.isWon! == false
                }
            }
            .assign(to: \.searchResults, on: self)
            .store(in: &cancellables)
    }

    func getBetsByAmount() {
        $savedBets
            .map { savedBets in
                savedBets?.sorted { $0.amount.compare($1.amount) == .orderedDescending }
            }
            .assign(to: \.searchResults, on: self)
            .store(in: &cancellables)
    }

    func loadCurrency() {
        currency = Currency(rawValue: defaults.get(.defaultCurrency)) ?? .usd
    }

}

