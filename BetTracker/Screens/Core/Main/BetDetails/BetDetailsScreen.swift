import SwiftUI

struct BetDetailsScreen: View {
    @Environment(\.dismiss)
    var dismiss

    /// to pozmnielem moze byc zle
    @StateObject
    var vm: BetsDetailsVM

    init(bet: BetModel, backgroundColor _: Color = .clear) {
        _vm = StateObject(wrappedValue: BetsDetailsVM(bet: bet))
    }

    var body: some View {
        VStack {
            VStack {
                if vm.isAlertSet {
                    BetDetailHeader(title: "Your pick", isNotificationOn: true) {
                        dismiss()
                    } onDelete: {
                        vm.isShowingAlert = true
                    } onNotification: {
                        vm.removeNotification()
                        vm.isAlertSet = false
                    }
                    .alert("Are you sure?", isPresented: $vm.isShowingAlert) {
                        Button("Yes") {
                            vm.deleteBet(bet: vm.bet)
                            vm.removeNotification()
                            dismiss()
                        }
                        Button("No", role: .cancel) { }
                    }
                } else {
                    BetDetailHeader(title: "Your pick", isNotificationOn: false) {
                        dismiss()
                    } onDelete: {
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
                }
            }

            ScrollView(showsIndicators: false) {
                VStack(spacing: 5) {
                    HStack {
                        Text(vm.bet.team1.uppercased())
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.title3)
                            .bold()
                            .padding(.vertical, 8)
                            .padding(.horizontal)
                            .foregroundColor(
                                vm.bet.selectedTeam == .team1
                                    ? Color.ui.scheme
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
                            .padding(.vertical, 8)
                            .padding(.horizontal)
                            .foregroundColor(
                                vm.bet.selectedTeam == .team2
                                    ? Color.ui.scheme
                                    : Color.ui.secondary
                            )
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 12)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5)

                Divider()
                    .padding()

                VStack(spacing: 8) {
                    Group {
                        BetsDetailRow(
                            icon: "calendar",
                            labelText: "DATE",
                            profitText: vm.bet.dateString
                        )
                        .shadow(color: Color.black.opacity(0.14), radius: 5, x: 5, y: 5)
                        BetsDetailRow(
                            icon: "sportscourt",
                            labelText: "CATEGORY",
                            profitText: vm.bet.category.rawValue.uppercased()
                        )
                        .shadow(color: Color.black.opacity(0.14), radius: 5, x: 5, y: 5)

                        BetsDetailRow(
                            icon: "banknote",
                            labelText: "AMOUNT",
                            profitText: vm.bet.amount.stringValue,
                            currency: vm.currency
                        )
                        .shadow(color: Color.black.opacity(0.14), radius: 5, x: 5, y: 5)
                        BetsDetailRow(
                            icon: "dice",
                            labelText: "ODDS",
                            profitText: vm.bet.odds.doubleValue.formattedWith2Digits()
                        )
                        .shadow(color: Color.black.opacity(0.14), radius: 5, x: 5, y: 5)
                        BetsDetailRow(
                            icon: "dollarsign.circle",
                            labelText: "TAX",
                            profitText: "\(vm.bet.tax.doubleValue.formattedWith2Digits()) %"
                        )
                        .shadow(color: Color.black.opacity(0.14), radius: 5, x: 5, y: 5)

                        if vm.bet.isWon == true {
                            BetsDetailRow(
                                icon: "arrow.up.forward",
                                labelText: "NET PROFIT",
                                profitText: vm.bet.score!.stringValue,
                                currency: vm.currency
                            )
                            .shadow(color: Color.black.opacity(0.14), radius: 5, x: 5, y: 5)
                        } else if vm.bet.isWon == false {
                            BetsDetailRow(
                                icon: "arrow.down.forward",
                                labelText: "YOUR LOSS",
                                profitText: vm.bet.score!.stringValue,
                                currency: vm.currency
                            )
                            .shadow(color: Color.black.opacity(0.14), radius: 5, x: 5, y: 5)
                        } else {
                            BetsDetailRow(
                                icon: "arrow.forward",
                                labelText: "PREDICTED WIN",
                                profitText: vm.bet.profit.stringValue,
                                currency: vm.currency
                            )
                            .shadow(color: Color.black.opacity(0.14), radius: 5, x: 5, y: 5)
                        }

                        if !vm.bet.note!.isEmpty {
                            VStack {
                                BetsDetailRow(
                                    icon: "note",
                                    labelText: "NOTE",
                                    profitText: ""
                                )
                                .padding(.bottom, -12)

                                Text(vm.bet.note!)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                            }
                            .background {
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundColor(
                                        Color.ui.onPrimary
                                    )
                            }
                            .shadow(color: Color.black.opacity(0.14), radius: 5, x: 5, y: 5)
                        } else {
                            EmptyView()
                        }
                    }
                }

                .frame(maxWidth: .infinity)
                .padding(.horizontal, 12)
                .padding(.bottom, 12)
            }
        }
        .padding(.bottom, 0) // dodatkowe 20 punktów dla odstępu
        .safeAreaInset(
            edge: .bottom,
            alignment: .center,
            content: {
                VStack {
                    HStack {
                        switch vm.buttonState {
                        case .uncleared:
                            HStack(spacing: 16) {
                                MarkWonButton(text: "BET WON")
                                    .onTapGesture {
                                        BetDao.markFinished(bet: vm.bet, isWon: true)
                                        BetDao.markProfitWon(
                                            bet: vm.bet,
                                            score: (vm.bet.profit).subtracting(vm.bet.amount)
                                        )
                                        dismiss()
                                    }
                                MarkLostButton(text: "BET LOST")
                                    .onTapGesture {
                                        BetDao.markFinished(bet: vm.bet, isWon: false)
                                        BetDao.markProfitLost(
                                            bet: vm.bet,
                                            score: (vm.bet.amount).multiplying(by: -1)
                                        )
                                        dismiss()
                                    }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 90)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 12)

                        case .won:
                            MarkLostButton(text: "Set as lost")
                                .padding(.horizontal, 64)
                                .onTapGesture {
                                    BetDao.markFinished(bet: vm.bet, isWon: false)
                                    BetDao.markProfitLost(
                                        bet: vm.bet,
                                        score: (vm.bet.amount).multiplying(by: -1)
                                    )
                                    dismiss()
                                }
                                .padding(.vertical, 12)

                        case .lost:
                            MarkWonButton(text: "Set as won")
                                .padding(.horizontal, 64)
                                .onTapGesture {
                                    BetDao.markFinished(bet: vm.bet, isWon: true)
                                    BetDao.markProfitWon(
                                        bet: vm.bet,
                                        score: (vm.bet.profit).subtracting(vm.bet.amount)
                                    )
                                    dismiss()
                                }
                                .padding(.vertical, 12)
                        }
                    }
                }
                .background {
                    RoundedRectangle(cornerRadius: 0, style: .continuous)
                        .foregroundColor(Color.clear)
                        .background(Material.bar.opacity(0.7))
                        .blur(radius: 12)
                }
                .padding(.top, 36)
            }
        )
        .padding(.top, 24)
        .navigationBarBackButtonHidden()
    }
}

struct BetInfoHistory_Previews: PreviewProvider {
    static var previews: some View {
        MainLabel(text: "testowy")
    }
}
