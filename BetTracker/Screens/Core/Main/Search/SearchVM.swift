import Foundation
import Combine


class SearchVM: ObservableObject {

    let interactor: SearchInteractor

    @Published
    var bets: [BetModel]? = []

    @Published
    var betslips: [BetslipModel]? = []
    
    @Published
    var savedBets: [BetWrapper]? = []

    @Published
    private(set) var searchResults: [BetModel]? = nil

    @Published
    var searchText: String = ""

    @Published
    var selectedSortOption: SortOption = .all
    let sortOptions: [SortOption] = [.all, .oldest, .won, .lost, .amount]

    var currency: Currency = .usd
    
    @Published
    private var cancellables = Set<AnyCancellable>()
    
    init(interactor: SearchInteractor) {
        self.interactor = interactor

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

        interactor.getSavedBets(model: BetModel.self)
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
        interactor.getSavedBets(model: BetModel.self)
            .map { .some($0) }
            .assign(to: &$bets)

        interactor.getSavedBets(model: BetslipModel.self)
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
    
//    func mapBets() {
//
//        Publishers.CombineLatest($savedBets)
//            .map { historyBets, betslipHistory -> [BetWrapper] in
//                let combinedBets = (historyBets?.map(BetWrapper.bet) ?? []) +
//                    (betslipHistory?.map(BetWrapper.betslip) ?? [])
//                return combinedBets.sorted(by: { $0.date > $1.date })
//            }
//            .assign(to: \.savedBets, on: self)
//            .store(in: &cancellables)
//    }
//
    
    
    
    

    func getBetsFormTheOldestDate() {
        
        $savedBets
            .map { savedBets in
                savedBets?.sorted { $0.amount.compare($1.amount) == .orderedDescending }
            }
            .assign(to: \.savedBets, on: self)
            .store(in: &cancellables)
            
        
        Publishers.CombineLatest($bets, $betslips)
            .map { historyBets, betslipHistory -> [BetWrapper] in
                let combinedBets = (historyBets?.map(BetWrapper.bet) ?? []) +
                    (betslipHistory?.map(BetWrapper.betslip) ?? [])
                return combinedBets.sorted(by: { $0.date > $1.date })
            }
            .assign(to: \.savedBets, on: self)
            .store(in: &cancellables)

        
        interactor.getBetsFormTheOldestDate(model: BetModel.self)
            .map { .some($0) }
            .assign(to: &$bets)
    }

    func getWonBets() {
        interactor.getWonBets(model: BetModel.self)
            .map { .some($0) }
            .assign(to: &$bets)
    }

    func getLostBets() {
        interactor.getLostBets(model: BetModel.self)
            .map { .some($0) }
            .assign(to: &$bets)
    }

    func getBetsByAmount() {
        interactor.getBetsByAmount(model: BetModel.self)
            .map { .some($0) }
            .assign(to: &$bets)
    }

    func loadCurrency() {
        currency = Currency(
            rawValue: UserDefaults.standard
                .string(forKey: "defaultCurrency") ?? "usd"
        )!
    }

}
