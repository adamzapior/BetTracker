import Combine
import Foundation
import GRDB

protocol RespositoryProtocol {
    
    func saveBet<T: DatabaseModel>(model: T)
    
    func deleteBet<T: DatabaseModel>(model: T)
    
    func markBetStatus<T: DatabaseModel>(model: T, isWon: Bool, tableName: String)
    
    func updateProfit<T: DatabaseModel>(model: T, score: NSDecimalNumber, tableName: String)

    func getPendingBets<T: DatabaseModel>(
        model: T.Type,
        tableName: String
    ) -> AnyPublisher<[T], Never>

    func getHistoryBets<T: DatabaseModel>(
        model: T.Type,
        tableName: String
    ) -> AnyPublisher<[T], Never>

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
    ) -> AnyPublisher<NSDecimalNumber, Never>
    
    func getPendingBetsCount<T: DatabaseModel>(
        model: T.Type,
        tableName: String,
        startDate: Date
    ) -> AnyPublisher<NSDecimalNumber, Never>

    func getAvgAmountBet<T: DatabaseModel>(model: T.Type, tableName: String, startDate: Date)
        -> AnyPublisher<NSDecimalNumber, Never>

    func getLargestBetProfit<T: DatabaseModel>(model: T.Type, tableName: String, startDate: Date)
        -> AnyPublisher<NSDecimalNumber, Never>
    func getBiggestBetLoss<T: DatabaseModel>(model: T.Type, tableName: String, startDate: Date)
        -> AnyPublisher<NSDecimalNumber, Never>
    func getHiggestBetOddsWon<T: DatabaseModel>(model: T.Type, tableName: String, startDate: Date)
        -> AnyPublisher<NSDecimalNumber, Never>
    func getHighestBetAmount<T: DatabaseModel>(model: T.Type, tableName: String, startDate: Date)
        -> AnyPublisher<NSDecimalNumber, Never>
}

class Respository: RespositoryProtocol {

    let db = BetDao()
    
    func saveBet<T: DatabaseModel>(model: T) {
        db.saveBet(model: model)
    }
    
    func deleteBet<T: DatabaseModel>(model: T) {
        db.deleteBet(model: model)
    }
    
    func markBetStatus<T: DatabaseModel>(model: T, isWon: Bool, tableName: String) {
        db.markFinished(model: model, isWon: isWon, tableName: tableName)
    }
    
    func updateProfit<T: DatabaseModel>(model: T, score: NSDecimalNumber, tableName: String) {
        db.updateProfit(model: model, score: score, tableName: tableName)
    }
    
    func getPendingBets<T: DatabaseModel>(
        model: T.Type,
        tableName: String
    ) -> AnyPublisher<[T], Never> {
        db.getPendingBets(model: model, tableName: tableName)
    }

    func getHistoryBets<T: DatabaseModel>(
        model: T.Type,
        tableName: String
    ) -> AnyPublisher<[T], Never> {
        db.getHistoryBets(model: model, tableName: tableName)
    }

    func getSavedBets<T: DatabaseModel>(model: T.Type) -> AnyPublisher<[T], Never> {
        db.getSavedBets(model: model)
    }

    func getBalanceValue<T: DatabaseModel>(
        model: T.Type,
        tableName: String,
        startDate: Date
    ) -> AnyPublisher<NSDecimalNumber, Never> {
        db.getBalanceValue(model: model, tableName: tableName, startDate: startDate)
    }

    func getTotalSpent<T: DatabaseModel>(
        model: T.Type,
        tableName: String,
        startDate: Date
    ) -> AnyPublisher<NSDecimalNumber, Never> {
        db.getTotalSpent(model: model, tableName: tableName, startDate: startDate)
    }

    func getBetsCount<T: DatabaseModel>(
        model: T.Type,
        tableName: String,
        startDate: Date,
        isWon: Bool?
    ) -> AnyPublisher<NSDecimalNumber, Never> {
        let isWonValue = isWon ?? true
        return db.getBetsCount(
            model: model,
            tableName: tableName,
            startDate: startDate,
            isWon: isWonValue
        )
    }
    
    func getPendingBetsCount<T: DatabaseModel>(
        model: T.Type,
        tableName: String,
        startDate: Date
    ) -> AnyPublisher<NSDecimalNumber, Never> {
        return db.getPendingBetsCount(
            model: model,
            tableName: tableName,
            startDate: startDate
        )
    }

    func getAvgWonBet<T: DatabaseModel>(
        model: T.Type,
        tableName: String,
        startDate: Date,
        isWon: Bool
    ) -> AnyPublisher<NSDecimalNumber, Never> {
        db.getAvgWonBet(model: model, tableName: tableName, isWon: isWon, startDate: startDate)
    }

    func getAvgAmountBet<T: DatabaseModel>(
        model: T.Type,
        tableName: String,
        startDate: Date
    ) -> AnyPublisher<NSDecimalNumber, Never> {
        db.getAvgAmountBet(model: model, tableName: tableName, startDate: startDate)
    }

    func getLargestBetProfit<T: DatabaseModel>(
        model: T.Type,
        tableName: String,
        startDate: Date
    ) -> AnyPublisher<NSDecimalNumber, Never> {
        db.getLargestBetProfit(model: model, tableName: tableName, startDate: startDate)
    }

    func getBiggestBetLoss<T: DatabaseModel>(
        model: T.Type,
        tableName: String,
        startDate: Date
    ) -> AnyPublisher<NSDecimalNumber, Never> {
        db.getBiggestBetLoss(model: model, tableName: tableName, startDate: startDate)
    }

    func getHiggestBetOddsWon<T: DatabaseModel>(
        model: T.Type,
        tableName: String,
        startDate: Date
    ) -> AnyPublisher<NSDecimalNumber, Never> {
        db.getHiggestBetOddsWon(model: model, tableName: tableName, startDate: startDate)
    }

    func getHighestBetAmount<T: DatabaseModel>(
        model: T.Type,
        tableName: String,
        startDate: Date
    ) -> AnyPublisher<NSDecimalNumber, Never> {
        db.getHiggestBetAmount(model: model, tableName: tableName, startDate: startDate)
    }
}
