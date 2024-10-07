import Combine
import Foundation
import GRDB
import LifetimeTracker

final class FeedViewModel: ObservableObject {
    @Injected(\.repository) var repository
    @Injected(\.userDefaults) var userDefaults

    var defaultCurrency: Currency = .usd

    @Published var pendingBets: [BetModel]? = []
    @Published var pendingBetslipBets: [BetslipModel]? = []
    @Published var pendingMerged: [BetWrapper]? = []
    @Published var historyBets: [BetModel]? = []
    @Published var betslipHistory: [BetslipModel]? = []
    @Published var historyMerged: [BetWrapper]? = []

    var isPendingMergedCompleted = false
    var isHistoryMergedCompleted = false

    @Published private var cancellables = Set<AnyCancellable>()

    init() {
        loadUserDefaultsData()
        fetchData()
        observeData()

        #if DEBUG
        trackLifetime()
        #endif
    }

    // MARK: Private

    private func fetchData() {
        repository.getPendingBets(model: BetModel.self, tableName: TableName.bet.rawValue)
            .map { .some($0) }
            .assign(to: &$pendingBets)

        repository.getPendingBets(model: BetslipModel.self, tableName: TableName.betslip.rawValue)
            .map { .some($0) }
            .assign(to: &$pendingBetslipBets)

        repository.getHistoryBets(model: BetModel.self, tableName: TableName.bet.rawValue)
            .map { .some($0) }
            .assign(to: &$historyBets)

        repository.getHistoryBets(model: BetslipModel.self, tableName: TableName.betslip.rawValue)
            .map { .some($0) }
            .assign(to: &$betslipHistory)
    }

    private func observeData() {
        Publishers.CombineLatest($pendingBets, $pendingBetslipBets)
            .map { historyBets, betslipHistory -> [BetWrapper] in
                let combinedBets = (historyBets?.map(BetWrapper.bet) ?? []) +
                    (betslipHistory?.map(BetWrapper.betslip) ?? [])
                return combinedBets.sorted(by: { $0.date > $1.date })
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                guard let vm = self else {
                    return
                }
                vm.pendingMerged = value
                vm.isPendingMergedCompleted = true
            })
            .store(in: &cancellables)

        Publishers.CombineLatest($historyBets, $betslipHistory)
            .map { historyBets, betslipHistory -> [BetWrapper] in
                let combinedBets = (historyBets?.map(BetWrapper.bet) ?? []) +
                    (betslipHistory?.map(BetWrapper.betslip) ?? [])
                return combinedBets.sorted(by: { $0.date > $1.date })
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                guard let vm = self else {
                    return
                }
                vm.historyMerged = value
                vm.isHistoryMergedCompleted = true
            })
            .store(in: &cancellables)
    }

    private func loadUserDefaultsData() {
        defaultCurrency = Currency(rawValue: userDefaults.getValue(for: .defaultCurrency)) ?? .eur
    }
}

extension FeedViewModel: LifetimeTrackable {
    class var lifetimeConfiguration: LifetimeConfiguration {
        return LifetimeConfiguration(maxCount: 1, groupName: "ViewModels")
    }
}
