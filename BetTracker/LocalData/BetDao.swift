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

    static func deleteBet(bet: BetModel) {
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
                    sql: "SELECT * FROM bet WHERE isWon IS NOT NULL"
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
    
    // MARK: Queries for Profile Stats Views
    
    static func allBetsAmount() -> AnyPublisher<NSDecimalNumber, Never> {
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
}
