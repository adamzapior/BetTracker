//
//  CategorySettingsViewModel.swift
//  BetTracker
//
//  Created by Adam Zapiór on 23/10/2024.
//

import Combine
import Foundation
import LifetimeTracker

final class CategorySettingsViewModel: ObservableObject {
    @Injected(\.repository) var repository
    
    @Published var categories: [CategoryModel] = []
    @Published var categoryName: String = ""
    @Published var selectedIcon: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        observeCategoriesList()
                
        #if DEBUG
        trackLifetime()
        #endif
    }
    
    func addCategory() {
        let category = createCategoryModel()
        if isCategoryValidated(category) {
            repository.saveCategory(model: category)
            updateIndexPaths()
            
            // clean
            categoryName = ""
            selectedIcon = ""
        }
    }
    
    func deleteCategory(at indexSet: IndexSet) {
        for index in indexSet {
            let categoryToDelete = categories[index]
            repository.deleteCategory(model: categoryToDelete)
        }

        updateIndexPaths()
    }
    
    func moveCategory(from source: IndexSet, to destination: Int) {
        categories.move(fromOffsets: source, toOffset: destination)
        updateIndexPaths()
    }
    
    func updateCategoriesInDatabase() {
        for category in categories {
            repository.updateCategory(model: category)
        }
    }
    
    private func observeCategoriesList() {
        repository.observeCategories()
            .map { categories in
                categories.sorted { $0.indexPath < $1.indexPath }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] sortedCategories in
                self?.categories = sortedCategories
            }
            .store(in: &cancellables)
    }
    
    private func updateIndexPaths() {
        for (index, _) in categories.enumerated() {
            categories[index].indexPath = index
        }
    }

    private func isCategoryValidated(_ category: CategoryModel) -> Bool {
        return !category.name.isEmpty && !category.systemImage.isEmpty
    }
    
    private func createCategoryModel() -> CategoryModel {
        return CategoryModel(
            id: nil, name: categoryName,
            systemImage: selectedIcon,
            indexPath: categories.count + 1
        )
    }
}

extension CategorySettingsViewModel: LifetimeTrackable {
    class var lifetimeConfiguration: LifetimeConfiguration {
        return LifetimeConfiguration(maxCount: 1, groupName: "ViewModels")
    }
}
