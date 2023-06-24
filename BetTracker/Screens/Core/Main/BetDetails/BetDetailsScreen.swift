import SwiftUI

struct BetDetailsScreen: View {
    @Environment(\.dismiss)
    var dismiss

    /// to pozmnielem moze byc zle
    @StateObject
    var vm: BetDetailsVM

    init(bet: BetModel, backgroundColor _: Color = .clear) {
        _vm = StateObject(wrappedValue: BetDetailsVM(bet: bet))
    }

    var body: some View {
        VStack {
            ScrollView {
                BetDetailHeader {
                    vm.isShowingAlert = true
                }
                .alert("Are you sure?", isPresented: $vm.isShowingAlert) {
                    Button("Yes") {
                        vm.deleteBet(bet: vm.bet)
                        vm.removeNotification()
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
                        Text(vm.bet.team1)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.title3)
                            .bold()
                            .padding(.vertical, 16)
                            .foregroundColor(
                                vm.bet.selectedTeam == .team1
                                    ? Color.ui.onPrimaryContainer
                                    : Color.ui.secondary
                            )
                    }
                    Text("vs.")
                        .font(.body)
                    HStack {
                        Text(vm.bet.team2)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.title3)
                            .bold()
                            .padding(.vertical, 16)
                            .foregroundColor(
                                vm.bet.selectedTeam == .team2
                                    ? Color.ui.onPrimaryContainer
                                    : Color.ui.secondary
                            )
                    }
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
                            BetDetailRow(cellTitle: "DATE", valueText: vm.bet.dateString)
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
                                MarkButton(text: "Seta as won", backgroundColor: Color.ui.scheme)
                                    .padding()
                                    .onTapGesture {
                                        BetDao.markFinished(bet: vm.bet, isWon: true)
                                        BetDao.markProfitWon(
                                            bet: vm.bet,
                                            score: (vm.bet.profit).subtracting(vm.bet.amount)
                                        )
                                        dismiss()
                                    }
                                MarkButton(text: "Set as lost", backgroundColor: Color.red)
                                    .onTapGesture {
                                        BetDao.markFinished(bet: vm.bet, isWon: false)
                                        BetDao.markProfitLost(
                                            bet: vm.bet,
                                            score: (vm.bet.amount).multiplying(by: -1)
                                        )
                                        dismiss()
                                    }
                            }

                        case .won:
                            MarkButton(text: "Set as lost", backgroundColor: Color.red)
                                .onTapGesture {
                                    BetDao.markFinished(bet: vm.bet, isWon: false)
                                    BetDao.markProfitLost(
                                        bet: vm.bet,
                                        score: (vm.bet.amount).multiplying(by: -1)
                                    )
                                    dismiss()
                                }
                        case .lost:
                            MarkButton(text: "Set as won", backgroundColor: Color.ui.scheme)
                                .onTapGesture {
                                    BetDao.markFinished(bet: vm.bet, isWon: true)
                                    BetDao.markProfitWon(
                                        bet: vm.bet,
                                        score: (vm.bet.profit).subtracting(vm.bet.amount)
                                    )
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
//
//        HStack {
//            switch vm.buttonState {
//            case .uncleared:
//                VStack {
//                    BetButton(text: "Seta as won")
//                        .padding()
//                        .onTapGesture {
//                            BetDao.markFinished(bet: vm.bet, isWon: true)
//                            BetDao.markProfitWon(
//                                bet: vm.bet,
//                                score: (vm.bet.profit).subtracting(vm.bet.amount)
//                            )
//                            dismiss()
//                        }
//                    BetButton(text: "Set as lost")
//                        .padding()
//                        .onTapGesture {
//                            BetDao.markFinished(bet: vm.bet, isWon: false)
//                            BetDao.markProfitLost(
//                                bet: vm.bet,
//                                score: (vm.bet.amount).multiplying(by: -1)
//                            )
//                            dismiss()
//                        }
//                }
//
//            case .won:
//                BetButton(text: "Set as lost")
//                    .onTapGesture {
//                        BetDao.markFinished(bet: vm.bet, isWon: false)
//                        BetDao.markProfitLost(
//                            bet: vm.bet,
//                            score: (vm.bet.amount).multiplying(by: -1)
//                        )
//                        dismiss()
//                    }
//            case .lost:
//                BetButton(text: "Set as won")
//                    .onTapGesture {
//                        BetDao.markFinished(bet: vm.bet, isWon: true)
//                        BetDao.markProfitWon(
//                            bet: vm.bet,
//                            score: (vm.bet.profit).subtracting(vm.bet.amount)
//                        )
//                        dismiss()
//                    }
//            }
//        }
        Spacer()
    }
}

struct BetInfoHistory_Previews: PreviewProvider {
    static var previews: some View {
        BetButton(text: "testowy")
    }
}
