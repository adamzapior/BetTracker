import Combine
import Foundation

protocol SearchnteractorProtocol {
    func getSavedBets<T: DatabaseModel>(model: T.Type) -> AnyPublisher<[T], Never>
    func getBetsFormTheOldestDate<T: DatabaseModel>(model: T.Type) -> AnyPublisher<[T], Never>
    func getWonBets<T: DatabaseModel>(model: T.Type) -> AnyPublisher<[T], Never>
    func getLostBets<T: DatabaseModel>(model: T.Type) -> AnyPublisher<[T], Never>
    func getBetsByAmount<T: DatabaseModel>(model: T.Type) -> AnyPublisher<[T], Never>
    func loadDefaultCurrency() -> String

}

class SearchInteractor: SearchnteractorProtocol {

    let db: BetDao
    let defaults = UserDefaultsManager.path

    init(db: BetDao) {
        self.db = db
    }

    func getSavedBets<T>(model: T.Type) -> AnyPublisher<[T], Never> where T: DatabaseModel {
        db.getSavedBets(model: model)
    }

    func getBetsFormTheOldestDate<T>(model: T.Type) -> AnyPublisher<[T], Never>
        where T: DatabaseModel {
        db.getBetsFormTheOldestDate(model: model)
    }

    func getWonBets<T>(model: T.Type) -> AnyPublisher<[T], Never> where T: DatabaseModel {
        db.getWonBets(model: model)
    }

    func getLostBets<T>(model: T.Type) -> AnyPublisher<[T], Never> where T: DatabaseModel {
        db.getLostBets(model: model)
    }

    func getBetsByAmount<T>(model: T.Type) -> AnyPublisher<[T], Never> where T: DatabaseModel {
        db.getBetsByHiggestAmount(model: model)
    }

    func loadDefaultCurrency() -> String {
        defaults.get(.defaultCurrency)
    }

}
