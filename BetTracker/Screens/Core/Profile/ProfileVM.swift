import Combine
import CoreTransferable
import PhotosUI
import SwiftUI

@MainActor
class ProfileVM: ObservableObject {

    let defaults = UserDefaultsManager.path

    @Published
    var defaultCurrency: String = "USD"

    @Published
    var defaultUsername: String = ""

    @Published
    var currentStatsState: StatsState = .alltime {
        didSet {
            getBalanceValue()
            getTotalSpent()
            getWonBetsCount()
            getLostBetsCount()
            getPendingBetsCount()
            getAvgWonBet()
            getAvgLostBet()
            getAvgAmountBet()
            getLargestBetProfit()
            getBiggestBetLoss()
            getHiggestBetOddsWon()
            getHiggestBetAmount()
        }
    }

    @Published
    var cancellables = Set<AnyCancellable>()

    @Published
    var balanceValue: NSDecimalNumber = .zero

    @Published
    var totalSpent: NSDecimalNumber = .zero

    @Published
    var wonBetsCount: NSDecimalNumber = .zero

    @Published
    var lostBetsCount: NSDecimalNumber = .zero

    @Published
    var pendingBetsCount: NSDecimalNumber = .zero

    var wonRate: Double {
        0 // to fix
//        let score = 0
//        if lostBetsCount != 0 {
//            Double(truncating: wonBetsCount.dividing(by: lostBetsCount))
//        }
    }

    @Published
    var avgWonBet: NSDecimalNumber = .zero

    @Published
    var avgLostBet: NSDecimalNumber = .zero

    @Published
    var avgAmountBet: NSDecimalNumber = .zero

    @Published
    var largestBetProfit: NSDecimalNumber = .zero

    @Published
    var biggestBetLoss: NSDecimalNumber = .zero

    @Published
    var higgestBetOddsWon: NSDecimalNumber = .zero

    @Published
    var higgestBetAmount: NSDecimalNumber = .zero

    let currentDate = Date()
    let calendar = Calendar.current

    init() {
        getDefaultCurrency() // default preferences
        getDefaultUsername()

        getBalanceValue()
        getTotalSpent()
        getWonBetsCount()
        getLostBetsCount()
        getPendingBetsCount()
        getAvgWonBet()
        getAvgLostBet()
        getAvgAmountBet()
        getLargestBetProfit()
        getBiggestBetLoss()
        getHiggestBetOddsWon()
        getHiggestBetAmount()
    }

    // MARK: - Querries to DB for values stored in @Published variables.

    /// ** Balance Value **
    ///
    func getBalanceValue() {
        switch currentStatsState {
        case .week:
            BetDao.getLast7DaysBalanceValue()
                .sink(
                    receiveValue: { balance in
                        self.balanceValue = balance
                    }
                )
                .store(in: &cancellables)
        case .month:
            BetDao.getLastMonthBalanceValue()
                .sink(
                    receiveValue: { balance in
                        self.balanceValue = balance
                    }
                )
                .store(in: &cancellables)
        case .year:
            BetDao.getLastYearBalanceValue()
                .sink(
                    receiveValue: { balance in
                        self.balanceValue = balance
                    }
                )
                .store(in: &cancellables)
        case .alltime:
            BetDao.getBalanceValue()
                .sink(
                    receiveValue: { balance in
                        self.balanceValue = balance
                    }
                )
                .store(in: &cancellables)
        }
    }

    // ** Total Spent Values **

    func getTotalSpent() {
        switch currentStatsState {
        case .week:
            BetDao
                .getTotalSpentByPeroid(
                    startDate: calendar
                        .date(byAdding: .day, value: -7, to: currentDate)!
                )
                .sink(
                    receiveValue: { sum in
                        self.totalSpent = sum
                    }
                )
                .store(in: &cancellables)

        case .month:
            BetDao
                .getTotalSpentByPeroid(
                    startDate: calendar
                        .date(byAdding: .month, value: -1, to: currentDate)!
                )
                .sink(
                    receiveValue: { sum in
                        self.totalSpent = sum
                    }
                )
                .store(in: &cancellables)

        case .year:
            BetDao
                .getTotalSpentByPeroid(
                    startDate: calendar
                        .date(byAdding: .year, value: -1, to: currentDate)!
                )
                .sink(
                    receiveValue: { sum in
                        self.totalSpent = sum
                    }
                )
                .store(in: &cancellables)

        case .alltime:
            BetDao.getTotalSpent()
                .sink(
                    receiveValue: { sum in
                        self.totalSpent = sum
                    }
                )
                .store(in: &cancellables)
        }
    }

