//
//  DeleteBetAlertView.swift
//  BetTracker
//
//  Created by Adam Zapiór on 06/10/2024.
//

import SwiftUI

struct DeleteBetAlertView<VM>: View where VM: BetsDetailsViewModelsProtocol {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: VM
    @Environment(FeedTabRouter.self) private var router

    var body: some View {
        if isPresented {
            CustomAlertView(
                title: "Warning",
                messages: ["Do you want to delete bet?"],
                primaryButtonLabel: "OK",
                primaryButtonAction: {
                    viewModel.deleteBet()
                    viewModel.deleteBetNotification()
                    router.popToRoot()
                },
                secondaryButtonLabel: "Cancel",
                secondaryButtonAction: { isPresented = false }
            )
        }
    }
}
