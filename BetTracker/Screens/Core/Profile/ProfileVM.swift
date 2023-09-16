import Combine
import CoreTransferable
import PhotosUI
import SwiftUI

@MainActor
class ProfileVM: ObservableObject {

    private let defaults = UserDefaultsManager.path
    private let respository: Respository

    var defaultCurrency: String = "USD"
    var username: String = ""

    /// TODO:
    var wonRate: Double {
        0 // to fix
//        let score = 0
//        if lostBetsCount != 0 {
//            Double(truncating: wonBetsCount.dividing(by: lostBetsCount))
//        }
    }

    @Published
    var currentStatsState: StatsState = .week

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
    var isLoading: Bool = true

    @Published
    var cancellables = Set<AnyCancellable>()

    deinit {
        print("VM is out")
    }

    init(respository: Respository) {
        self.respository = respository

        loadUserDefaultsData()

        $currentStatsState
            .flatMap { state in
                let startDate = self.startDate(state: state)
                return Publishers.CombineLatest(
                    respository.getBalanceValue(
                        model: BetModel.self,
                        tableName: TableName.bet.rawValue,
                        startDate: startDate
                    ),
                    respository.getBalanceValue(
                        model: BetslipModel.self,
                        tableName: TableName.betslip.rawValue,
                        startDate: startDate
                    )
                )
                .map { $0.adding($1) as NSDecimalNumber? }
            }
            .sink { [weak self] newValue in
                self?.mergedBalanceValue = newValue
                self?.isLoading = false
            }
            .store(in: &cancellables)

        $currentStatsState
            .flatMap { state in
                let startDate = self.startDate(state: state)
                return Publishers.CombineLatest(
                    respository.getTotalSpent(
                        model: BetModel.self,
                        tableName: TableName.bet.rawValue,
                        startDate: startDate
                    ),
                    respository.getTotalSpent(
                        model: BetslipModel.self,
                        tableName: TableName.betslip.rawValue,
                        startDate: startDate
                    )
                )
                .map { $0.adding($1) as NSDecimalNumber? }
            }
            .assign(to: &$mergedTotalSpent)

        $currentStatsState
            .flatMap { state in
                let startDate = self.startDate(state: state)
                return Publishers.CombineLatest(
                    respository.getBetsCount(
                        model: BetModel.self,
                        tableName: TableName.bet.rawValue,
                        startDate: startDate,
                        isWon: true
                    ),
                    respository.getBetsCount(
                        model: BetslipModel.self,
                        tableName: TableName.betslip.rawValue,
                        startDate: startDate,
                        isWon: true
                    )
                )
                .map { $0.adding($1) as NSDecimalNumber? }
            }
            .assign(to: &$mergedWonBetsCount)

        $currentStatsState
            .flatMap { state in
                let startDate = self.startDate(state: state)
                return Publishers.CombineLatest(
                    respository.getBetsCount(
                        model: BetModel.self,
                        tableName: TableName.bet.rawValue,
                        startDate: startDate,
                        isWon: false
                    ),
                    respository.getBetsCount(
                        model: BetslipModel.self,
                        tableName: TableName.betslip.rawValue,
                        startDate: startDate,
                        isWon: false
                    )
                )
                .map { $0.adding($1) as NSDecimalNumber? }
            }
            .assign(to: &$mergedLostBetsCount)

        $currentStatsState
            .flatMap { state in
                let startDate = self.startDate(state: state)
                return Publishers.CombineLatest(
                    respository.getPendingBetsCount(
                        model: BetModel.self,
                        tableName: TableName.bet.rawValue,
                        startDate: startDate
                    ),
                    respository.getPendingBetsCount(
                        model: BetslipModel.self,
                        tableName: TableName.betslip.rawValue,
                        startDate: startDate
                    )
                )
                .map { $0.adding($1) as NSDecimalNumber? }
            }
            .assign(to: &$mergedPendingBetsCount)

        $currentStatsState
            .flatMap { state in
                let startDate = self.startDate(state: state)
                return Publishers.CombineLatest(
                    respository.getAvgWonBet(
                        model: BetModel.self,
                        tableName: TableName.bet.rawValue,
                        startDate: startDate,
                        isWon: true
                    ),
                    respository.getAvgWonBet(
                        model: BetslipModel.self,
                        tableName: TableName.betslip.rawValue,
                        startDate: startDate,
                        isWon: true
                    )
                )
                .map { $0.adding($1) as NSDecimalNumber? }
            }
            .assign(to: &$mergedAvgWonBet)

        $currentStatsState
            .flatMap { state in
                let startDate = self.startDate(state: state)
                return Publishers.CombineLatest(
                    respository.getAvgWonBet(
                        model: BetModel.self,
                        tableName: TableName.bet.rawValue,
                        startDate: startDate,
                        isWon: false
                    ),
                    respository.getAvgWonBet(
                        model: BetslipModel.self,
                        tableName: TableName.betslip.rawValue,
                        startDate: startDate,
                        isWon: false
                    )
                )
                .map { $0.adding($1) as NSDecimalNumber? }
            }
            .assign(to: &$mergedAvgLostBet)

        $currentStatsState
            .flatMap { state in
                let startDate = self.startDate(state: state)
                return Publishers.CombineLatest(
                    respository.getAvgWonBet(
                        model: BetModel.self,
                        tableName: TableName.bet.rawValue,
                        startDate: startDate,
                        isWon: false
                    ),
                    respository.getAvgWonBet(
                        model: BetslipModel.self,
                        tableName: TableName.betslip.rawValue,
                        startDate: startDate,
                        isWon: false
                    )
                )
                .map { $0.adding($1) as NSDecimalNumber? }
            }
            .assign(to: &$mergedAvgLostBet)

        $currentStatsState
            .flatMap { state in
                let startDate = self.startDate(state: state)
                return Publishers.CombineLatest(
                    respository.getAvgAmountBet(
                        model: BetModel.self,
                        tableName: TableName.bet.rawValue,
                        startDate: startDate
                    ),
                    respository.getAvgAmountBet(
                        model: BetslipModel.self,
                        tableName: TableName.betslip.rawValue,
                        startDate: startDate
                    )
                )
                .map { $0.adding($1) as NSDecimalNumber? }
            }
            .assign(to: &$mergedAvgAmountBet)

        $currentStatsState
            .flatMap { state in
                let startDate = self.startDate(state: state)
                return Publishers.CombineLatest(
                    respository.getLargestBetProfit(
                        model: BetModel.self,
                        tableName: TableName.bet.rawValue,
                        startDate: startDate
                    ),
                    respository.getLargestBetProfit(
                        model: BetslipModel.self,
                        tableName: TableName.betslip.rawValue,
                        startDate: startDate
                    )
                )
                .map { $0.adding($1) as NSDecimalNumber? }
            }
            .assign(to: &$mergedLargestBetProfit)

        $currentStatsState
            .flatMap { state in
                let startDate = self.startDate(state: state)
                return Publishers.CombineLatest(
                    respository.getBiggestBetLoss(
                        model: BetModel.self,
                        tableName: TableName.bet.rawValue,
                        startDate: startDate
                    ),
                    respository.getBiggestBetLoss(
                        model: BetslipModel.self,
                        tableName: TableName.betslip.rawValue,
                        startDate: startDate
                    )
                )
                .map { $0.adding($1) as NSDecimalNumber? }
            }
            .assign(to: &$mergedBiggestBetLoss)

        $currentStatsState
            .flatMap { state in
                let startDate = self.startDate(state: state)
                return Publishers.CombineLatest(
                    respository.getHiggestBetOddsWon(
                        model: BetModel.self,
                        tableName: TableName.bet.rawValue,
                        startDate: startDate
                    ),
                    respository.getHiggestBetOddsWon(
                        model: BetslipModel.self,
                        tableName: TableName.betslip.rawValue,
                        startDate: startDate
                    )
                )
                .map { $0.adding($1) as NSDecimalNumber? }
            }
            .assign(to: &$mergedHiggestBetOddsWon)

        $currentStatsState
            .flatMap { state in
                let startDate = self.startDate(state: state)
                return Publishers.CombineLatest(
                    respository.getHighestBetAmount(
                        model: BetModel.self,
                        tableName: TableName.bet.rawValue,
                        startDate: startDate
                    ),
                    respository.getHighestBetAmount(
                        model: BetslipModel.self,
                        tableName: TableName.betslip.rawValue,
                        startDate: startDate
                    )
                )
                .map { $0.adding($1) as NSDecimalNumber? }
            }
            .assign(to: &$mergedHiggestBetAmount)
    }

    private func loadUserDefaultsData() {
        username = defaults.get(.username)
        defaultCurrency = defaults.get(.defaultCurrency)
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