    // ** Won Bets Count **

    func getWonBetsCount() {
        switch currentStatsState {
        case .week:
            BetDao.getWonBetsCounyByPeroid(
                startDate: calendar
                    .date(byAdding: .day, value: -7, to: currentDate)!
            )
            .sink(
                receiveValue: { sum in
                    self.wonBetsCount = sum
                }
            )
            .store(in: &cancellables)

        case .month:
            BetDao.getWonBetsCounyByPeroid(
                startDate: calendar
                    .date(byAdding: .month, value: -1, to: currentDate)!
            )
            .sink(
                receiveValue: { sum in
                    self.wonBetsCount = sum
                }
            )
            .store(in: &cancellables)

        case .year:
            BetDao.getWonBetsCounyByPeroid(
                startDate: calendar
                    .date(byAdding: .year, value: -1, to: currentDate)!
            )
            .sink(
                receiveValue: { sum in
                    self.wonBetsCount = sum
                }
            )
            .store(in: &cancellables)

        case .alltime:
            BetDao.getWonBetsCount()
                .sink(
                    receiveValue: { sum in
                        self.wonBetsCount = sum
                    }
                )
                .store(in: &cancellables)
        }
    }

    // ** Lost Bets Count **

    func getLostBetsCount() {
        switch currentStatsState {
        case .week:
            BetDao.getLostBetsCountByPeroid(
                startDate: calendar
                    .date(byAdding: .day, value: -7, to: currentDate)!
            )
            .sink(
                receiveValue: { count in
                    self.lostBetsCount = count
                }
            )
            .store(in: &cancellables)
        case .month:
            BetDao.getLostBetsCountByPeroid(
                startDate: calendar
                    .date(byAdding: .month, value: -1, to: currentDate)!
            )
            .sink(
                receiveValue: { count in
                    self.lostBetsCount = count
                }
            )
            .store(in: &cancellables)
        case .year:
            BetDao.getLostBetsCountByPeroid(
                startDate: calendar
                    .date(byAdding: .year, value: -1, to: currentDate)!
            )
            .sink(
                receiveValue: { count in
                    self.lostBetsCount = count
                }
            )
            .store(in: &cancellables)
        case .alltime:
            BetDao.getLostBetsCount()
                .sink(
                    receiveValue: { count in
                        self.lostBetsCount = count
                    }
                )
                .store(in: &cancellables)
        }
    }

    // ** Pending Bets Count **

    func getPendingBetsCount() {
        BetDao.getPeningBetsCount()
            .sink(
                receiveValue: { count in
                    self.pendingBetsCount = count
                }
            )
            .store(in: &cancellables)
    }

    // ** Avg Won  Bets  **

    func getAvgWonBet() {
        switch currentStatsState {
        case .week:
            BetDao.getAvgWonBetByPeroid(
                startDate: calendar
                    .date(byAdding: .day, value: -7, to: currentDate)!
            )
            .sink(
                receiveValue: { avg in
                    self.avgWonBet = avg
                }
            )
            .store(in: &cancellables)
        case .month:
            BetDao.getAvgWonBetByPeroid(
                startDate: calendar
                    .date(byAdding: .month, value: -1, to: currentDate)!
            )
            .sink(
                receiveValue: { avg in
                    self.avgWonBet = avg
                }
            )
            .store(in: &cancellables)

        case .year:
            BetDao.getAvgWonBetByPeroid(
                startDate: calendar
                    .date(byAdding: .year, value: -1, to: currentDate)!
            )
            .sink(
                receiveValue: { avg in
                    self.avgWonBet = avg
                }
            )
            .store(in: &cancellables)
        case .alltime:
            BetDao.getAvgWonBet()
                .sink(
                    receiveValue: { avg in
                        self.avgWonBet = avg
                    }
                )
                .store(in: &cancellables)
        }
    }

