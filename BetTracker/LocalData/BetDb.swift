import Foundation
import GRDB

class BetDb {
    private init() { }

    static let db = {
        let databaseURL = try! FileManager.default
            .url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            .appendingPathComponent("db.sqlite")
        let db = try! DatabaseQueue(path: databaseURL.path)
        

        try? db.write { db in
            try db.create(table: "bet") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("date", .date).notNull()
                t.column("team1", .text).notNull()
                t.column("team2", .text).notNull()
                t.column("selectedTeam", .integer).notNull()
                t.column("league", .text)
                t.column("amount", .integer).notNull()
                t.column("odds", .integer).notNull()
                t.column("category", .text)
                t.column("tax", .integer)
                t.column("profit", .text)
                t.column("isWon", .boolean)
            }
        }
        return db
    }()
}
