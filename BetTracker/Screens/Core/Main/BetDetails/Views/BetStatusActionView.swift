//
//  BetStatusActionView.swift
//  BetTracker
//
//  Created by Adam Zapiór on 06/10/2024.
//

import SwiftUI

struct BetStatusActionView<VM>: View where VM: BetsDetailsViewModelsProtocol {
    @ObservedObject var viewModel: VM

    let setToWon: () -> Void
    let setToLost: () -> Void

    var body: some View {
        VStack {
            HStack {
                switch viewModel.buttonState {
                case .uncleared:
                    HStack(spacing: 16) {
                        MarkButtonView(text: "BET WON", buttonType: .win)
                            .onTapGesture {
                                setToWon()
                            }
                        MarkButtonView(text: "BET LOST", buttonType: .loss)
                            .onTapGesture {
                                setToLost()
                            }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 36)

                case .won:
                    MarkButtonView(text: "Set as lost", buttonType: .loss)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 36)
                        .onTapGesture {
                            setToLost()
                        }
                case .lost:
                    MarkButtonView(text: "Set as won", buttonType: .win)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 36)
                        .onTapGesture {
                            setToWon()
                        }
                }
            }
        }
    }
}