    // ** Avg Lost Bets  **

    func getAvgLostBet() {
        switch currentStatsState {
        case .week:
            BetDao.getAvgLostBetByPeroid(
                startDate: calendar
                    .date(byAdding: .day, value: -7, to: currentDate)!
            )
            .sink(
                receiveValue: { avg in
                    self.avgAmountBet = avg
                }
            )
            .store(in: &cancellables)

        case .month:
            BetDao.getAvgLostBetByPeroid(
                startDate: calendar
                    .date(byAdding: .month, value: -1, to: currentDate)!
            )
            .sink(
                receiveValue: { avg in
                    self.avgAmountBet = avg
                }
            )
            .store(in: &cancellables)

        case .year:
            BetDao.getAvgLostBetByPeroid(
                startDate: calendar
                    .date(byAdding: .year, value: -1, to: currentDate)!
            )
            .sink(
                receiveValue: { avg in
                    self.avgAmountBet = avg
                }
            )
            .store(in: &cancellables)

        case .alltime:
            BetDao.getAvgLostBet()
                .sink(
                    receiveValue: { avg in
                        self.avgLostBet = avg
                    }
                )
                .store(in: &cancellables)
        }
    }

    // ** Avg Amount Bets  **

    func getAvgAmountBet() {
        switch currentStatsState {
        case .week:
            BetDao.getAvgAmountBetByPeroid(
                startDate: calendar
                    .date(byAdding: .day, value: -7, to: currentDate)!
            )
            .sink(
                receiveValue: { avg in
                    self.avgAmountBet = avg
                }
            )
            .store(in: &cancellables)

        case .month:
            BetDao.getAvgAmountBetByPeroid(
                startDate: calendar
                    .date(byAdding: .month, value: -1, to: currentDate)!
            )
            .sink(
                receiveValue: { avg in
                    self.avgAmountBet = avg
                }
            )
            .store(in: &cancellables)

        case .year:
            BetDao.getAvgAmountBetByPeroid(
                startDate: calendar
                    .date(byAdding: .year, value: -1, to: currentDate)!
            )
            .sink(
                receiveValue: { avg in
                    self.avgAmountBet = avg
                }
            )
            .store(in: &cancellables)

        case .alltime:
            BetDao.getAvgAmountBet()
                .sink(
                    receiveValue: { avg in
                        self.avgAmountBet = avg
                    }
                )
                .store(in: &cancellables)
        }
    }

    // ** Lergest Bet Profit**

    func getLargestBetProfit() {
        switch currentStatsState {
        case .week:
            BetDao.getLargestBetProfitByPeroid(
                startDate: calendar
                    .date(byAdding: .day, value: -7, to: currentDate)!
            )
            .sink(
                receiveValue: { largestBetProfit in
                    self.largestBetProfit = largestBetProfit
                }
            )
            .store(in: &cancellables)

        case .month:
            BetDao.getLargestBetProfitByPeroid(
                startDate: calendar
                    .date(byAdding: .month, value: -1, to: currentDate)!
            )
            .sink(
                receiveValue: { largestBetProfit in
                    self.largestBetProfit = largestBetProfit
                }
            )
            .store(in: &cancellables)

        case .year:
            BetDao.getLargestBetProfitByPeroid(
                startDate: calendar
                    .date(byAdding: .year, value: -1, to: currentDate)!
            )
            .sink(
                receiveValue: { largestBetProfit in
                    self.largestBetProfit = largestBetProfit
                }
            )
            .store(in: &cancellables)

        case .alltime:
            BetDao.getLargestBetProfit()
                .sink(
                    receiveValue: { largestBetProfit in
                        self.largestBetProfit = largestBetProfit
                    }
                )
                .store(in: &cancellables)
        }
    }

