//
//  TagsSettingsScreen.swift
//  BetTracker
//
//  Created by Adam Zapiór on 21/10/2024.
//

import SwiftUI

struct TagsSettingsScreen: View {
    @State private var tags: [TagModel] = []
    @State private var showingAddSheet = false
    @State private var editMode: EditMode = .inactive
    @State private var showEditButton = false

    @StateObject var viewModel = TagsSettingsViewModel()

    var body: some View {
        VStack {
            if viewModel.tags.isEmpty {
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
                    ForEach(viewModel.tags) { tag in
                        TagRowView(tag: tag)
                    }
                    .onDelete { indexSet in
                        viewModel.deleteTag(at: indexSet)
                    }
                    .onMove { from, to in
                        viewModel.moveTag(from: from, to: to)
                    }
                }
            }
        }
        .background(Color.systemGroupedBackground)
        .navigationTitle("Tags")
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
                            Label("Add tag", systemImage: "plus.circle")
                        }

                        if !viewModel.tags.isEmpty {
                            Button(action: {
                                withAnimation {
                                    editMode = .active
                                }
                            }) {
                                Label(
                                    "Edit tags",
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
                viewModel.updateTagsInDatabase()
            case .active:
                break
            case .transient:
                break
            @unknown default:
                break
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            TagsSettingsSheet(viewModel: viewModel)
        }
        .onChange(of: tags) { _, newValue in
            let wasEmpty = tags.isEmpty
            let isNowEmpty = newValue.isEmpty

            if wasEmpty != isNowEmpty {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    showEditButton = !isNowEmpty
                }
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: viewModel.tags.isEmpty)
    }

    private func emptyTagsPlaceholderView() -> some View {
        VStack(spacing: 12) {
            Image(systemName: "tag.circle")
                .font(.system(size: 64))
                .foregroundColor(.secondary)

            Text("No Tags")
                .font(.title2)
                .fontWeight(.medium)

            Text("Create tags to organize your bets")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
}

struct TagsSettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        TagsSettingsScreen()
    }
}

#Preview {
    TagsSettingsScreen()
}
