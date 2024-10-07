//
//  DeleteReminderBetAlertView.swift
//  BetTracker
//
//  Created by Adam Zapiór on 06/10/2024.
//

import SwiftUI

struct DeleteReminderBetAlertView<VM>: View where VM: BetsDetailsViewModelsProtocol {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: VM

    var body: some View {
        if isPresented {
            CustomAlertView(
                title: "Warning",
                messages: ["Do you want to remove notification?"],
                primaryButtonLabel: "OK",
                primaryButtonAction: {
                    viewModel.deleteBetNotification()
                    viewModel.isAlertSet = false
                    isPresented = false
                },
                secondaryButtonLabel: "Cancel",
                secondaryButtonAction: { isPresented = false }
            )
        }
    }
}