    // ** Biggest Bet Loss**

    func getBiggestBetLoss() {
        switch currentStatsState {
        case .week:
            BetDao.getBiggestBetLossByPeroid(
                startDate: calendar
                    .date(byAdding: .day, value: -7, to: currentDate)!
            )
            .sink(
                receiveValue: { biggestLoss in
                    self.biggestBetLoss = biggestLoss
                }
            )
            .store(in: &cancellables)

        case .month:
            BetDao.getBiggestBetLossByPeroid(
                startDate: calendar
                    .date(byAdding: .month, value: -1, to: currentDate)!
            )
            .sink(
                receiveValue: { biggestLoss in
                    self.biggestBetLoss = biggestLoss
                }
            )
            .store(in: &cancellables)

        case .year:
            BetDao.getBiggestBetLossByPeroid(
                startDate: calendar
                    .date(byAdding: .year, value: -1, to: currentDate)!
            )
            .sink(
                receiveValue: { biggestLoss in
                    self.biggestBetLoss = biggestLoss
                }
            )
            .store(in: &cancellables)

        case .alltime:
            BetDao.getBiggestBetLoss()
                .sink(
                    receiveValue: { biggestLoss in
                        self.biggestBetLoss = biggestLoss
                    }
                )
                .store(in: &cancellables)
        }
    }

    // ** Niggest Bet Won Odds**

    func getHiggestBetOddsWon() {
        switch currentStatsState {
        case .week:
            BetDao.getHiggestBetOddsWonByPeroid(
                startDate: calendar
                    .date(byAdding: .day, value: -7, to: currentDate)!
            )
            .sink(
                receiveValue: { higgestOds in
                    self.higgestBetOddsWon = higgestOds
                }
            )
            .store(in: &cancellables)

        case .month:
            BetDao.getHiggestBetOddsWonByPeroid(
                startDate: calendar
                    .date(byAdding: .month, value: -1, to: currentDate)!
            )
            .sink(
                receiveValue: { higgestOds in
                    self.higgestBetOddsWon = higgestOds
                }
            )
            .store(in: &cancellables)

        case .year:
            BetDao.getHiggestBetOddsWonByPeroid(
                startDate: calendar
                    .date(byAdding: .year, value: -1, to: currentDate)!
            )
            .sink(
                receiveValue: { higgestOds in
                    self.higgestBetOddsWon = higgestOds
                }
            )
            .store(in: &cancellables)

        case .alltime:
            BetDao.getHiggestBetOddsWon()
                .sink(
                    receiveValue: { higgestOds in
                        self.higgestBetOddsWon = higgestOds
                    }
                )
                .store(in: &cancellables)
        }
    }

    // ** Higgest Ammount **

    func getHiggestBetAmount() {
        switch currentStatsState {
        case .week:
            BetDao.getHiggestBetAmountByPeroid(
                startDate: calendar
                    .date(byAdding: .day, value: -7, to: currentDate)!
            )
            .sink(
                receiveValue: { higgestAmount in
                    self.higgestBetAmount = higgestAmount
                }
            )
            .store(in: &cancellables)
        case .month:
            BetDao.getHiggestBetAmountByPeroid(
                startDate: calendar
                    .date(byAdding: .month, value: -1, to: currentDate)!
            )
            .sink(
                receiveValue: { higgestAmount in
                    self.higgestBetAmount = higgestAmount
                }
            )
            .store(in: &cancellables)
        case .year:
            BetDao.getHiggestBetAmountByPeroid(
                startDate: calendar
                    .date(byAdding: .year, value: -1, to: currentDate)!
            )
            .sink(
                receiveValue: { higgestAmount in
                    self.higgestBetAmount = higgestAmount
                }
            )
            .store(in: &cancellables)
        case .alltime:
            BetDao.getHiggestBetAmount()
                .sink(
                    receiveValue: { higgestAmount in
                        self.higgestBetAmount = higgestAmount
                    }
                )
                .store(in: &cancellables)
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
