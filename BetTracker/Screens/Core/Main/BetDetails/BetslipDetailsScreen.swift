//
//  BetslipDetailsScreen.swift
//  BetTracker
//
//  Created by Adam Zapiór on 26/07/2023.
//

import SwiftUI

struct BetslipDetailsScreen: View {
    @Environment(\.dismiss)
    var dismiss

    /// to pozmnielem moze byc zle
    @StateObject
    var vm: BetslipDetailsVM

    init(bet: BetslipModel, backgroundColor _: Color = .clear) {
        _vm = StateObject(wrappedValue: BetslipDetailsVM(bet: bet))
    }

    var body: some View {
        VStack {
            ScrollView {
                BetDetailHeader {
                    vm.isShowingAlert = true
                }
                .alert("Are you sure?", isPresented: $vm.isShowingAlert) {
                    Button("Yes") {
//                        vm.deleteBet(bet: vm.bet)
//                        vm.removeNotification()
                        dismiss()
                    }
                    Button("No", role: .cancel) { }
                }

                VStack {
                    HStack {
                        Text("YOUR PICK")
                            .foregroundColor(Color.ui.scheme)
                            .bold()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.top, 12)
                .padding(.horizontal, 12)

                VStack(spacing: 5) {
                    HStack {
                        Text(vm.bet.name)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.title3)
                            .bold()
                            .padding(.vertical, 16)
                         
                    }
                    Spacer()
                    Spacer()
             
                }
                .background {
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundColor(
                            Color.ui.onPrimary
                        )
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 12)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5)

                VStack {
                    HStack {
                        Text("BET VALUES")
                            .foregroundColor(Color.ui.scheme)
                            .bold()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.top, 12)
                .padding(.horizontal, 12)

                VStack(spacing: 12) {
                    Group {
                        BetDetailRowAmount(
                            cellTitle: "AMOUNT",
                            valueText: vm.bet.amount.doubleValue.formattedWith2Digits(),
                            currency: vm.currency
                        )
                        .frame(maxHeight: 70)
                        HStack {
                            BetDetailRow(
                                cellTitle: "ODDS",
                                valueText: vm.bet.odds.doubleValue.formattedWith2Digits()
                            )
                            .frame(maxHeight: 70)
                            BetDetailRow(
                                cellTitle: "TAX",
                                valueText: "\(vm.bet.tax.doubleValue.formattedWith2Digits())%"
                            )
                            .frame(maxHeight: 70)
                        }

                        //                    if vm.bet.isWon == true {
                        //                        BetDetailRowAmount(cellTitle: "NET PROFIT", valueText: (vm.bet.score), currency: vm.currency)
                        //                    } else if vm.bet.isWon == false {
                        //                        BetDetailRowAmount(cellTitle: "LOSS", valueText: ("-\(vm.bet.amount)"), currency: vm.currency)
                        //
                        //                    } else if vm.bet.isWon == nil {
                        //                        BetDetailRowAmount(cellTitle: "PREDICTED WIN", valueText: vm.bet.profit, currency: vm.currency)
                        //
                        //                    }

                        HStack {
                            BetDetailRow(cellTitle: "DATE", valueText: vm.bet.date.formatSelectedDate())
                                .frame(maxHeight: 70)
                            BetDetailRow(
                                cellTitle: "CATEGORY",
                                valueText: vm.bet.category.rawValue.uppercased()
                            )
                            .frame(maxHeight: 70)
                        }

                        Spacer()
                    }

                    HStack {
                        switch vm.buttonState {
                        case .uncleared:
                            VStack {
                                MarkWonButton(text: "Set as won")
                                    .padding(.horizontal, 64)
                                    .onTapGesture {
                                       
                                        dismiss()
                                    }
                                MarkLostButton(text: "Set as lost")
                                    .padding(.horizontal, 64)
                                    .onTapGesture {
                                        
                                        dismiss()
                                    }
                            }

                        case .won:
                            MarkLostButton(text: "Set as lost")
                                .padding(.horizontal, 64)
                                .onTapGesture {
                                    
                                    dismiss()
                                }
                        case .lost:
                            MarkWonButton(text: "Set as won")
                                .padding(.horizontal, 64)
                                .onTapGesture {
                                    
                                    dismiss()
                                }
                        }
                    }
                    .padding(.top, 36)
                }

                .frame(maxWidth: .infinity)
                .padding(.horizontal, 12)
            }
        }
        .navigationBarBackButtonHidden()
        Spacer()
        Spacer()
    }
}
