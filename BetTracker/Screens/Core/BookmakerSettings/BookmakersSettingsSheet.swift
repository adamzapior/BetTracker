//
//  BookmakersSettingsSheet.swift
//  BetTracker
//
//  Created by Adam Zapiór on 24/10/2024.
//

import Foundation
import SwiftUI

struct BookmakersSettingsSheet: View {
    @Environment(\.dismiss) var dismiss
    @State var viewModel: BookmakersSettingsViewModel

    @FocusState private var isBookmakerNameFocused: Bool

    init(viewModel: BookmakersSettingsViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Bookmaker Details")) {
                    TextField("Bookmaker name", text: $viewModel.bookmakerName)
                        .focused($isBookmakerNameFocused)

                    ColorPicker("Choose color", selection: $viewModel.selectedColor)
                }
            }
            .navigationTitle("New bookmaker")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    viewModel.addBookmaker()
                    dismiss()
                }
                .disabled(viewModel.bookmakerName.isEmpty)
            )
        }
        .presentationDetents([.medium])
    }
}
