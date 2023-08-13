import Combine
import Foundation
import GRDB

protocol MainInteractorProtocol {
    func getPendingBets<T: DatabaseModel>(model: T.Type, tableName: String)
        -> AnyPublisher<[T], Never>
    func getHistoryBets<T: DatabaseModel>(model: T.Type, tableName: String)
        -> AnyPublisher<[T], Never>
    func getSavedBets<T: DatabaseModel>(model: T.Type) -> AnyPublisher<[T], Never>
    func getBalanceValue<T: DatabaseModel>(model: T.Type, tableName: String, startDate: Date)
        -> AnyPublisher<NSDecimalNumber, Never>
    func getTotalSpent<T: DatabaseModel>(model: T.Type, tableName: String, startDate: Date)
        -> AnyPublisher<NSDecimalNumber, Never>
    func getBetsCount<T: DatabaseModel>(
        model: T.Type,
        tableName: String,
        startDate: Date,
        isWon: Bool?
    )
        -> AnyPublisher<NSDecimalNumber, Never>

    func getAvgAmountBet<T: DatabaseModel>(model: T.Type, tableName: String, startDate: Date)
        -> AnyPublisher<NSDecimalNumber, Never>

    func getLargestBetProfit<T: DatabaseModel>(model: T.Type, tableName: String, startDate: Date)
        -> AnyPublisher<NSDecimalNumber, Never>
    func getBiggestBetLoss<T: DatabaseModel>(model: T.Type, tableName: String, startDate: Date)
        -> AnyPublisher<NSDecimalNumber, Never>
    func getHiggestBetOddsWon<T: DatabaseModel>(model: T.Type, tableName: String, startDate: Date)
        -> AnyPublisher<NSDecimalNumber, Never>
    func getHiggestBetAmount<T: DatabaseModel>(model: T.Type, tableName: String, startDate: Date)
        -> AnyPublisher<NSDecimalNumber, Never>
}

class MainInteractor: MainInteractorProtocol {

    let db: BetDao

    init(db: BetDao) {
        self.db = db
    }

    func getPendingBets<T>(model: T.Type, tableName: String) -> AnyPublisher<[T], Never>
        where T: DatabaseModel {
        db.getPendingBets(model: model, tableName: tableName)
    }

    func getHistoryBets<T>(model: T.Type, tableName: String) -> AnyPublisher<[T], Never>
        where T: DatabaseModel {
        db.getHistoryBets(model: model, tableName: tableName)
    }

    func getSavedBets<T>(model: T.Type) -> AnyPublisher<[T], Never> where T: DatabaseModel {
        db.getSavedBets(model: model)
    }

    func getBalanceValue(
        model: (some DatabaseModel).Type,
        tableName: String,
        startDate: Date
    ) -> AnyPublisher<NSDecimalNumber, Never> {
        db.getBalanceValue(model: model, tableName: tableName, startDate: startDate)
    }

    func getTotalSpent(
        model: (some DatabaseModel).Type,
        tableName: String,
        startDate: Date
    ) -> AnyPublisher<NSDecimalNumber, Never> {
        db.getTotalSpent(model: model, tableName: tableName, startDate: startDate)
    }

    func getBetsCount(
        model: (some DatabaseModel).Type,
        tableName: String,
        startDate: Date,
        isWon: Bool?
    ) -> AnyPublisher<NSDecimalNumber, Never> {
        db.getBetsCount(model: model, tableName: tableName, startDate: startDate, isWon: (isWon ?? true)!)
    }

    func getAvgWonBet(
        model: (some DatabaseModel).Type,
        tableName: String,
        startDate: Date,
        isWon: Bool
    ) -> AnyPublisher<NSDecimalNumber, Never> {
        db.getAvgWonBet(model: model, tableName: tableName, isWon: isWon, startDate: startDate)
    }

    func getAvgAmountBet(
        model: (some DatabaseModel).Type,
        tableName: String,
        startDate: Date
    ) -> AnyPublisher<NSDecimalNumber, Never> {
        db.getAvgAmountBet(model: model, tableName: tableName, startDate: startDate)
    }

    func getLargestBetProfit(
        model: (some DatabaseModel).Type,
        tableName: String,
        startDate: Date
    ) -> AnyPublisher<NSDecimalNumber, Never> {
        db.getLargestBetProfit(model: model, tableName: tableName, startDate: startDate)
    }

    func getBiggestBetLoss(
        model: (some DatabaseModel).Type,
        tableName: String,
        startDate: Date
    ) -> AnyPublisher<NSDecimalNumber, Never> {
        db.getBiggestBetLoss(model: model, tableName: tableName, startDate: startDate)
    }

    func getHiggestBetOddsWon(
        model: (some DatabaseModel).Type,
        tableName: String,
        startDate: Date
    ) -> AnyPublisher<NSDecimalNumber, Never> {
        db.getHiggestBetOddsWon(model: model, tableName: tableName, startDate: startDate)
    }

    func getHiggestBetAmount(
        model: (some DatabaseModel).Type,
        tableName: String,
        startDate: Date
    ) -> AnyPublisher<NSDecimalNumber, Never> {
        db.getHiggestBetAmount(model: model, tableName: tableName, startDate: startDate)
    }
}
