import Combine
import CoreTransferable
import LifetimeTracker
import PhotosUI
import SwiftUI

@MainActor
class ProfileVM: ObservableObject {
    @Injected(\.repository) var repository

    private let defaults = UserDefaultsManager.path

    @Published
    var defaultCurrency: Currency = .eur

    @Published
    var username: String = ""

    @Published
    var currentStatsState: StatsState = .month

    @Published
    var mergedBalanceValue: NSDecimalNumber? = nil
    @Published
    var mergedTotalSpent: NSDecimalNumber? = nil
    @Published
    var mergedWonBetsCount: NSDecimalNumber? = nil
    @Published
    var mergedLostBetsCount: NSDecimalNumber? = nil
    @Published
    var mergedPendingBetsCount: NSDecimalNumber? = nil
    @Published
    var mergedAvgWonBet: NSDecimalNumber? = nil
    @Published
    var mergedAvgLostBet: NSDecimalNumber? = nil
    @Published
    var mergedAvgAmountBet: NSDecimalNumber? = nil
    @Published
    var mergedLargestBetProfit: NSDecimalNumber? = nil
    @Published
    var mergedBiggestBetLoss: NSDecimalNumber? = nil
    @Published
    var mergedHiggestBetOddsWon: NSDecimalNumber? = nil
    @Published
    var mergedHiggestBetAmount: NSDecimalNumber? = nil

    @Published
    var wonRate: NSDecimalNumber? = nil

    @Published
    var isLoading: Bool = true

    @Published
    var cancellables = Set<AnyCancellable>()

