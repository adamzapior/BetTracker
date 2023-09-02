import Combine
import Foundation
import GRDB

protocol DatabaseModel: FetchableRecord, PersistableRecord {
    var id: Int64? { get }
}

class BetDao {
    init() { }

    func saveBet<T: DatabaseModel>(model: T) {
        try? BetDb.db.write { db in
            try model.insert(db, onConflict: .ignore)
        }
    }

    func deleteBet<T: DatabaseModel>(model: T) {
        _ = try? BetDb.db.write { db in
            try model.delete(db)
        }
    }
    
    func markFinished<T: DatabaseModel>(model: T, isWon: Bool, tableName: String) {
        try? BetDb.db.write { db in
            try db.execute(
                sql: "UPDATE \(tableName) SET isWon = ? WHERE id = ?",
                arguments: [isWon, model.id]
            )
        }
    }

    func updateProfit<T: DatabaseModel>(model: T, score: NSDecimalNumber, tableName: String) {
        try? BetDb.db.write { db in
            try db.execute(
                sql: "UPDATE \(tableName) SET score = ? WHERE id = ?",
                arguments: [score, model.id]
            )
        }
    }

    func getSavedBets<T: DatabaseModel>(model _: T.Type) -> AnyPublisher<[T], Never> {
        ValueObservation
            .tracking { db in
                try T.fetchAll(db)
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }

    func getPendingBets<T: DatabaseModel>(
        model _: T.Type,
        tableName: String
    ) -> AnyPublisher<[T], Never> {
        ValueObservation
            .tracking { db in
                try T.fetchAll(
                    db,
                    sql: "SELECT * FROM \(tableName) WHERE isWon IS NULL"
                )
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }

    func getHistoryBets<T: DatabaseModel>(
        model _: T.Type,
        tableName: String
    ) -> AnyPublisher<[T], Never> {
        ValueObservation
            .tracking { db in
                try T.fetchAll(
                    db,
                    sql: "SELECT * FROM \(tableName) WHERE isWon IS NOT NULL ORDER BY date DESC"
                )
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }

    static func markFinished(bet: BetModel, isWon: Bool) {
        try! BetDb.db.write { db in
            try db.execute(
                sql: "UPDATE bet SET isWon = ? WHERE id = ?",
                arguments: [isWon, bet.id]
            )
        }
    }

    static func markProfitLost(bet: BetModel, score: NSDecimalNumber) {
        try! BetDb.db.write { db in
            try db.execute(
                sql: "UPDATE bet SET score = ? WHERE id = ?",
                arguments: [score, bet.id]
            )
        }
    }

    static func markProfitWon(bet: BetModel, score: NSDecimalNumber) {
        try! BetDb.db.write { db in
            try db.execute(
                sql: "UPDATE bet SET score = ? WHERE id = ?",
                arguments: [score, bet.id]
            )
        }
    }

    // MARK: - Queries for SearachView & VM buttons

    func getBetsFormTheOldestDate<T: DatabaseModel>(model _: T.Type) -> AnyPublisher<[T], Never> {
        ValueObservation
            .tracking { db in
                try T.fetchAll(
                    db,
                    sql: "SELECT * FROM bet ORDER BY date ASC"
                )
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }

    func getWonBets<T: DatabaseModel>(model _: T.Type) -> AnyPublisher<[T], Never> {
        ValueObservation
            .tracking { db in
                try T.fetchAll(
                    db,
                    sql: "SELECT * FROM bet WHERE isWon IS TRUE"
                )
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }

    func getLostBets<T: DatabaseModel>(model _: T.Type) -> AnyPublisher<[T], Never> {
        ValueObservation
            .tracking { db in
                try T.fetchAll(
                    db,
                    sql: "SELECT * FROM bet WHERE isWon IS FALSE"
                )
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }

    func getBetsByHiggestAmount<T: DatabaseModel>(model _: T.Type) -> AnyPublisher<[T], Never> {
        ValueObservation
            .tracking { db in
                try T.fetchAll(
                    db,
                    sql: "SELECT * FROM bet ORDER BY amount DESC"
                )
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }

    // MARK: Queries for ProfileVM

    /// ** Balance Value **
    func getBalanceValue(
        model _: (some DatabaseModel).Type,
        tableName: String,
        startDate: Date
    ) -> AnyPublisher<NSDecimalNumber, Never> {
        ValueObservation
            .tracking { db in
                try NSDecimalNumber
                    .fetchOne(
                        db,
                        sql: "SELECT SUM (score) FROM \(tableName) WHERE date >= ?",
                        arguments: [startDate]
                    ) ?? .zero
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }

    /// ** Total spent values **
    ///
    func getTotalSpent(
        model _: (some DatabaseModel).Type,
        tableName: String,
        startDate: Date
    ) -> AnyPublisher<NSDecimalNumber, Never> {
        ValueObservation
            .tracking { db in
                try NSDecimalNumber
                    .fetchOne(
                        db,
                        sql: "SELECT SUM (amount) FROM \(tableName) WHERE date >= ?",
                        arguments: [startDate]
                    ) ?? .zero
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }
    func getBetsCount(
        model _: (some DatabaseModel).Type,
        tableName: String,
        startDate: Date,
        isWon: Bool
    ) -> AnyPublisher<NSDecimalNumber, Never> {
        let isWonInt = isWon ? 1 : 0
        return ValueObservation
            .tracking { db in
                try NSDecimalNumber
                    .fetchOne(
                        db,
                        sql: "SELECT COUNT(id) FROM \(tableName) WHERE isWon = ? AND date >= ?",
                        arguments: [isWonInt, startDate]
                    ) ?? .zero
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }
    
    func getPendingBetsCount(
        model _: (some DatabaseModel).Type,
        tableName: String,
        startDate: Date
    ) -> AnyPublisher<NSDecimalNumber, Never> {
        return ValueObservation
            .tracking { db in
                try NSDecimalNumber
                    .fetchOne(
                        db,
                        sql: "SELECT COUNT(id) FROM \(tableName) WHERE isWon IS NULL AND date >= ?",
                        arguments: [startDate]
                    ) ?? .zero
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }

    // ** average bets **

    func getAvgWonBet(
        model _: (some DatabaseModel).Type,
        tableName: String,
        isWon: Bool,
        startDate: Date
    ) -> AnyPublisher<NSDecimalNumber, Never> {
        ValueObservation
            .tracking { db in
                try NSDecimalNumber
                    .fetchOne(
                        db,
                        sql: "SELECT AVG (profit) FROM \(tableName) WHERE isWon IS \(isWon.description) AND date >= ?",
                        arguments: [startDate]
                    ) ?? .zero
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }

    func getAvgAmountBet(
        model _: (some DatabaseModel).Type,
        tableName: String,
        startDate: Date
    ) -> AnyPublisher<NSDecimalNumber, Never> {
        ValueObservation
            .tracking { db in
                try NSDecimalNumber
                    .fetchOne(
                        db,
                        sql: "SELECT AVG (amount) FROM \(tableName) WHERE date >= ?",
                        arguments: [startDate]
                    ) ?? .zero
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }

    func getLargestBetProfit(
        model _: (some DatabaseModel).Type,
        tableName: String,
        startDate: Date
    ) -> AnyPublisher<NSDecimalNumber, Never> {
        ValueObservation
            .tracking { db in
                try NSDecimalNumber
                    .fetchOne(
                        db,
                        sql: "SELECT MAX (profit) FROM \(tableName) WHERE isWon IS TRUE AND date >= ?",
                        arguments: [startDate]
                    ) ?? .zero
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }

    func getBiggestBetLoss(
        model _: (some DatabaseModel).Type,
        tableName: String,
        startDate: Date
    ) -> AnyPublisher<NSDecimalNumber, Never> {
        ValueObservation
            .tracking { db in
                try NSDecimalNumber
                    .fetchOne(
                        db,
                        sql: "SELECT MAX (amount) FROM \(tableName) WHERE isWon IS FALSE AND date >= ?",
                        arguments: [startDate]
                    ) ?? .zero
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }

    func getHiggestBetOddsWon(
        model _: (some DatabaseModel).Type,
        tableName: String,
        startDate: Date
    ) -> AnyPublisher<NSDecimalNumber, Never> {
        ValueObservation
            .tracking { db in
                try NSDecimalNumber
                    .fetchOne(
                        db,
                        sql: "SELECT MAX (odds) FROM \(tableName) WHERE isWon IS TRUE AND date >= ?",
                        arguments: [startDate]
                    ) ?? .zero
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }

    func getHiggestBetAmount(
        model _: (some DatabaseModel).Type,
        tableName: String,
        startDate: Date
    ) -> AnyPublisher<NSDecimalNumber, Never> {
        ValueObservation
            .tracking { db in
                try NSDecimalNumber
                    .fetchOne(
                        db,
                        sql: "SELECT MAX (amount) FROM \(tableName) WHERE date >= ?",
                        arguments: [startDate]
                    ) ?? .zero
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }

}
