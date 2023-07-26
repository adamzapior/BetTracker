import Combine
import Foundation
import GRDB

class BetDao {
    private init() { }

    static func saveBet(bet: BetModel) {
        try? BetDb.db.write { db in
            try bet.insert(db, onConflict: .ignore)
        }
    }
    
    static func saveBetslip(bet: BetslipModel) {
        try? BetDb.db.write { db in
            try bet.insert(db, onConflict: .ignore)
        }
    }

    static func deleteBet(bet: BetModel) {
        _ = try? BetDb.db.write { db in
            try bet.delete(db)
        }
    }
    
    static func deleteBetslip(bet: BetslipModel) {
        _ = try? BetDb.db.write { db in
            try bet.delete(db)
        }
    }
    


    static func getSavedBets() -> AnyPublisher<[BetModel], Never> {
        ValueObservation
            .tracking { db in
                try BetModel.fetchAll(db)
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }

    static func getPendingBets() -> AnyPublisher<[BetModel], Never> {
        ValueObservation
            .tracking { db in
                try BetModel.fetchAll(
                    db,
                    sql: "SELECT * FROM bet WHERE isWon IS NULL"
                )
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }

    static func getHistoryBets() -> AnyPublisher<[BetModel], Never> {
        ValueObservation
            .tracking { db in
                try BetModel.fetchAll(
                    db,
                    sql: "SELECT * FROM bet WHERE isWon IS NOT NULL ORDER BY date DESC"
                )
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }

    // for Chart:

    static func sevenDaysHistory() -> AnyPublisher<[BetModel], Never> {
        ValueObservation
            .tracking { db in
                try BetModel.fetchAll(
                    db,
                    sql: "SELECT * FROM bet WHERE date date >= DATE_SUB(NOW(), INTERVAL 7 DAY)"
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

    static func getBetsFormTheOldestDate() -> AnyPublisher<[BetModel], Never> {
        ValueObservation
            .tracking { db in
                try BetModel.fetchAll(
                    db,
                    sql: "SELECT * FROM bet ORDER BY date ASC"
                )
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }

    static func getWonBets() -> AnyPublisher<[BetModel], Never> {
        ValueObservation
            .tracking { db in
                try BetModel.fetchAll(
                    db,
                    sql: "SELECT * FROM bet WHERE isWon IS TRUE"
                )
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }

    static func getLostBets() -> AnyPublisher<[BetModel], Never> {
        ValueObservation
            .tracking { db in
                try BetModel.fetchAll(
                    db,
                    sql: "SELECT * FROM bet WHERE isWon IS FALSE"
                )
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }

    static func getBetsByHiggestAmount() -> AnyPublisher<[BetModel], Never> {
        ValueObservation
            .tracking { db in
                try BetModel.fetchAll(
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
    static func getBalanceValue() -> AnyPublisher<NSDecimalNumber, Never> {
        ValueObservation
            .tracking { db in
                try NSDecimalNumber
                    .fetchOne(
                        db,
                        sql: "SELECT SUM (score) FROM bet"
                    ) ?? .zero
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }

    static func getLast7DaysBalanceValue() -> AnyPublisher<NSDecimalNumber, Never> {
        ValueObservation
            .tracking { db in
                let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
                return try NSDecimalNumber
                    .fetchOne(
                        db,
                        sql: "SELECT SUM(score) FROM bet WHERE date >= ?",
                        arguments: [startDate]
                    ) ?? .zero
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }

    static func getLastMonthBalanceValue() -> AnyPublisher<NSDecimalNumber, Never> {
        ValueObservation
            .tracking { db in
                let startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
                return try NSDecimalNumber
                    .fetchOne(
                        db,
                        sql: "SELECT SUM(score) FROM bet WHERE date >= ?",
                        arguments: [startDate]
                    ) ?? .zero
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }

    static func getLastYearBalanceValue() -> AnyPublisher<NSDecimalNumber, Never> {
        ValueObservation
            .tracking { db in
                let startDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
                return try NSDecimalNumber
                    .fetchOne(
                        db,
                        sql: "SELECT SUM(score) FROM bet WHERE date >= ?",
                        arguments: [startDate]
                    ) ?? .zero
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }

    /// ** Total spent values **
    ///
    static func getTotalSpent() -> AnyPublisher<NSDecimalNumber, Never> {
        ValueObservation
            .tracking { db in
                try NSDecimalNumber
                    .fetchOne(
                        db,
                        sql: "SELECT SUM (amount) FROM bet"
                    ) ?? .zero
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }

    static func getTotalSpentByPeroid(startDate: Date) -> AnyPublisher<NSDecimalNumber, Never> {
        ValueObservation
            .tracking { db in
                try NSDecimalNumber
                    .fetchOne(
                        db,
                        sql: "SELECT SUM (amount) FROM bet WHERE date >= ?",
                        arguments: [startDate]
                    ) ?? .zero
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }

    static func getWonBetsCount() -> AnyPublisher<NSDecimalNumber, Never> {
        ValueObservation
            .tracking { db in
                try NSDecimalNumber
                    .fetchOne(
                        db,
                        sql: "SELECT COUNT (id) FROM bet WHERE isWon IS TRUE"
                    ) ?? .zero
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }

    static func getWonBetsCounyByPeroid(startDate: Date) -> AnyPublisher<NSDecimalNumber, Never> {
        ValueObservation
            .tracking { db in
                try NSDecimalNumber
                    .fetchOne(
                        db,
                        sql: "SELECT COUNT (id) FROM bet WHERE isWon IS TRUE AND date >= ?",
                        arguments: [startDate]
                    ) ?? .zero
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }

    static func getLostBetsCount() -> AnyPublisher<NSDecimalNumber, Never> {
        ValueObservation
            .tracking { db in
                try NSDecimalNumber
                    .fetchOne(
                        db,
                        sql: "SELECT COUNT (id) FROM bet WHERE isWon IS FALSE"
                    ) ?? .zero
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }

    static func getLostBetsCountByPeroid(startDate: Date) -> AnyPublisher<NSDecimalNumber, Never> {
        ValueObservation
            .tracking { db in
                try NSDecimalNumber
                    .fetchOne(
                        db,
                        sql: "SELECT COUNT (id) FROM bet WHERE isWon IS FALSE AND date >= ?",
                        arguments: [startDate]
                    ) ?? .zero
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }

    static func getPeningBetsCount() -> AnyPublisher<NSDecimalNumber, Never> {
        ValueObservation
            .tracking { db in
                try NSDecimalNumber
                    .fetchOne(
                        db,
                        sql: "SELECT COUNT (id) FROM bet WHERE isWon IS null"
                    ) ?? .zero
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }

    // ** average bets **

    static func getAvgWonBet() -> AnyPublisher<NSDecimalNumber, Never> {
        ValueObservation
            .tracking { db in
                try NSDecimalNumber
                    .fetchOne(
                        db,
                        sql: "SELECT AVG (profit) FROM bet WHERE isWon IS TRUE"
                    ) ?? .zero
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }

    static func getAvgWonBetByPeroid(startDate: Date) -> AnyPublisher<NSDecimalNumber, Never> {
        ValueObservation
            .tracking { db in
                try NSDecimalNumber
                    .fetchOne(
                        db,
                        sql: "SELECT AVG (profit) FROM bet WHERE isWon IS TRUE AND date >= ?",
                        arguments: [startDate]
                    ) ?? .zero
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }

    static func getAvgLostBet() -> AnyPublisher<NSDecimalNumber, Never> {
        ValueObservation
            .tracking { db in
                try NSDecimalNumber
                    .fetchOne(
                        db,
                        sql: "SELECT AVG (amount) FROM bet WHERE isWon IS FALSE"
                    ) ?? .zero
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }
    
    static func getAvgLostBetByPeroid(startDate: Date) -> AnyPublisher<NSDecimalNumber, Never> {
        ValueObservation
            .tracking { db in
                try NSDecimalNumber
                    .fetchOne(
                        db,
                        sql: "SELECT AVG (amount) FROM bet WHERE isWon IS FALSE AND date >= ?",
                        arguments: [startDate]
                    ) ?? .zero
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }

    static func getAvgAmountBet() -> AnyPublisher<NSDecimalNumber, Never> {
        ValueObservation
            .tracking { db in
                try NSDecimalNumber
                    .fetchOne(
                        db,
                        sql: "SELECT AVG (amount) FROM bet"
                    ) ?? .zero
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }
    
    static func getAvgAmountBetByPeroid(startDate: Date) -> AnyPublisher<NSDecimalNumber, Never> {
        ValueObservation
            .tracking { db in
                try NSDecimalNumber
                    .fetchOne(
                        db,
                        sql: "SELECT AVG (amount) FROM bet WHERE date >= ?",
                        arguments: [startDate]
                    ) ?? .zero
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }

    static func getLargestBetProfit() -> AnyPublisher<NSDecimalNumber, Never> {
        ValueObservation
            .tracking { db in
                try NSDecimalNumber
                    .fetchOne(
                        db,
                        sql: "SELECT MAX (profit) FROM bet WHERE isWon IS TRUE"
                    ) ?? .zero
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }
    
    static func getLargestBetProfitByPeroid(startDate: Date) -> AnyPublisher<NSDecimalNumber, Never> {
        ValueObservation
            .tracking { db in
                try NSDecimalNumber
                    .fetchOne(
                        db,
                        sql: "SELECT MAX (profit) FROM bet WHERE isWon IS TRUE AND date >= ?",
                        arguments: [startDate]
                    ) ?? .zero
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }

    static func getBiggestBetLoss() -> AnyPublisher<NSDecimalNumber, Never> {
        ValueObservation
            .tracking { db in
                try NSDecimalNumber
                    .fetchOne(
                        db,
                        sql: "SELECT MAX (amount) FROM bet WHERE isWon IS FALSE"
                    ) ?? .zero
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }
    
    static func getBiggestBetLossByPeroid(startDate: Date) -> AnyPublisher<NSDecimalNumber, Never> {
        ValueObservation
            .tracking { db in
                try NSDecimalNumber
                    .fetchOne(
                        db,
                        sql: "SELECT MAX (amount) FROM bet WHERE isWon IS FALSE AND date >= ?",
                        arguments: [startDate]
                    ) ?? .zero
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }

    static func getHiggestBetOddsWon() -> AnyPublisher<NSDecimalNumber, Never> {
        ValueObservation
            .tracking { db in
                try NSDecimalNumber
                    .fetchOne(
                        db,
                        sql: "SELECT MAX (odds) FROM bet WHERE isWon IS TRUE"
                    ) ?? .zero
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }
    
    static func getHiggestBetOddsWonByPeroid(startDate: Date) -> AnyPublisher<NSDecimalNumber, Never> {
        ValueObservation
            .tracking { db in
                try NSDecimalNumber
                    .fetchOne(
                        db,
                        sql: "SELECT MAX (odds) FROM bet WHERE isWon IS TRUE AND date >= ?",
                        arguments: [startDate]
                    ) ?? .zero
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }

    static func getHiggestBetAmount() -> AnyPublisher<NSDecimalNumber, Never> {
        ValueObservation
            .tracking { db in
                try NSDecimalNumber
                    .fetchOne(
                        db,
                        sql: "SELECT MAX (amount) FROM bet"
                    ) ?? .zero
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }
    
    static func getHiggestBetAmountByPeroid(startDate: Date) -> AnyPublisher<NSDecimalNumber, Never> {
        ValueObservation
            .tracking { db in
                try NSDecimalNumber
                    .fetchOne(
                        db,
                        sql: "SELECT MAX (odds) FROM bet WHERE isWon IS TRUE AND date >= ?",
                        arguments: [startDate]
                    ) ?? .zero
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }
    
    static func getBetslipBets() -> AnyPublisher<[BetslipModel], Never> {
        ValueObservation
            .tracking { db in
                try BetslipModel.fetchAll(db)
            }
            .publisher(in: BetDb.db)
            .mapError { _ in Never.transferRepresentation }
            .eraseToAnyPublisher()
    }
}
