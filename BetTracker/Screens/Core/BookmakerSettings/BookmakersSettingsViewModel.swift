//
//  BookmakerSettingsViewModel.swift
//  BetTracker
//
//  Created by Adam Zapiór on 24/10/2024.
//

import Combine
import Foundation
import LifetimeTracker
import SwiftUI

final class BookmakersSettingsViewModel: ObservableObject {
    @Injected(\.repository) var repository
    
    @Published var bookmakers: [BookmakerModel] = []
    @Published var bookmakerName: String = ""
    @Published var selectedColor: Color = .yellow

    private var cancellables = Set<AnyCancellable>()
    
    init() {
        observeBookmakerList()
        
        #if DEBUG
        trackLifetime()
        #endif
    }
    
    func addBookmaker() {
        let bookmaker = createBookmakerModel()
        if isBookmakerValidated(bookmaker) {
            repository.saveBookmaker(model: bookmaker)
            updateIndexPaths()
                        
            // clean
            bookmakerName = ""
            selectedColor = Color.yellow
        }
    }
    
    func deleteBookmaker(at indexSet: IndexSet) {
        for index in indexSet {
            let bookmakerToDelete = bookmakers[index]
            repository.deleteBookmaker(model: bookmakerToDelete)
        }

        updateIndexPaths()
    }
    
    func moveBookmaker(from source: IndexSet, to destination: Int) {
        bookmakers.move(fromOffsets: source, toOffset: destination)
        updateIndexPaths()
    }
    
    func updateBookmakersInDatabase() {
        for bookmaker in bookmakers {
            repository.updateBookmaker(model: bookmaker)
        }
    }
    
    private func observeBookmakerList() {
        repository.observeBookmakers()
            .map { bookmakers in
                bookmakers.sorted { $0.indexPath < $1.indexPath }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] sortedBookmakers in
                self?.bookmakers = sortedBookmakers
            }
            .store(in: &cancellables)
    }
    
    private func updateIndexPaths() {
        for (index, _) in bookmakers.enumerated() {
            bookmakers[index].indexPath = index
        }
    }
    
    private func isBookmakerValidated(_ bookmaker: BookmakerModel) -> Bool {
        return !bookmaker.name.isEmpty
    }
    
    private func createBookmakerModel() -> BookmakerModel {
        return BookmakerModel(name: bookmakerName,
                              color: UIColor(selectedColor),
                              indexPath: bookmakers.count + 1)
    }
}

extension BookmakersSettingsViewModel: LifetimeTrackable {
    class var lifetimeConfiguration: LifetimeConfiguration {
        return LifetimeConfiguration(maxCount: 1, groupName: "ViewModels")
    }
}
