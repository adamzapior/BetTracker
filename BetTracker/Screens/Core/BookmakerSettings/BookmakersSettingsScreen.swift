//
//  BookmakersSettingsScreen.swift
//  BetTracker
//
//  Created by Adam Zapiór on 24/10/2024.
//

import Foundation
import SwiftUI

struct BookmakersSettingsScreen: View {
    @State private var showingAddSheet = false
    @State private var editMode: EditMode = .inactive
    @State private var showEditButton = false

    @StateObject var viewModel = BookmakersSettingsViewModel()

    var body: some View {
        VStack {
            if viewModel.bookmakers.isEmpty {
                emptyBookmakersPlaceholderView()
                    .frame(maxHeight: .infinity)
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .leading).combined(with: .opacity),
                            removal: .move(edge: .trailing).combined(with: .opacity)
                        )
                    )
            } else {
                List {
                    ForEach(viewModel.bookmakers) { bookmaker in
                        BookmakerRowView(bookmaker: bookmaker)
                    }
                    .onDelete { indexSet in
                        viewModel.deleteBookmaker(at: indexSet)
                    }
                    .onMove { from, to in
                        viewModel.moveBookmaker(from: from, to: to)
                    }
                }
            }
        }
        .background(Color.systemGroupedBackground)
        .navigationTitle("Bookmakers")
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
                            Label("Add bookmaker", systemImage: "plus.circle")
                        }

                        if !viewModel.bookmakers.isEmpty {
                            Button(action: {
                                withAnimation {
                                    editMode = .active
                                }
                            }) {
                                Label(
                                    "Edit bookmakers",
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
                viewModel.updateBookmakersInDatabase()
            case .active:
                break
            case .transient:
                break
            @unknown default:
                break
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            BookmakersSettingsSheet(viewModel: viewModel)
        }
        .onChange(of: viewModel.bookmakers) { _, newValue in
            let wasEmpty = viewModel.bookmakers.isEmpty
            let isNowEmpty = newValue.isEmpty

            if wasEmpty != isNowEmpty {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    showEditButton = !isNowEmpty
                }
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: viewModel.bookmakers.isEmpty)
    }

    private func emptyBookmakersPlaceholderView() -> some View {
        VStack(spacing: 12) {
            Image(systemName: "list.dash")
                .font(.system(size: 64))
                .foregroundColor(.secondary)

            Text("No Bookmakers")
                .font(.title2)
                .fontWeight(.medium)

            Text("Create bookmakers to tag your bets")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
}
