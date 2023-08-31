import Combine
import Foundation
import GRDB
import SwiftDate

final class MainViewVM: ObservableObject {

    private let defaults = UserDefaultsManager.path
    private let respository: MainInteractor
    
    var defaultCurrency: Currency = Currency.usd

    private enum TableName: String, CaseIterable {
        case bet
        case betslip
    }

    @Published
    var username = String()
    
    @Published
    var showUsername = false
    
    @Published
    var pendingBets: [BetModel]? = []
    
    @Published
    var pendingBetslipBets: [BetslipModel]? = []
    
    @Published
    var pendingMerged: [BetWrapper]? = []
    
    @Published
    var historyBets: [BetModel]? = []
    
    @Published
    var betslipHistory: [BetslipModel]? = []
    
    @Published
    var historyMerged: [BetWrapper]? = []
    
    @Published
    var mergedBets: [BetWrapper]? = []
    
    @Published
    var isMergedCompleted = false
    
    @Published
    var isSearchClicked = false
    
    @Published
    private var cancellables = Set<AnyCancellable>()


    init(respository: MainInteractor) {
        self.respository = respository

        loadUserDefaultsData()
        showUsername = !username.isEmpty
        
        respository.getPendingBets(model: BetModel.self, tableName: TableName.bet.rawValue)
            .map { .some($0) }
            .assign(to: &$pendingBets)

        respository.getPendingBets(model: BetslipModel.self, tableName: TableName.betslip.rawValue)
            .map { .some($0) }
            .assign(to: &$pendingBetslipBets)
        
        respository.getHistoryBets(model: BetModel.self, tableName: TableName.bet.rawValue)
            .map { .some($0) }
            .assign(to: &$historyBets)

        respository.getHistoryBets(model: BetslipModel.self, tableName: TableName.betslip.rawValue)
            .map { .some($0) }
            .assign(to: &$betslipHistory)
        
        Publishers.CombineLatest($pendingBets, $pendingBetslipBets)
            .map { historyBets, betslipHistory -> [BetWrapper] in
                let combinedBets = (historyBets?.map(BetWrapper.bet) ?? []) +
                    (betslipHistory?.map(BetWrapper.betslip) ?? [])
                return combinedBets.sorted(by: { $0.date > $1.date })
            }
            .assign(to: \.pendingMerged, on: self)
            .store(in: &cancellables)


        Publishers.CombineLatest($historyBets, $betslipHistory)
            .map { historyBets, betslipHistory -> [BetWrapper] in
                let combinedBets = (historyBets?.map(BetWrapper.bet) ?? []) +
                    (betslipHistory?.map(BetWrapper.betslip) ?? [])
                return combinedBets.sorted(by: { $0.date > $1.date })
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                guard let vm = self else { return }
                vm.mergedBets = value
                vm.isMergedCompleted = true
            })
            .store(in: &cancellables)
        

    }

    private func loadUserDefaultsData() {
        username = defaults.get(.username)
        defaultCurrency = Currency(rawValue: defaults.get(.defaultCurrency)) ?? .usd
    }
}
