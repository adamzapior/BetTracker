import Combine
import Foundation
import GRDB
import LifetimeTracker

final class MainViewVM: ObservableObject {
    @Injected(\.repository) var repository

    private let defaults = UserDefaultsManager.path

    var defaultCurrency: Currency = .usd

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
    var isPendingMergedCompleted = false

    @Published
    var isHistoryMergedCompleted = false

    @Published
    var isSearchClicked = false

    @Published
    private var cancellables = Set<AnyCancellable>()

    init() {
        loadUserDefaultsData()
        showUsername = !username.isEmpty

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

        #if DEBUG
        trackLifetime()
        #endif
    }

    private func loadUserDefaultsData() {
        username = defaults.get(.username)
        defaultCurrency = Currency(rawValue: defaults.get(.defaultCurrency)) ?? .eur
    }
}

extension MainViewVM: LifetimeTrackable {
    class var lifetimeConfiguration: LifetimeConfiguration {
        return LifetimeConfiguration(maxCount: 1, groupName: "ViewModels")
    }
}
