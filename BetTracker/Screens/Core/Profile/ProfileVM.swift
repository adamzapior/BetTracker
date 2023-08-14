import Combine
import CoreTransferable
import PhotosUI
import SwiftUI

@MainActor
class ProfileVM: ObservableObject {

    let defaults = UserDefaultsManager.path

    let respository: MainInteractor

    @Published
    var defaultCurrency: String = "USD"

    @Published
    var defaultUsername: String = ""

    @Published
    var currentStatsState: StatsState = .alltime

    @Published
    var cancellables = Set<AnyCancellable>()

    @Published
    var mergedBalanceValue: NSDecimalNumber = .zero

    @Published
    var mergedTotalSpent: NSDecimalNumber = .zero

    @Published
    var mergedWonBetsCount: NSDecimalNumber = .zero

    @Published
    var mergedLostBetsCount: NSDecimalNumber = .zero

    @Published
    var mergedPendingBetsCount: NSDecimalNumber = .zero

    var wonRate: Double {
        0 // to fix
//        let score = 0
//        if lostBetsCount != 0 {
//            Double(truncating: wonBetsCount.dividing(by: lostBetsCount))
//        }
    }

    @Published
    var mergedAvgWonBet: NSDecimalNumber = .zero

    @Published
    var mergedAvgLostBet: NSDecimalNumber = .zero

    @Published
    var mergedAvgAmountBet: NSDecimalNumber = .zero

    @Published
    var mergedLargestBetProfit: NSDecimalNumber = .zero

    @Published
    var mergedBiggestBetLoss: NSDecimalNumber = .zero

    @Published
    var mergedHiggestBetOddsWon: NSDecimalNumber = .zero

    @Published
    var mergedHiggestBetAmount: NSDecimalNumber = .zero

    let currentDate = Date()
    let calendar = Calendar.current

    init(respository: MainInteractor) {
        self.respository = respository

        getDefaultCurrency() // default preferences
        getDefaultUsername()

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
                .map { $0.adding($1) }
            }
            .assign(to: &$mergedBalanceValue)

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
                .map { $0.adding($1) }
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
                .map { $0.adding($1) }
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
                .map { $0.adding($1) }
            }
            .assign(to: &$mergedLostBetsCount)

        $currentStatsState
            .flatMap { state in
                let startDate = self.startDate(state: state)
                return Publishers.CombineLatest(
                    respository.getBetsCount(
                        model: BetModel.self,
                        tableName: TableName.bet.rawValue,
                        startDate: startDate,
                        isWon: nil
                    ),
                    respository.getBetsCount(
                        model: BetslipModel.self,
                        tableName: TableName.betslip.rawValue,
                        startDate: startDate,
                        isWon: nil
                    )
                )
                .map { $0.adding($1) }
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
                .map { $0.adding($1) }
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
                .map { $0.adding($1) }
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
                .map { $0.adding($1) }
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
                .map { betValue, betslipValue -> NSDecimalNumber in
                    betValue.adding(betslipValue)
                }
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
                .map { $0.adding($1) }
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
                .map { $0.adding($1) }
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
                .map { $0.adding($1) }
            }
            .assign(to: &$mergedHiggestBetOddsWon)

        $currentStatsState
            .flatMap { state in
                let startDate = self.startDate(state: state)
                return Publishers.CombineLatest(
                    respository.getHiggestBetAmount(
                        model: BetModel.self,
                        tableName: TableName.bet.rawValue,
                        startDate: startDate
                    ),
                    respository.getHiggestBetAmount(
                        model: BetslipModel.self,
                        tableName: TableName.betslip.rawValue,
                        startDate: startDate
                    )
                )
                .map { $0.adding($1) }
            }
            .assign(to: &$mergedHiggestBetAmount)
    }

//    deinit {
//        vmProfilePhoto.saveImageIfNeeded()
//    }

    func startDate(state: StatsState) -> Date {
        let startDate: Date
        switch state {
        case .week: startDate = StartDate.last7days.dateValue!
        case .month: startDate = StartDate.lastMonth.dateValue!
        case .year: startDate = StartDate.lastYear.dateValue!
        case .alltime: startDate = StartDate.allTime.dateValue!
        }
        return startDate
    }

    // MARK: - fetchData methods.

    enum TableName: String, CaseIterable {
        case bet
        case betslip
    }

    enum StartDate {
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

    // MARK: - ??:

    func getDefaultCurrency() {
        let currency = UserDefaults.standard.string(forKey: "defaultCurrency")
        defaultCurrency = currency ?? ""
    }

    func getDefaultUsername() {
        let username = UserDefaults.standard.string(forKey: "username")
        defaultUsername = username ?? ""
    }

}

enum StatsState: String, CaseIterable, Identifiable {
    var id: String { rawValue }

    case week = "Last week"
    case month = "Last month"
    case year = "Last year"
    case alltime = "All time"
}