    init() {
        loadUserDefaultsData()

        $currentStatsState
            .flatMap { [weak self] state -> AnyPublisher<NSDecimalNumber?, Never> in
                guard let self = self else { return Just(nil).eraseToAnyPublisher() }
                let startDate = self.startDate(state: state)
                return Publishers.CombineLatest(
                    self.repository.getBalanceValue(
                        model: BetModel.self,
                        tableName: TableName.bet.rawValue,
                        startDate: startDate
                    ),
                    self.repository.getBalanceValue(
                        model: BetslipModel.self,
                        tableName: TableName.betslip.rawValue,
                        startDate: startDate
                    )
                )
                .map { $0.adding($1) as NSDecimalNumber? }
                .eraseToAnyPublisher()
            }
            .sink { [weak self] newValue in
                self?.mergedBalanceValue = newValue
                self?.isLoading = false
            }
            .store(in: &cancellables)

        $currentStatsState
            .flatMap { [weak self] state -> AnyPublisher<NSDecimalNumber?, Never> in
                guard let self = self else { return Just(nil).eraseToAnyPublisher() }
                let startDate = self.startDate(state: state)
                return Publishers.CombineLatest(
                    self.repository.getTotalSpent(
                        model: BetModel.self,
                        tableName: TableName.bet.rawValue,
                        startDate: startDate
                    ),
                    self.repository.getTotalSpent(
                        model: BetslipModel.self,
                        tableName: TableName.betslip.rawValue,
                        startDate: startDate
                    )
                )
                .map { $0.adding($1) as NSDecimalNumber? }
                .eraseToAnyPublisher()
            }
            .sink { [weak self] newValue in
                self?.mergedTotalSpent = newValue
                self?.isLoading = false
            }
            .store(in: &cancellables)

        $currentStatsState
            .flatMap { [weak self] state -> AnyPublisher<NSDecimalNumber?, Never> in
                guard let self = self else { return Just(nil).eraseToAnyPublisher() }
                let startDate = self.startDate(state: state)
                return Publishers.CombineLatest(
                    self.repository.getBetsCount(
                        model: BetModel.self,
                        tableName: TableName.bet.rawValue,
                        startDate: startDate,
                        isWon: true
                    ),
                    self.repository.getBetsCount(
                        model: BetslipModel.self,
                        tableName: TableName.betslip.rawValue,
                        startDate: startDate,
                        isWon: true
                    )
                )
                .map { $0.adding($1) as NSDecimalNumber? }
                .eraseToAnyPublisher()
            }
            .sink { [weak self] newValue in
                self?.mergedWonBetsCount = newValue
                self?.isLoading = false
            }
            .store(in: &cancellables)

        $currentStatsState
            .flatMap { [weak self] state -> AnyPublisher<NSDecimalNumber?, Never> in
                guard let self = self else { return Just(nil).eraseToAnyPublisher() }
                let startDate = self.startDate(state: state)
                return Publishers.CombineLatest(
                    self.repository.getBetsCount(
                        model: BetModel.self,
                        tableName: TableName.bet.rawValue,
                        startDate: startDate,
                        isWon: false
                    ),
                    self.repository.getBetsCount(
                        model: BetslipModel.self,
                        tableName: TableName.betslip.rawValue,
                        startDate: startDate,
                        isWon: false
                    )
                )
                .map { $0.adding($1) as NSDecimalNumber? }
                .eraseToAnyPublisher()
            }
            .sink { [weak self] newValue in
                self?.mergedLostBetsCount = newValue
                self?.isLoading = false
            }
            .store(in: &cancellables)

        $currentStatsState
            .flatMap { [weak self] state -> AnyPublisher<NSDecimalNumber?, Never> in
                guard let self = self else { return Just(nil).eraseToAnyPublisher() }
                let startDate = self.startDate(state: state)
                return Publishers.CombineLatest(
                    self.repository.getPendingBetsCount(
                        model: BetModel.self,
                        tableName: TableName.bet.rawValue,
                        startDate: startDate
                    ),
                    self.repository.getPendingBetsCount(
                        model: BetslipModel.self,
                        tableName: TableName.betslip.rawValue,
                        startDate: startDate
                    )
                )
                .map { $0.adding($1) as NSDecimalNumber? }
                .eraseToAnyPublisher()
            }
            .sink { [weak self] newValue in
                self?.mergedPendingBetsCount = newValue
                self?.isLoading = false
            }
            .store(in: &cancellables)

        $currentStatsState
            .flatMap { [weak self] state -> AnyPublisher<NSDecimalNumber?, Never> in
                guard let self = self else { return Just(nil).eraseToAnyPublisher() }
                let startDate = self.startDate(state: state)
                return Publishers.CombineLatest(
                    self.repository.getAvgWonBet(
                        model: BetModel.self,
                        tableName: TableName.bet.rawValue,
                        startDate: startDate,
                        isWon: true
                    ),
                    self.repository.getAvgWonBet(
                        model: BetslipModel.self,
                        tableName: TableName.betslip.rawValue,
                        startDate: startDate,
                        isWon: true
                    )
                )
                .map { $0.adding($1) as NSDecimalNumber? }
                .eraseToAnyPublisher()
            }
            .sink { [weak self] newValue in
                self?.mergedAvgWonBet = newValue
                self?.isLoading = false
            }
            .store(in: &cancellables)

        $currentStatsState
            .flatMap { [weak self] state -> AnyPublisher<NSDecimalNumber?, Never> in
                guard let self = self else { return Just(nil).eraseToAnyPublisher() }
                let startDate = self.startDate(state: state)
                return Publishers.CombineLatest(
                    self.repository.getAvgWonBet(
                        model: BetModel.self,
                        tableName: TableName.bet.rawValue,
                        startDate: startDate,
                        isWon: false
                    ),
                    self.repository.getAvgWonBet(
                        model: BetslipModel.self,
                        tableName: TableName.betslip.rawValue,
                        startDate: startDate,
                        isWon: false
                    )
                )
                .map { $0.adding($1) as NSDecimalNumber? }
                .eraseToAnyPublisher()
            }
            .sink { [weak self] newValue in
                self?.mergedAvgLostBet = newValue
                self?.isLoading = false
            }
            .store(in: &cancellables)

        $currentStatsState
            .flatMap { [weak self] state -> AnyPublisher<NSDecimalNumber?, Never> in
                guard let self = self else { return Just(nil).eraseToAnyPublisher() }
                let startDate = self.startDate(state: state)
                return Publishers.CombineLatest(
                    self.repository.getAvgAmountBet(
                        model: BetModel.self,
                        tableName: TableName.bet.rawValue,
                        startDate: startDate
                    ),
                    self.repository.getAvgAmountBet(
                        model: BetslipModel.self,
                        tableName: TableName.betslip.rawValue,
                        startDate: startDate
                    )
                )
                .map { $0.adding($1) as NSDecimalNumber? }
                .eraseToAnyPublisher()
            }
            .sink { [weak self] newValue in
                self?.mergedAvgAmountBet = newValue
                self?.isLoading = false
            }
            .store(in: &cancellables)

        $currentStatsState
            .flatMap { [weak self] state -> AnyPublisher<NSDecimalNumber?, Never> in
                guard let self = self else { return Just(nil).eraseToAnyPublisher() }
                let startDate = self.startDate(state: state)
                return Publishers.CombineLatest(
                    self.repository.getLargestBetProfit(
                        model: BetModel.self,
                        tableName: TableName.bet.rawValue,
                        startDate: startDate
                    ),
                    self.repository.getLargestBetProfit(
                        model: BetslipModel.self,
                        tableName: TableName.betslip.rawValue,
                        startDate: startDate
                    )
                )
                .map { $0.adding($1) as NSDecimalNumber? }
                .eraseToAnyPublisher()
            }
            .sink { [weak self] newValue in
                self?.mergedLargestBetProfit = newValue
                self?.isLoading = false
            }
            .store(in: &cancellables)

        $currentStatsState
            .flatMap { [weak self] state -> AnyPublisher<NSDecimalNumber?, Never> in
                guard let self = self else { return Just(nil).eraseToAnyPublisher() }
                let startDate = self.startDate(state: state)
                return Publishers.CombineLatest(
                    self.repository.getBiggestBetLoss(
                        model: BetModel.self,
                        tableName: TableName.bet.rawValue,
                        startDate: startDate
                    ),
                    self.repository.getBiggestBetLoss(
                        model: BetslipModel.self,
                        tableName: TableName.betslip.rawValue,
                        startDate: startDate
                    )
                )
                .map { $0.adding($1) as NSDecimalNumber? }
                .eraseToAnyPublisher()
            }
            .sink { [weak self] newValue in
                self?.mergedBiggestBetLoss = newValue
                self?.isLoading = false
            }
            .store(in: &cancellables)

        $currentStatsState
            .flatMap { [weak self] state -> AnyPublisher<NSDecimalNumber?, Never> in
                guard let self = self else { return Just(nil).eraseToAnyPublisher() }
                let startDate = self.startDate(state: state)
                return Publishers.CombineLatest(
                    self.repository.getHiggestBetOddsWon(
                        model: BetModel.self,
                        tableName: TableName.bet.rawValue,
                        startDate: startDate
                    ),
                    self.repository.getHiggestBetOddsWon(
                        model: BetslipModel.self,
                        tableName: TableName.betslip.rawValue,
                        startDate: startDate
                    )
                )
                .map { $0.adding($1) as NSDecimalNumber? }
                .eraseToAnyPublisher()
            }
            .sink { [weak self] newValue in
                self?.mergedHiggestBetOddsWon = newValue
                self?.isLoading = false
            }
            .store(in: &cancellables)

        $currentStatsState
            .flatMap { [weak self] state -> AnyPublisher<NSDecimalNumber?, Never> in
                guard let self = self else { return Just(nil).eraseToAnyPublisher() }
                let startDate = self.startDate(state: state)
                return Publishers.CombineLatest(
                    self.repository.getHighestBetAmount(
                        model: BetModel.self,
                        tableName: TableName.bet.rawValue,
                        startDate: startDate
                    ),
                    self.repository.getHighestBetAmount(
                        model: BetslipModel.self,
                        tableName: TableName.betslip.rawValue,
                        startDate: startDate
                    )
                )
                .map { $0.adding($1) as NSDecimalNumber? }
                .eraseToAnyPublisher()
            }
            .sink { [weak self] newValue in
                self?.mergedHiggestBetAmount = newValue
                self?.isLoading = false
            }
            .store(in: &cancellables)
        
        Publishers.CombineLatest($mergedWonBetsCount, $mergedLostBetsCount)
            .map { [weak self] won, lost -> NSDecimalNumber in
                guard let self = self else { return NSDecimalNumber.zero }
                self.mergedWonBetsCount = won
                self.mergedLostBetsCount = lost
                return self.calculateWonRate(wonBets: won, lostBets: lost)
            }
            .sink { [weak self] newWonRate in
                self?.wonRate = newWonRate
            }
            .store(in: &cancellables)

        #if DEBUG
        trackLifetime()
        #endif
    }

