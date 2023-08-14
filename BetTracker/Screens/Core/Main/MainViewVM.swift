import Combine
import Foundation
import GRDB
import SwiftDate

class MainViewVM: ObservableObject {

    let respository: MainInteractor
    let dbBets = "bet"
    let dbBetslip = "betslip"

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
    var savedBets: [BetModel]? = []

    @Published
    var isSearchClicked: Bool = false

    @Published
    private var cancellables = Set<AnyCancellable>()

    let bet: [BetModel] = [
        BetModel(
            id: Int64(),
            date: Date(),
            team1: "test1",
            team2: "test2",
            selectedTeam: .team1,
            league: "",
            amount: 0.00,
            odds: 1,
            category: .football,
            tax: 1,
            profit: 24,
            isWon: nil,
            betNotificationID: "",
            score: 24
        )
    ]

    var currency = UserDefaultsManager.defaultCurrencyValue

    init(interactor: MainInteractor) {
        self.respository = interactor

        getMerged()

        interactor.getPendingBets(model: BetModel.self, tableName: dbBets)
            .map { .some($0) }
            .assign(to: &$pendingBets)

        interactor.getPendingBets(model: BetslipModel.self, tableName: dbBetslip)
            .map { .some($0) }
            .assign(to: &$pendingBetslipBets)

        Publishers.CombineLatest($pendingBets, $pendingBetslipBets)
            .map { historyBets, betslipHistory -> [BetWrapper] in
                let combinedBets = (historyBets?.map(BetWrapper.bet) ?? []) +
                    (betslipHistory?.map(BetWrapper.betslip) ?? [])
                return combinedBets.sorted(by: { $0.date > $1.date })
            }
            .assign(to: \.pendingMerged, on: self)
            .store(in: &cancellables)

        interactor.getHistoryBets(model: BetModel.self, tableName: dbBets)
            .map { .some($0) }
            .assign(to: &$historyBets)

        interactor.getHistoryBets(model: BetslipModel.self, tableName: dbBetslip)
            .map { .some($0) }
            .assign(to: &$betslipHistory)

//        Publishers.CombineLatest($historyBets, $betslipHistory)
//                    .map { historyBets, betslipHistory -> [BetWrapper] in
//                        let combinedBets = (historyBets?.map(BetWrapper.bet) ?? []) +
//                        (betslipHistory?.map(BetWrapper.betslip) ?? [])
//                        return combinedBets.sorted(by: { $0.date > $1.date })
//                    }
//                    .assign(to: \.historyMerged, on: self)
//                    .store(in: &cancellables)


    }

    ///
    func getMerged() {
        Publishers.CombineLatest($historyBets, $betslipHistory)
            .map { historyBets, betslipHistory -> [BetWrapper] in
                let combinedBets = (historyBets?.map(BetWrapper.bet) ?? []) +
                    (betslipHistory?.map(BetWrapper.betslip) ?? [])
                return combinedBets.sorted(by: { $0.date > $1.date })
            }
            .assign(to: \.mergedBets, on: self)
            .store(in: &cancellables)
    }
}
