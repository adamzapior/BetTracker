//
//  CategoryAddSheet.swift
//  BetTracker
//
//  Created by Adam Zapiór on 23/10/2024.
//

import Foundation
import SFSymbolsPicker
import SwiftUI

struct CategorySettingsSheet: View {
    @Environment(\.dismiss) var dismiss
    @State var viewModel: CategorySettingsViewModel

    @State private var isPresented = false
    @FocusState private var isCategoryNameFocused: Bool

    init(viewModel: CategorySettingsViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Category details")) {
                    TextField("Category name", text: $viewModel.categoryName)
                        .focused($isCategoryNameFocused)

                    HStack {
                        if viewModel.selectedIcon.isEmpty {
                            Text("Select icon")
                                .foregroundStyle(.secondary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                        } else {
                            Text("Selected icon:")
                            Spacer()
                            Image(systemName: viewModel.selectedIcon)
                                .foregroundStyle(Color.ui.scheme)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        isPresented = true
                    }
                }
            }
            .sheet(isPresented: $isPresented, content: {
                SymbolsPicker(selection: $viewModel.selectedIcon, title: "Choose your symbol", autoDismiss: true) {
                    Image(systemName: "xmark.diamond.fill")
                }
            })
            .navigationTitle("New category")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    viewModel.addCategory()
                    dismiss()
                }
                .disabled(viewModel.categoryName.isEmpty || viewModel.selectedIcon.isEmpty)
            )
        }
        .presentationDetents([.medium])
    }
}
