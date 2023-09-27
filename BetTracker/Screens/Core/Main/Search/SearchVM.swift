import Combine
import Foundation

class SearchVM: ObservableObject {

    let defaults = UserDefaultsManager.path
    var repository: Repository

    var defaultCurrency: Currency = .usd

    let sortOptions: [SortOption] = [.all, .oldest, .won, .lost, .amount]

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

    @Published
    private var cancellables = Set<AnyCancellable>()

    init(repository: Repository) {
        self.repository = repository

        loadCurrency()

        repository.getSavedBets(model: BetModel.self)
            .map { .some($0) }
            .assign(to: &$bets)

        repository.getSavedBets(model: BetslipModel.self)
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

    private func loadCurrency() {
        defaultCurrency = Currency(rawValue: defaults.get(.defaultCurrency)) ?? .usd
    }

    enum SortOption: String, CaseIterable, Identifiable {
        case all
        case oldest
        case won
        case lost
        case amount

        var id: String { rawValue }
    }

}
