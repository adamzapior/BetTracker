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
    var betsBalanceValue: NSDecimalNumber = .zero
    @Published
    var betslipBalanceValue: NSDecimalNumber = .zero
    @Published
    var mergedBalanceValue: NSDecimalNumber = .zero

    @Published
    var betsTotalSpent: NSDecimalNumber = .zero
    @Published
    var betslipTotalSpent: NSDecimalNumber = .zero
    @Published
    var betsTotalSpentSubject = PassthroughSubject<NSDecimalNumber, Never>()
    @Published
    var betslipTotalSpentSubject = PassthroughSubject<NSDecimalNumber, Never>()
    @Published
    var mergedTotalSpent: NSDecimalNumber = .zero

    @Published
    var betsWonBetsCount: NSDecimalNumber = .zero
    @Published
    var betslipWonBetsCount: NSDecimalNumber = .zero
    @Published
    var mergedWonBetsCount: NSDecimalNumber = .zero

    @Published
    var betsLostBetsCount: NSDecimalNumber = .zero
    @Published
    var betslipLostBetsCount: NSDecimalNumber = .zero
    @Published
    var mergedLostBetsCount: NSDecimalNumber = .zero

    @Published
    var betsPendingBetsCount: NSDecimalNumber = .zero
    @Published
    var betslipPendingBetsCount: NSDecimalNumber = .zero
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
    var betsAvgWonBet: NSDecimalNumber = .zero
    @Published
    var betslipAvgWonBet: NSDecimalNumber = .zero
    @Published
    var mergedAvgWonBet: NSDecimalNumber = .zero

    @Published
    var betsAvgLostBet: NSDecimalNumber = .zero
    @Published
    var betslipAvgLostBet: NSDecimalNumber = .zero
    @Published
    var mergedAvgLostBet: NSDecimalNumber = .zero

    @Published
    var betsAvgAmountBet: NSDecimalNumber = .zero
    @Published
    var betslipAvgAmountBet: NSDecimalNumber = .zero
    @Published
    var mergedAvgAmountBet: NSDecimalNumber = .zero

    @Published
    var betsLargestBetProfit: NSDecimalNumber = .zero
    @Published
    var betslipLargestBetProfit: NSDecimalNumber = .zero
    @Published
    var mergedLargestBetProfit: NSDecimalNumber = .zero

    @Published
    var betsBiggestBetLoss: NSDecimalNumber = .zero
    @Published
    var betslipBiggestBetLoss: NSDecimalNumber = .zero
    @Published
    var mergedBiggestBetLoss: NSDecimalNumber = .zero

    @Published
    var betsHiggestBetOddsWon: NSDecimalNumber = .zero
    @Published
    var betslipHiggestBetOddsWon: NSDecimalNumber = .zero
    @Published
    var mergedHiggestBetOddsWon: NSDecimalNumber = .zero

    @Published
    var betsHiggestBetAmount: NSDecimalNumber = .zero
    @Published
    var betslipHiggestBetAmount: NSDecimalNumber = .zero
    @Published
    var mergedHiggestBetAmount: NSDecimalNumber = .zero


    let currentDate = Date()
    let calendar = Calendar.current

    init(respository: MainInteractor) {
        self.respository = respository
        
        getDefaultCurrency() // default preferences
        getDefaultUsername()

        fetchData()
    }

    // MARK: fetchData
    
    func fetchData() {
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

    func mergeValues(
        bet: NSDecimalNumber,
        betslip: NSDecimalNumber,
        resultKeyPath: ReferenceWritableKeyPath<ProfileVM, NSDecimalNumber>
    ) {
        Publishers.CombineLatest(Just(bet), Just(betslip))
            .map { betValue, betslipValue -> NSDecimalNumber in
                betValue.adding(betslipValue)
            }
            .assign(to: resultKeyPath, on: self)
            .store(in: &cancellables)
    }
    
    func mergeValues2(
        bet: NSDecimalNumber,
        betslip: NSDecimalNumber,
        resultKeyPath: ReferenceWritableKeyPath<ProfileVM, NSDecimalNumber>
    ) async {
        let result = bet.adding(betslip)
        self[keyPath: resultKeyPath] = result
    }

    /// ** Balance Value **
    ///
    func getBalanceValue() {
        switch currentStatsState {
        case .week:
            respository.getBalanceValue(
                model: BetModel.self,
                tableName: TableName.bet.rawValue,
                startDate: StartDate.last7days.dateValue!
            )
            .receive(on: DispatchQueue.main)
            .sink(
                receiveValue: { balance in
                    self.betsBalanceValue = balance
                }
            )
            .store(in: &cancellables)

            respository.getBalanceValue(
                model: BetslipModel.self,
                tableName: TableName.betslip.rawValue,
                startDate: StartDate.last7days.dateValue!
            )
            .receive(on: DispatchQueue.main)
            .sink(
                receiveValue: { balance in
                    self.betslipBalanceValue = balance
                }
            )
            .store(in: &cancellables)

            mergeValues(
                bet: betsBalanceValue,
                betslip: betslipBalanceValue,
                resultKeyPath: \.mergedBalanceValue
            )

        case .month:
            respository.getBalanceValue(
                model: BetModel.self,
                tableName: TableName.bet.rawValue,
                startDate: StartDate.lastMonth.dateValue!
            )
            .receive(on: DispatchQueue.main)
            .sink(
                receiveValue: { balance in
                    self.betsBalanceValue = balance
                }
            )
            .store(in: &cancellables)

            respository.getBalanceValue(
                model: BetslipModel.self,
                tableName: TableName.betslip.rawValue,
                startDate: StartDate.lastMonth.dateValue!
            )
            .receive(on: DispatchQueue.main)
            .sink(
                receiveValue: { balance in
                    self.betslipBalanceValue = balance
                }
            )
            .store(in: &cancellables)

            mergeValues(
                bet: betsBalanceValue,
                betslip: betslipBalanceValue,
                resultKeyPath: \.mergedBalanceValue
            )
        case .year:
            respository.getBalanceValue(
                model: BetModel.self,
                tableName: TableName.bet.rawValue,
                startDate: StartDate.lastYear.dateValue!
            )
            .receive(on: DispatchQueue.main)
            .sink(
                receiveValue: { balance in
                    self.betsBalanceValue = balance
                }
            )
            .store(in: &cancellables)

            respository.getBalanceValue(
                model: BetslipModel.self,
                tableName: TableName.betslip.rawValue,
                startDate: StartDate.lastYear.dateValue!
            )
            .receive(on: DispatchQueue.main)
            .sink(
                receiveValue: { balance in
                    self.betslipBalanceValue = balance
                }
            )
            .store(in: &cancellables)

            mergeValues(
                bet: betsBalanceValue,
                betslip: betslipBalanceValue,
                resultKeyPath: \.mergedBalanceValue
            )
        case .alltime:
            respository.getBalanceValue(
                model: BetModel.self,
                tableName: TableName.bet.rawValue,
                startDate: StartDate.allTime.dateValue!
            )
            .receive(on: DispatchQueue.main)
            .sink(
                receiveValue: { balance in
                    self.betsBalanceValue = balance
                }
            )
            .store(in: &cancellables)

            respository.getBalanceValue(
                model: BetslipModel.self,
                tableName: TableName.betslip.rawValue,
                startDate: StartDate.allTime.dateValue!
            )
            .receive(on: DispatchQueue.main)
            .sink(
                receiveValue: { balance in
                    self.betslipBalanceValue = balance
                }
            )
            .store(in: &cancellables)

            mergeValues(
                bet: betsBalanceValue,
                betslip: betslipBalanceValue,
                resultKeyPath: \.mergedBalanceValue
            )
        }
    }

    // ** Total Spent Values **

    func getTotalSpent() {
        switch currentStatsState {
        case .week:
            respository.getTotalSpent(
                    model: BetModel.self,
                    tableName: TableName.bet.rawValue,
                    startDate: StartDate.last7days.dateValue!
                )
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveValue: { [weak self] balance in
                        self?.betsTotalSpent = balance
                        self?.betsTotalSpentSubject.send(balance)
                    }
                )
                .store(in: &cancellables)

                //... W Twoim kodzie

                respository.getBalanceValue(
                    model: BetslipModel.self,
                    tableName: TableName.betslip.rawValue,
                    startDate: StartDate.last7days.dateValue!
                )
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveValue: { [weak self] balance in
                        self?.betslipTotalSpent = balance
                        self?.betslipTotalSpentSubject.send(balance)
                    }
                )
                .store(in: &cancellables)

                // Teraz łączymy oba strumienie i wywołujemy mergeValues tylko wtedy, gdy obie wartości są dostępne
                Publishers.CombineLatest(betsTotalSpentSubject, betslipTotalSpentSubject)
                    .sink { [weak self] (betValue, betslipValue) in
                        self?.mergeValues(
                            bet: betValue,
                            betslip: betslipValue,
                            resultKeyPath: \.mergedBalanceValue
                        )
                    }
                    .store(in: &cancellables)
//            mergeValues(
//                bet: betsTotalSpent,
//                betslip: betslipTotalSpent,
//                resultKeyPath: \.mergedTotalSpent
//            )

        case .month:
            respository.getTotalSpent(
                model: BetModel.self,
                tableName: TableName.bet.rawValue,
                startDate: StartDate.lastMonth.dateValue!
            )
            .receive(on: DispatchQueue.main)
            .sink(
                receiveValue: { balance in
                    self.betsTotalSpent = balance
                }
            )
            .store(in: &cancellables)

            respository.getTotalSpent(
                model: BetslipModel.self,
                tableName: TableName.betslip.rawValue,
                startDate: StartDate.lastMonth.dateValue!
            )
            .receive(on: DispatchQueue.main)
            .sink(
                receiveValue: { balance in
                    self.betslipTotalSpent = balance
                }
            )
            .store(in: &cancellables)

            
            
            Task {
                await mergeValues2(bet: betsTotalSpent, betslip: betslipTotalSpent, resultKeyPath: \.mergedTotalSpent)
            }
//            mergeValues(
//                bet: betsTotalSpent,
//                betslip: betslipTotalSpent,
//                resultKeyPath: \.mergedTotalSpent
//            )

        case .year:
            respository.getTotalSpent(
                model: BetModel.self,
                tableName: TableName.bet.rawValue,
                startDate: StartDate.lastYear.dateValue!
            )
            .receive(on: DispatchQueue.main)
            .sink(
                receiveValue: { balance in
                    self.betsTotalSpent = balance
                }
            )
            .store(in: &cancellables)

            respository.getTotalSpent(
                model: BetslipModel.self,
                tableName: TableName.betslip.rawValue,
                startDate: StartDate.lastYear.dateValue!
            )
            .receive(on: DispatchQueue.main)
            .sink(
                receiveValue: { balance in
                    self.betslipTotalSpent = balance
                }
            )
            .store(in: &cancellables)

            
            Task {
                await mergeValues2(bet: betsTotalSpent, betslip: betslipTotalSpent, resultKeyPath: \.mergedTotalSpent)
            }
//            mergeValues(
//                bet: betsTotalSpent,
//                betslip: betslipTotalSpent,
//                resultKeyPath: \.mergedTotalSpent
//            )

        case .alltime:
            respository.getTotalSpent(
                model: BetModel.self,
                tableName: TableName.bet.rawValue,
                startDate: StartDate.allTime.dateValue!
            )
            .receive(on: DispatchQueue.main)
            .sink(
                receiveValue: { balance in
                    self.betsTotalSpent = balance
                }
            )
            .store(in: &cancellables)

            respository.getTotalSpent(
                model: BetslipModel.self,
                tableName: TableName.betslip.rawValue,
                startDate: StartDate.allTime.dateValue!
            )
            .receive(on: DispatchQueue.main)
            .sink(
                receiveValue: { balance in
                    self.betslipTotalSpent = balance
                }
            )
            .store(in: &cancellables)

            
            
            Task {
                await mergeValues2(bet: betsTotalSpent, betslip: betslipTotalSpent, resultKeyPath: \.mergedTotalSpent)
            }
            
//            mergeValues(
//                bet: betsTotalSpent,
//                betslip: betslipTotalSpent,
//                resultKeyPath: \.mergedTotalSpent
//            )
        }
    }

    // ** Won Bets Count **

    func getWonBetsCount() {
        switch currentStatsState {
        case .week:
            respository.getBetsCount(
                model: BetModel.self,
                tableName: TableName.bet.rawValue,
                startDate: StartDate.last7days.dateValue!,
                isWon: true
            )
            .sink(
                receiveValue: { balance in
                    self.betsWonBetsCount = balance
                }
            )
            .store(in: &cancellables)

            respository.getBetsCount(
                model: BetslipModel.self,
                tableName: TableName.betslip.rawValue,
                startDate: StartDate.last7days.dateValue!,
                isWon: true
            )
            .sink(
                receiveValue: { balance in
                    self.betsWonBetsCount = balance
                }
            )
            .store(in: &cancellables)

            mergeValues(
                bet: betsWonBetsCount,
                betslip: betslipWonBetsCount,
                resultKeyPath: \.mergedWonBetsCount
            )

        case .month:
            respository.getBetsCount(
                model: BetModel.self,
                tableName: TableName.bet.rawValue,
                startDate: StartDate.lastMonth.dateValue!,
                isWon: true
            )
            .sink(
                receiveValue: { balance in
                    self.betsWonBetsCount = balance
                }
            )
            .store(in: &cancellables)

            respository.getBetsCount(
                model: BetslipModel.self,
                tableName: TableName.betslip.rawValue,
                startDate: StartDate.lastMonth.dateValue!,
                isWon: true
            )
            .sink(
                receiveValue: { balance in
                    self.betsWonBetsCount = balance
                }
            )
            .store(in: &cancellables)

            mergeValues(
                bet: betsWonBetsCount,
                betslip: betslipWonBetsCount,
                resultKeyPath: \.mergedWonBetsCount
            )

        case .year:
            respository.getBetsCount(
                model: BetModel.self,
                tableName: TableName.bet.rawValue,
                startDate: StartDate.lastYear.dateValue!,
                isWon: true
            )
            .sink(
                receiveValue: { balance in
                    self.betsWonBetsCount = balance
                }
            )
            .store(in: &cancellables)

            respository.getBetsCount(
                model: BetslipModel.self,
                tableName: TableName.betslip.rawValue,
                startDate: StartDate.lastYear.dateValue!,
                isWon: true
            )
            .sink(
                receiveValue: { balance in
                    self.betsWonBetsCount = balance
                }
            )
            .store(in: &cancellables)

            mergeValues(
                bet: betsWonBetsCount,
                betslip: betslipWonBetsCount,
                resultKeyPath: \.mergedWonBetsCount
            )

        case .alltime:
            respository.getBetsCount(
                model: BetModel.self,
                tableName: TableName.bet.rawValue,
                startDate: StartDate.allTime.dateValue!,
                isWon: true
            )
            .sink(
                receiveValue: { balance in
                    self.betsWonBetsCount = balance
                }
            )
            .store(in: &cancellables)

            respository.getBetsCount(
                model: BetslipModel.self,
                tableName: TableName.betslip.rawValue,
                startDate: StartDate.allTime.dateValue!,
                isWon: true
            )
            .sink(
                receiveValue: { balance in
                    self.betsWonBetsCount = balance
                }
            )
            .store(in: &cancellables)

            mergeValues(
                bet: betsWonBetsCount,
                betslip: betslipWonBetsCount,
                resultKeyPath: \.mergedWonBetsCount
            )
        }
    }

    // ** Lost Bets Count **

    func getLostBetsCount() {
        switch currentStatsState {
        case .week:
            respository.getBetsCount(
                model: BetModel.self,
                tableName: TableName.bet.rawValue,
                startDate: StartDate.last7days.dateValue!,
                isWon: false
            )
            .sink(
                receiveValue: { balance in
                    self.betsLostBetsCount = balance
                }
            )
            .store(in: &cancellables)

            respository.getBetsCount(
                model: BetslipModel.self,
                tableName: TableName.betslip.rawValue,
                startDate: StartDate.last7days.dateValue!,
                isWon: false
            )
            .sink(
                receiveValue: { balance in
                    self.betslipLostBetsCount = balance
                }
            )
            .store(in: &cancellables)

            mergeValues(
                bet: betsLostBetsCount,
                betslip: betslipLostBetsCount,
                resultKeyPath: \.mergedLostBetsCount
            )

        case .month:
            respository.getBetsCount(
                model: BetModel.self,
                tableName: TableName.bet.rawValue,
                startDate: StartDate.lastMonth.dateValue!,
                isWon: false
            )
            .sink(
                receiveValue: { balance in
                    self.betsLostBetsCount = balance
                }
            )
            .store(in: &cancellables)

            respository.getBetsCount(
                model: BetslipModel.self,
                tableName: TableName.betslip.rawValue,
                startDate: StartDate.lastMonth.dateValue!,
                isWon: false
            )
            .sink(
                receiveValue: { balance in
                    self.betslipLostBetsCount = balance
                }
            )
            .store(in: &cancellables)

            mergeValues(
                bet: betsLostBetsCount,
                betslip: betslipLostBetsCount,
                resultKeyPath: \.mergedLostBetsCount
            )
        case .year:
            respository.getBetsCount(
                model: BetModel.self,
                tableName: TableName.bet.rawValue,
                startDate: StartDate.lastYear.dateValue!,
                isWon: false
            )
            .sink(
                receiveValue: { balance in
                    self.betsLostBetsCount = balance
                }
            )
            .store(in: &cancellables)

            respository.getBetsCount(
                model: BetslipModel.self,
                tableName: TableName.betslip.rawValue,
                startDate: StartDate.lastYear.dateValue!,
                isWon: false
            )
            .sink(
                receiveValue: { balance in
                    self.betslipLostBetsCount = balance
                }
            )
            .store(in: &cancellables)

            mergeValues(
                bet: betsLostBetsCount,
                betslip: betslipLostBetsCount,
                resultKeyPath: \.mergedLostBetsCount
            )
        case .alltime:
            respository.getBetsCount(
                model: BetModel.self,
                tableName: TableName.bet.rawValue,
                startDate: StartDate.allTime.dateValue!,
                isWon: false
            )
            .sink(
                receiveValue: { balance in
                    self.betsLostBetsCount = balance
                }
            )
            .store(in: &cancellables)

            respository.getBetsCount(
                model: BetslipModel.self,
                tableName: TableName.betslip.rawValue,
                startDate: StartDate.allTime.dateValue!,
                isWon: false
            )
            .sink(
                receiveValue: { balance in
                    self.betslipLostBetsCount = balance
                }
            )
            .store(in: &cancellables)

            mergeValues(
                bet: betsLostBetsCount,
                betslip: betslipLostBetsCount,
                resultKeyPath: \.mergedLostBetsCount
            )
        }
    }

    // ** Pending Bets Count **

    func getPendingBetsCount() {
        respository.getBetsCount(
            model: BetModel.self,
            tableName: TableName.bet.rawValue,
            startDate: StartDate.allTime.dateValue!,
            isWon: nil
        )
        .sink(
            receiveValue: { balance in
                self.betsPendingBetsCount = balance
            }
        )
        .store(in: &cancellables)

        respository.getBetsCount(
            model: BetslipModel.self,
            tableName: TableName.betslip.rawValue,
            startDate: StartDate.allTime.dateValue!,
            isWon: nil
        )
        .sink(
            receiveValue: { balance in
                self.betslipPendingBetsCount = balance
            }
        )
        .store(in: &cancellables)

        mergeValues(
            bet: betsPendingBetsCount,
            betslip: betslipPendingBetsCount,
            resultKeyPath: \.mergedPendingBetsCount
        )
    }

    // ** Avg Won  Bets  **

    func getAvgWonBet() {
        switch currentStatsState {
        case .week:
            respository.getAvgWonBet(
                model: BetModel.self,
                tableName: TableName.bet.rawValue,
                startDate: StartDate.last7days.dateValue!,
                isWon: true
            )
            .sink(
                receiveValue: { balance in
                    self.betsAvgWonBet = balance
                }
            )
            .store(in: &cancellables)

            respository.getAvgWonBet(
                model: BetslipModel.self,
                tableName: TableName.betslip.rawValue,
                startDate: StartDate.last7days.dateValue!,
                isWon: true
            )
            .sink(
                receiveValue: { balance in
                    self.betslipAvgWonBet = balance
                }
            )
            .store(in: &cancellables)

            mergeValues(
                bet: betsAvgWonBet,
                betslip: betslipAvgWonBet,
                resultKeyPath: \.mergedAvgWonBet
            )

        case .month:
            respository.getAvgWonBet(
                model: BetModel.self,
                tableName: TableName.bet.rawValue,
                startDate: StartDate.lastMonth.dateValue!,
                isWon: true
            )
            .sink(
                receiveValue: { balance in
                    self.betsAvgWonBet = balance
                }
            )
            .store(in: &cancellables)

            respository.getAvgWonBet(
                model: BetslipModel.self,
                tableName: TableName.betslip.rawValue,
                startDate: StartDate.lastMonth.dateValue!,
                isWon: true
            )
            .sink(
                receiveValue: { balance in
                    self.betslipAvgWonBet = balance
                }
            )
            .store(in: &cancellables)

            mergeValues(
                bet: betsAvgWonBet,
                betslip: betslipAvgWonBet,
                resultKeyPath: \.mergedAvgWonBet
            )
        case .year:
            respository.getAvgWonBet(
                model: BetModel.self,
                tableName: TableName.bet.rawValue,
                startDate: StartDate.lastYear.dateValue!,
                isWon: true
            )
            .sink(
                receiveValue: { balance in
                    self.betsAvgWonBet = balance
                }
            )
            .store(in: &cancellables)

            respository.getAvgWonBet(
                model: BetslipModel.self,
                tableName: TableName.betslip.rawValue,
                startDate: StartDate.lastYear.dateValue!,
                isWon: true
            )
            .sink(
                receiveValue: { balance in
                    self.betslipAvgWonBet = balance
                }
            )
            .store(in: &cancellables)

            mergeValues(
                bet: betsAvgWonBet,
                betslip: betslipAvgWonBet,
                resultKeyPath: \.mergedAvgWonBet
            )
        case .alltime:
            respository.getAvgWonBet(
                model: BetModel.self,
                tableName: TableName.bet.rawValue,
                startDate: StartDate.allTime.dateValue!,
                isWon: true
            )
            .sink(
                receiveValue: { balance in
                    self.betsAvgWonBet = balance
                }
            )
            .store(in: &cancellables)

            respository.getAvgWonBet(
                model: BetslipModel.self,
                tableName: TableName.betslip.rawValue,
                startDate: StartDate.allTime.dateValue!,
                isWon: true
            )
            .sink(
                receiveValue: { balance in
                    self.betslipAvgWonBet = balance
                }
            )
            .store(in: &cancellables)

            mergeValues(
                bet: betsAvgWonBet,
                betslip: betslipAvgWonBet,
                resultKeyPath: \.mergedAvgWonBet
            )
        }
    }

    // ** Avg Lost Bets  **

    func getAvgLostBet() {
        switch currentStatsState {
        case .week:
            respository.getAvgWonBet(
                model: BetModel.self,
                tableName: TableName.bet.rawValue,
                startDate: StartDate.last7days.dateValue!,
                isWon: false
            )
            .sink(
                receiveValue: { balance in
                    self.betsAvgLostBet = balance
                }
            )
            .store(in: &cancellables)

            respository.getAvgWonBet(
                model: BetslipModel.self,
                tableName: TableName.betslip.rawValue,
                startDate: StartDate.last7days.dateValue!,
                isWon: false
            )
            .sink(
                receiveValue: { balance in
                    self.betslipAvgLostBet = balance
                }
            )
            .store(in: &cancellables)

            mergeValues(
                bet: betsAvgLostBet,
                betslip: betslipAvgLostBet,
                resultKeyPath: \.mergedAvgLostBet
            )

        case .month:
            respository.getAvgWonBet(
                model: BetModel.self,
                tableName: TableName.bet.rawValue,
                startDate: StartDate.lastMonth.dateValue!,
                isWon: false
            )
            .sink(
                receiveValue: { balance in
                    self.betsAvgLostBet = balance
                }
            )
            .store(in: &cancellables)

            respository.getAvgWonBet(
                model: BetslipModel.self,
                tableName: TableName.betslip.rawValue,
                startDate: StartDate.lastMonth.dateValue!,
                isWon: false
            )
            .sink(
                receiveValue: { balance in
                    self.betslipAvgLostBet = balance
                }
            )
            .store(in: &cancellables)

            mergeValues(
                bet: betsAvgLostBet,
                betslip: betslipAvgLostBet,
                resultKeyPath: \.mergedAvgLostBet
            )

        case .year:
            respository.getAvgWonBet(
                model: BetModel.self,
                tableName: TableName.bet.rawValue,
                startDate: StartDate.lastYear.dateValue!,
                isWon: false
            )
            .sink(
                receiveValue: { balance in
                    self.betsAvgLostBet = balance
                }
            )
            .store(in: &cancellables)

            respository.getAvgWonBet(
                model: BetslipModel.self,
                tableName: TableName.betslip.rawValue,
                startDate: StartDate.lastYear.dateValue!,
                isWon: false
            )
            .sink(
                receiveValue: { balance in
                    self.betslipAvgLostBet = balance
                }
            )
            .store(in: &cancellables)

            mergeValues(
                bet: betsAvgLostBet,
                betslip: betslipAvgLostBet,
                resultKeyPath: \.mergedAvgLostBet
            )
        case .alltime:
            respository.getAvgWonBet(
                model: BetModel.self,
                tableName: TableName.bet.rawValue,
                startDate: StartDate.allTime.dateValue!,
                isWon: false
            )
            .sink(
                receiveValue: { balance in
                    self.betsAvgLostBet = balance
                }
            )
            .store(in: &cancellables)

            respository.getAvgWonBet(
                model: BetslipModel.self,
                tableName: TableName.betslip.rawValue,
                startDate: StartDate.allTime.dateValue!,
                isWon: false
            )
            .sink(
                receiveValue: { balance in
                    self.betslipAvgLostBet = balance
                }
            )
            .store(in: &cancellables)

            mergeValues(
                bet: betsAvgLostBet,
                betslip: betslipAvgLostBet,
                resultKeyPath: \.mergedAvgLostBet
            )
        }
    }

    // ** Avg Amount Bets  **

    func getAvgAmountBet() {
        switch currentStatsState {
        case .week:
            respository.getAvgAmountBet(
                model: BetModel.self,
                tableName: TableName.bet.rawValue,
                startDate: StartDate.last7days.dateValue!)
            .sink(
                receiveValue: { balance in
                    self.betsAvgAmountBet = balance
                }
            )
            .store(in: &cancellables)

            respository.getAvgAmountBet(
                model: BetslipModel.self,
                tableName: TableName.betslip.rawValue,
                startDate: StartDate.last7days.dateValue!)
            .sink(
                receiveValue: { balance in
                    self.betslipAvgAmountBet = balance
                }
            )
            .store(in: &cancellables)

            mergeValues(
                bet: betsAvgAmountBet,
                betslip: betslipAvgAmountBet,
                resultKeyPath: \.mergedAvgAmountBet
            )
        case .month:
            respository.getAvgAmountBet(
                model: BetModel.self,
                tableName: TableName.bet.rawValue,
                startDate: StartDate.lastMonth.dateValue!)
            .sink(
                receiveValue: { balance in
                    self.betsAvgAmountBet = balance
                }
            )
            .store(in: &cancellables)

            respository.getAvgAmountBet(
                model: BetslipModel.self,
                tableName: TableName.betslip.rawValue,
                startDate: StartDate.lastMonth.dateValue!)
            .sink(
                receiveValue: { balance in
                    self.betslipAvgAmountBet = balance
                }
            )
            .store(in: &cancellables)

            mergeValues(
                bet: betsAvgAmountBet,
                betslip: betslipAvgAmountBet,
                resultKeyPath: \.mergedAvgAmountBet
            )
        case .year:
            respository.getAvgAmountBet(
                model: BetModel.self,
                tableName: TableName.bet.rawValue,
                startDate: StartDate.lastYear.dateValue!)
            .sink(
                receiveValue: { balance in
                    self.betsAvgAmountBet = balance
                }
            )
            .store(in: &cancellables)

            respository.getAvgAmountBet(
                model: BetslipModel.self,
                tableName: TableName.betslip.rawValue,
                startDate: StartDate.lastYear.dateValue!)
            .sink(
                receiveValue: { balance in
                    self.betslipAvgAmountBet = balance
                }
            )
            .store(in: &cancellables)

            mergeValues(
                bet: betsAvgAmountBet,
                betslip: betslipAvgAmountBet,
                resultKeyPath: \.mergedAvgAmountBet
            )
        case .alltime:
            respository.getAvgAmountBet(
                model: BetModel.self,
                tableName: TableName.bet.rawValue,
                startDate: StartDate.allTime.dateValue!)
            .sink(
                receiveValue: { balance in
                    self.betsAvgAmountBet = balance
                }
            )
            .store(in: &cancellables)

            respository.getAvgAmountBet(
                model: BetslipModel.self,
                tableName: TableName.betslip.rawValue,
                startDate: StartDate.allTime.dateValue!)
            .sink(
                receiveValue: { balance in
                    self.betslipAvgAmountBet = balance
                }
            )
            .store(in: &cancellables)

            mergeValues(
                bet: betsAvgAmountBet,
                betslip: betslipAvgAmountBet,
                resultKeyPath: \.mergedAvgAmountBet
            )
        }
    }

    // ** Lergest Bet Profit**

    func getLargestBetProfit() {
        switch currentStatsState {
        case .week:
            respository.getLargestBetProfit(
                model: BetModel.self,
                tableName: TableName.bet.rawValue,
                startDate: StartDate.last7days.dateValue!)
            .sink(
                receiveValue: { balance in
                    self.betsLargestBetProfit = balance
                }
            )
            .store(in: &cancellables)

            respository.getLargestBetProfit(
                model: BetslipModel.self,
                tableName: TableName.betslip.rawValue,
                startDate: StartDate.last7days.dateValue!)
            .sink(
                receiveValue: { balance in
                    self.betslipLargestBetProfit = balance
                }
            )
            .store(in: &cancellables)

            mergeValues(
                bet: betsLargestBetProfit,
                betslip: betslipLargestBetProfit,
                resultKeyPath: \.mergedLargestBetProfit
            )
        case .month:
            respository.getLargestBetProfit(
                model: BetModel.self,
                tableName: TableName.bet.rawValue,
                startDate: StartDate.lastMonth.dateValue!)
            .sink(
                receiveValue: { balance in
                    self.betsLargestBetProfit = balance
                }
            )
            .store(in: &cancellables)

            respository.getLargestBetProfit(
                model: BetslipModel.self,
                tableName: TableName.betslip.rawValue,
                startDate: StartDate.lastMonth.dateValue!)
            .sink(
                receiveValue: { balance in
                    self.betslipLargestBetProfit = balance
                }
            )
            .store(in: &cancellables)

            mergeValues(
                bet: betsLargestBetProfit,
                betslip: betslipLargestBetProfit,
                resultKeyPath: \.mergedLargestBetProfit
            )
        case .year:
            respository.getLargestBetProfit(
                model: BetModel.self,
                tableName: TableName.bet.rawValue,
                startDate: StartDate.lastYear.dateValue!)
            .sink(
                receiveValue: { balance in
                    self.betsLargestBetProfit = balance
                }
            )
            .store(in: &cancellables)

            respository.getLargestBetProfit(
                model: BetslipModel.self,
                tableName: TableName.betslip.rawValue,
                startDate: StartDate.lastYear.dateValue!)
            .sink(
                receiveValue: { balance in
                    self.betslipLargestBetProfit = balance
                }
            )
            .store(in: &cancellables)

            mergeValues(
                bet: betsLargestBetProfit,
                betslip: betslipLargestBetProfit,
                resultKeyPath: \.mergedLargestBetProfit
            )

        case .alltime:
            respository.getLargestBetProfit(
                model: BetModel.self,
                tableName: TableName.bet.rawValue,
                startDate: StartDate.allTime.dateValue!)
            .sink(
                receiveValue: { balance in
                    self.betsLargestBetProfit = balance
                }
            )
            .store(in: &cancellables)

            respository.getLargestBetProfit(
                model: BetslipModel.self,
                tableName: TableName.betslip.rawValue,
                startDate: StartDate.allTime.dateValue!)
            .sink(
                receiveValue: { balance in
                    self.betslipLargestBetProfit = balance
                }
            )
            .store(in: &cancellables)

            mergeValues(
                bet: betsLargestBetProfit,
                betslip: betslipLargestBetProfit,
                resultKeyPath: \.mergedLargestBetProfit
            )
        }
    }

    // ** Biggest Bet Loss**

    func getBiggestBetLoss() {
        switch currentStatsState {
        case .week:
            respository.getBiggestBetLoss(
                model: BetModel.self,
                tableName: TableName.bet.rawValue,
                startDate: StartDate.last7days.dateValue!)
            .sink(
                receiveValue: { balance in
                    self.betsBiggestBetLoss = balance
                }
            )
            .store(in: &cancellables)

            respository.getBiggestBetLoss(
                model: BetslipModel.self,
                tableName: TableName.betslip.rawValue,
                startDate: StartDate.last7days.dateValue!)
            .sink(
                receiveValue: { balance in
                    self.betslipBiggestBetLoss = balance
                }
            )
            .store(in: &cancellables)

            mergeValues(
                bet: betsBiggestBetLoss,
                betslip: betslipBiggestBetLoss,
                resultKeyPath: \.mergedBiggestBetLoss
            )

        case .month:
            respository.getBiggestBetLoss(
                model: BetModel.self,
                tableName: TableName.bet.rawValue,
                startDate: StartDate.lastMonth.dateValue!)
            .sink(
                receiveValue: { balance in
                    self.betsBiggestBetLoss = balance
                }
            )
            .store(in: &cancellables)

            respository.getBiggestBetLoss(
                model: BetslipModel.self,
                tableName: TableName.betslip.rawValue,
                startDate: StartDate.lastMonth.dateValue!)
            .sink(
                receiveValue: { balance in
                    self.betslipBiggestBetLoss = balance
                }
            )
            .store(in: &cancellables)

            mergeValues(
                bet: betsBiggestBetLoss,
                betslip: betslipBiggestBetLoss,
                resultKeyPath: \.mergedBiggestBetLoss
            )

        case .year:
            respository.getBiggestBetLoss(
                model: BetModel.self,
                tableName: TableName.bet.rawValue,
                startDate: StartDate.lastYear.dateValue!)
            .sink(
                receiveValue: { balance in
                    self.betsBiggestBetLoss = balance
                }
            )
            .store(in: &cancellables)

            respository.getBiggestBetLoss(
                model: BetslipModel.self,
                tableName: TableName.betslip.rawValue,
                startDate: StartDate.lastYear.dateValue!)
            .sink(
                receiveValue: { balance in
                    self.betslipBiggestBetLoss = balance
                }
            )
            .store(in: &cancellables)

            mergeValues(
                bet: betsBiggestBetLoss,
                betslip: betslipBiggestBetLoss,
                resultKeyPath: \.mergedBiggestBetLoss
            )

        case .alltime:
            respository.getBiggestBetLoss(
                model: BetModel.self,
                tableName: TableName.bet.rawValue,
                startDate: StartDate.allTime.dateValue!)
            .sink(
                receiveValue: { balance in
                    self.betsBiggestBetLoss = balance
                }
            )
            .store(in: &cancellables)

            respository.getBiggestBetLoss(
                model: BetslipModel.self,
                tableName: TableName.betslip.rawValue,
                startDate: StartDate.allTime.dateValue!)
            .sink(
                receiveValue: { balance in
                    self.betslipBiggestBetLoss = balance
                }
            )
            .store(in: &cancellables)

            mergeValues(
                bet: betsBiggestBetLoss,
                betslip: betslipBiggestBetLoss,
                resultKeyPath: \.mergedBiggestBetLoss
            )
        }
    }

    // ** Niggest Bet Won Odds**

    func getHiggestBetOddsWon() {
        switch currentStatsState {
        case .week:
            respository.getHiggestBetOddsWon(
                model: BetModel.self,
                tableName: TableName.bet.rawValue,
                startDate: StartDate.last7days.dateValue!)
            .sink(
                receiveValue: { balance in
                    self.betsHiggestBetOddsWon = balance
                }
            )
            .store(in: &cancellables)

            respository.getBiggestBetLoss(
                model: BetslipModel.self,
                tableName: TableName.betslip.rawValue,
                startDate: StartDate.last7days.dateValue!)
            .sink(
                receiveValue: { balance in
                    self.betslipHiggestBetOddsWon = balance
                }
            )
            .store(in: &cancellables)

            mergeValues(
                bet: betsHiggestBetOddsWon,
                betslip: betslipHiggestBetOddsWon,
                resultKeyPath: \.mergedHiggestBetOddsWon
            )
        case .month:
            respository.getHiggestBetOddsWon(
                model: BetModel.self,
                tableName: TableName.bet.rawValue,
                startDate: StartDate.lastMonth.dateValue!)
            .sink(
                receiveValue: { balance in
                    self.betsHiggestBetOddsWon = balance
                }
            )
            .store(in: &cancellables)

            respository.getBiggestBetLoss(
                model: BetslipModel.self,
                tableName: TableName.betslip.rawValue,
                startDate: StartDate.lastMonth.dateValue!)
            .sink(
                receiveValue: { balance in
                    self.betslipHiggestBetOddsWon = balance
                }
            )
            .store(in: &cancellables)

            mergeValues(
                bet: betsHiggestBetOddsWon,
                betslip: betslipHiggestBetOddsWon,
                resultKeyPath: \.mergedHiggestBetOddsWon
            )
        case .year:
            respository.getHiggestBetOddsWon(
                model: BetModel.self,
                tableName: TableName.bet.rawValue,
                startDate: StartDate.lastYear.dateValue!)
            .sink(
                receiveValue: { balance in
                    self.betsHiggestBetOddsWon = balance
                }
            )
            .store(in: &cancellables)

            respository.getBiggestBetLoss(
                model: BetslipModel.self,
                tableName: TableName.betslip.rawValue,
                startDate: StartDate.lastYear.dateValue!)
            .sink(
                receiveValue: { balance in
                    self.betslipHiggestBetOddsWon = balance
                }
            )
            .store(in: &cancellables)

            mergeValues(
                bet: betsHiggestBetOddsWon,
                betslip: betslipHiggestBetOddsWon,
                resultKeyPath: \.mergedHiggestBetOddsWon
            )

        case .alltime:
            respository.getHiggestBetOddsWon(
                model: BetModel.self,
                tableName: TableName.bet.rawValue,
                startDate: StartDate.allTime.dateValue!)
            .sink(
                receiveValue: { balance in
                    self.betsHiggestBetOddsWon = balance
                }
            )
            .store(in: &cancellables)

            respository.getBiggestBetLoss(
                model: BetslipModel.self,
                tableName: TableName.betslip.rawValue,
                startDate: StartDate.allTime.dateValue!)
            .sink(
                receiveValue: { balance in
                    self.betslipHiggestBetOddsWon = balance
                }
            )
            .store(in: &cancellables)

            mergeValues(
                bet: betsHiggestBetOddsWon,
                betslip: betslipHiggestBetOddsWon,
                resultKeyPath: \.mergedHiggestBetOddsWon
            )
        }
    }

    // ** Higgest Ammount **

    func getHiggestBetAmount() {
        switch currentStatsState {
        case .week:
            respository.getHiggestBetAmount(
                model: BetModel.self,
                tableName: TableName.bet.rawValue,
                startDate: StartDate.last7days.dateValue!)
            .sink(
                receiveValue: { balance in
                    self.betsHiggestBetAmount = balance
                }
            )
            .store(in: &cancellables)

            respository.getHiggestBetAmount(
                model: BetslipModel.self,
                tableName: TableName.betslip.rawValue,
                startDate: StartDate.last7days.dateValue!)
            .sink(
                receiveValue: { balance in
                    self.betslipHiggestBetAmount = balance
                }
            )
            .store(in: &cancellables)

            mergeValues(
                bet: betsHiggestBetAmount,
                betslip: betslipHiggestBetAmount,
                resultKeyPath: \.mergedHiggestBetAmount
            )
        case .month:
            respository.getHiggestBetAmount(
                model: BetModel.self,
                tableName: TableName.bet.rawValue,
                startDate: StartDate.lastMonth.dateValue!)
            .sink(
                receiveValue: { balance in
                    self.betsHiggestBetAmount = balance
                }
            )
            .store(in: &cancellables)

            respository.getHiggestBetAmount(
                model: BetslipModel.self,
                tableName: TableName.betslip.rawValue,
                startDate: StartDate.lastMonth.dateValue!)
            .sink(
                receiveValue: { balance in
                    self.betslipHiggestBetAmount = balance
                }
            )
            .store(in: &cancellables)

            mergeValues(
                bet: betsHiggestBetAmount,
                betslip: betslipHiggestBetAmount,
                resultKeyPath: \.mergedHiggestBetAmount
            )
        case .year:
            respository.getHiggestBetAmount(
                model: BetModel.self,
                tableName: TableName.bet.rawValue,
                startDate: StartDate.lastYear.dateValue!)
            .sink(
                receiveValue: { balance in
                    self.betsHiggestBetAmount = balance
                }
            )
            .store(in: &cancellables)

            respository.getHiggestBetAmount(
                model: BetslipModel.self,
                tableName: TableName.betslip.rawValue,
                startDate: StartDate.lastYear.dateValue!)
            .sink(
                receiveValue: { balance in
                    self.betslipHiggestBetAmount = balance
                }
            )
            .store(in: &cancellables)

            mergeValues(
                bet: betsHiggestBetAmount,
                betslip: betslipHiggestBetAmount,
                resultKeyPath: \.mergedHiggestBetAmount
            )
        case .alltime:
            respository.getHiggestBetAmount(
                model: BetModel.self,
                tableName: TableName.bet.rawValue,
                startDate: StartDate.allTime.dateValue!)
            .sink(
                receiveValue: { balance in
                    self.betsHiggestBetAmount = balance
                }
            )
            .store(in: &cancellables)

            respository.getHiggestBetAmount(
                model: BetslipModel.self,
                tableName: TableName.betslip.rawValue,
                startDate: StartDate.allTime.dateValue!)
            .sink(
                receiveValue: { balance in
                    self.betslipHiggestBetAmount = balance
                }
            )
            .store(in: &cancellables)

            mergeValues(
                bet: betsHiggestBetAmount,
                betslip: betslipHiggestBetAmount,
                resultKeyPath: \.mergedHiggestBetAmount
            )
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
