//
//  TagsSettingsViewModel.swift
//  BetTracker
//
//  Created by Adam Zapiór on 21/10/2024.
//

import Combine
import Foundation
import LifetimeTracker
import SwiftUI

final class TagsSettingsViewModel: ObservableObject {
    @Injected(\.repository) var repository
    
    @Published var tags: [TagModel] = []
    @Published var tagName: String = ""
    @Published var selectedColor: Color = .yellow
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        observeTagsList()
        
        #if DEBUG
        trackLifetime()
        #endif
    }
    
    func addTag() {
        let tag = createTagModel()
        if isTagValidated(tag) {
            repository.saveTag(model: tag)
            updateIndexPaths()
                        
            // clean
            tagName = ""
            selectedColor = Color.yellow
        }
    }
    
    func deleteTag(at indexSet: IndexSet) {
        for index in indexSet {
            let categoryToDelete = tags[index]
            repository.deleteTag(model: categoryToDelete)
        }

        updateIndexPaths()
    }
    
    func moveTag(from source: IndexSet, to destination: Int) {
        tags.move(fromOffsets: source, toOffset: destination)
        updateIndexPaths()
    }
    
    func updateTagsInDatabase() {
        for tag in tags {
            repository.updateTag(model: tag)
        }
    }
    
    private func observeTagsList() {
        repository.observeTags()
            .map { tags in
                tags.sorted { $0.indexPath < $1.indexPath }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] sortedTags in
                self?.tags = sortedTags
            }
            .store(in: &cancellables)
    }
    
    private func updateIndexPaths() {
        for (index, _) in tags.enumerated() {
            tags[index].indexPath = index
        }
    }
    
    private func isTagValidated(_ tag: TagModel) -> Bool {
        return !tag.name.isEmpty
    }
    
    private func createTagModel() -> TagModel {
        return TagModel(name: tagName,
                        color: UIColor(selectedColor),
                        indexPath: tags.count + 1)
    }
}


extension TagsSettingsViewModel: LifetimeTrackable {
    class var lifetimeConfiguration: LifetimeConfiguration {
        return LifetimeConfiguration(maxCount: 1, groupName: "ViewModels")
    }
}
