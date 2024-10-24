//
//  TagsSettingsSheet.swift
//  BetTracker
//
//  Created by Adam Zapiór on 23/10/2024.
//

import Foundation
import SwiftUI

struct TagsSettingsSheet: View {
    @Environment(\.dismiss) var dismiss
    @State var viewModel: TagsSettingsViewModel

    @FocusState private var isTagNameFocused: Bool

    init(viewModel: TagsSettingsViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Tag Details")) {
                    TextField("Tag Name", text: $viewModel.tagName)
                        .focused($isTagNameFocused)

                    ColorPicker("Choose color", selection: $viewModel.selectedColor)
                }
            }
            .navigationTitle("New Tag")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    viewModel.addTag()
                    dismiss()
                }
                .disabled(viewModel.tagName.isEmpty)
            )
        }
        .presentationDetents([.medium])
    }
}
