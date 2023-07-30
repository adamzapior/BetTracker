import Combine
import Foundation
import GRDB

protocol MainInteractorProtocol {
    func getPendingBets<T: DatabaseModel>(model: T.Type) -> AnyPublisher<[T], Never>
    func getHistoryBets<T: DatabaseModel>(model: T.Type) -> AnyPublisher<[T], Never>
    func getSavedBets<T: DatabaseModel>(model: T.Type) -> AnyPublisher<[T], Never>

}

class MainInteractor: MainInteractorProtocol {
    
    let db: BetDao

    init(db: BetDao) {
        self.db = db
    }

    func getPendingBets<T>(model: T.Type) -> AnyPublisher<[T], Never> where T: DatabaseModel {
        db.getPendingBets(model: model)
    }

    func getHistoryBets<T>(model: T.Type) -> AnyPublisher<[T], Never> where T: DatabaseModel {
        db.getHistoryBets(model: model)

    }

    func getSavedBets<T>(model: T.Type) -> AnyPublisher<[T], Never> where T: DatabaseModel {
        db.getSavedBets(model: model)

    }


}