    func loadUserDefaultsData() {
        username = defaults.get(.username)
        defaultCurrency = Currency(rawValue: defaults.get(.defaultCurrency)) ?? .eur
    }

    private func calculateWonRate(wonBets: NSDecimalNumber?, lostBets: NSDecimalNumber?) -> NSDecimalNumber {
        if let wonBets = wonBets, let lostBets = lostBets {
            if wonBets == NSDecimalNumber.zero, lostBets == NSDecimalNumber.zero {
                return NSDecimalNumber.zero
            }

            let totalBets = wonBets.adding(lostBets)
            let rate = wonBets.multiplying(by: NSDecimalNumber(value: 100)).dividing(by: totalBets)

            return rate
        }
        return NSDecimalNumber.zero
    }

    private func startDate(state: StatsState) -> Date {
        let startDate: Date
        switch state {
        case .week: startDate = StartDate.last7days.dateValue!
        case .month: startDate = StartDate.lastMonth.dateValue!
        case .year: startDate = StartDate.lastYear.dateValue!
        case .alltime: startDate = StartDate.allTime.dateValue!
        }
        return startDate
    }

    private enum TableName: String, CaseIterable {
        case bet
        case betslip
    }

    private enum StartDate {
        case last7days
        case lastMonth
        case lastYear
        case allTime

        var dateValue: Date? {
            let calendar = Calendar.current
            let currentDate = Date()
            switch self {
            case .last7days:
                return calendar.date(byAdding: .day, value: -7, to: currentDate)
            case .lastMonth:
                return calendar.date(byAdding: .month, value: -1, to: currentDate)
            case .lastYear:
                return calendar.date(byAdding: .year, value: -1, to: currentDate)
            case .allTime:
                return calendar.date(byAdding: .year, value: -30, to: currentDate)
            }
        }
    }
}

enum StatsState: String, CaseIterable, Identifiable {
    var id: String { rawValue }

    case week = "Last week"
    case month = "Last month"
    case year = "Last year"
    case alltime = "All time"
}

extension ProfileVM: LifetimeTrackable {
    class var lifetimeConfiguration: LifetimeConfiguration {
        return LifetimeConfiguration(maxCount: 1, groupName: "ViewModels")
    }
}
