//
//  CategorySettingsScreen.swift
//  BetTracker
//
//  Created by Adam Zapiór on 23/10/2024.
//

import Foundation
import SwiftUI

struct CategorySettingsScreen: View {
    @State private var showingAddSheet = false
    @State private var editMode: EditMode = .inactive
    @State private var showEditButton = false

    @StateObject var viewModel = CategorySettingsViewModel()

    var body: some View {
        VStack {
            if viewModel.categories.isEmpty {
                emptyTagsPlaceholderView()
                    .frame(maxHeight: .infinity)
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .leading).combined(with: .opacity),
                            removal: .move(edge: .trailing).combined(with: .opacity)
                        )
                    )
            } else {
                List {
                    ForEach(viewModel.categories) { category in
                        CategoryRowView(category: category)
                    }
                    .onDelete { indexSet in
                        viewModel.deleteCategory(at: indexSet)
                    }
                    .onMove { from, to in
                        viewModel.moveCategory(from: from, to: to)
                    }
                }
            }
        }
        .background(Color.systemGroupedBackground)
        .navigationTitle("Sport categories")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if editMode.isEditing {
                    Button(action: {
                        withAnimation {
                            editMode = .inactive
                        }
                    }) {
                        Label(
                            "Done",
                            systemImage: "checkmark.circle"
                        )
                    }
                } else {
                    Menu {
                        Button(action: {
                            showingAddSheet.toggle()
                        }) {
                            Label("Add category", systemImage: "plus.circle")
                        }

                        if !viewModel.categories.isEmpty {
                            Button(action: {
                                withAnimation {
                                    editMode = .active
                                }
                            }) {
                                Label(
                                    "Edit categories",
                                    systemImage: "pencil"
                                )
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundStyle(.primary)
                    }
                }
            }
        }
        .environment(\.editMode, $editMode)
        .onChange(of: editMode) { _, newValue in
            switch newValue {
            case .inactive:
                viewModel.updateCategoriesInDatabase()
            case .active:
                break
            case .transient:
                break
            @unknown default:
                break
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            CategorySettingsSheet(viewModel: viewModel)
        }
        .onChange(of: viewModel.categories) { _, newValue in
            let wasEmpty = viewModel.categories.isEmpty
            let isNowEmpty = newValue.isEmpty

            if wasEmpty != isNowEmpty {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    showEditButton = !isNowEmpty
                }
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: viewModel.categories.isEmpty)
    }

    private func emptyTagsPlaceholderView() -> some View {
        VStack(spacing: 12) {
            Image(systemName: "figure.australian.football")
                .font(.system(size: 64))
                .foregroundColor(.secondary)

            Text("No Categories")
                .font(.title2)
                .fontWeight(.medium)

            Text("Create cateogries to organize your bets")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
}
