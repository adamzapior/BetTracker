import SwiftUI

struct BetslipDetailsView: View {
    @Environment(\.dismiss)
    var dismiss

    @Environment(\.colorScheme)
    var colorScheme

    @StateObject
    var vm: BetslipDetailsVM

    @State
    private var showDeleteAlert = false
    @State
    private var showReminderAlert = false

    init(bet: BetslipModel, backgroundColor _: Color = .clear) {
        _vm = StateObject(wrappedValue: BetslipDetailsVM(bet: bet, respository: Respository()))
    }

    var body: some View {
        ZStack {
            if showDeleteAlert == true {
                CustomAlertView(
                    title: "Warning",
                    messages: ["Do you want to delete bet?"],
                    primaryButtonLabel: "OK",
                    primaryButtonAction: {
                        vm.deleteBet(bet: vm.bet)
                        vm.removeNotification()
                        dismiss()
                    },
                    secondaryButtonLabel: "Cancel",
                    secondaryButtonAction: {
                        showDeleteAlert = false
                    }
                )
            }

            if showReminderAlert == true {
                CustomAlertView(
                    title: "Warning",
                    messages: ["Do you want to remove notification?"],
                    primaryButtonLabel: "OK",
                    primaryButtonAction: {
                        vm.removeNotification()
                        vm.isAlertSet = false
                        showReminderAlert = false
                    },
                    secondaryButtonLabel: "Cancel",
                    secondaryButtonAction: {
                        showReminderAlert = false
                    }
                )
            }

            VStack {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 5) {
                        HStack {
                            Text(vm.bet.name.uppercased())
                                .frame(maxWidth: .infinity, alignment: .center)
                                .font(.title3)
                                .bold()
                                .padding(.vertical, 16)
                        }
                        Spacer()
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
                                profitText: vm.bet.date.formatSelectedDate()
                            )
                            BetsDetailRow(
                                icon: "sportscourt",
                                labelText: "CATEGORY",
                                profitText: vm.bet.category.rawValue.uppercased()
                            )

                            BetsDetailRow(
                                icon: "banknote",
                                labelText: "AMOUNT",
                                profitText: vm.bet.amount.doubleValue.formattedWith2Digits(),
                                currency: vm.defaultCurrency.rawValue.uppercased()
                            )
                            BetsDetailRow(
                                icon: "dice",
                                labelText: "ODDS",
                                profitText: vm.bet.odds.doubleValue.formattedWith2Digits()
                            )

                            BetsDetailRow(
                                icon: "dollarsign.circle",
                                labelText: "TAX",
                                profitText: "\(vm.bet.tax.doubleValue.formattedWith2Digits()) %"
                            )

                            if vm.bet.isWon == true {
                                BetsDetailRow(
                                    icon: "arrow.up.forward",
                                    labelText: "NET PROFIT",
                                    profitText: vm.bet.score!.doubleValue.formattedWith2Digits(),
                                    currency: vm.defaultCurrency.rawValue.uppercased()
                                )
                            } else if vm.bet.isWon == false {
                                BetsDetailRow(
                                    icon: "arrow.down.forward",
                                    labelText: "YOUR LOSS",
                                    profitText: vm.bet.score!.doubleValue.formattedWith2Digits(),
                                    currency: vm.defaultCurrency.rawValue.uppercased()
                                )
                            } else {
                                BetsDetailRow(
                                    icon: "arrow.forward",
                                    labelText: "PREDICTED WIN",
                                    profitText: vm.bet.profit.doubleValue.formattedWith2Digits(),
                                    currency: vm.defaultCurrency.rawValue.uppercased()
                                )
                            }

                            if let note = vm.bet.note, !note.isEmpty {
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
                            } else {
                                EmptyView()
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 12)
                }
                .padding(.top, 1)
            }
            .safeAreaInset(edge: .top, alignment: .center, content: {
                VStack {
                    if vm.isAlertSet {
                        BetDetailHeader(title: "Your betslip", isNotificationOn: true) {
                            dismiss()
                        } onDelete: {
                            showDeleteAlert = true
                        } onNotification: {
                            showReminderAlert = true
                        }
                    } else {
                        BetDetailHeader(title: "Your betslip", isNotificationOn: false) {
                            dismiss()
                        } onDelete: {
                            showDeleteAlert = true
                        }
                    }
                }
            })
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
                                            vm.markBetWon()
                                            vm.removeNotification()
                                            dismiss()
                                        }
                                    MarkLostButton(text: "BET LOST")
                                        .onTapGesture {
                                            vm.markBetLost()
                                            vm.removeNotification()
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
                                        vm.markBetLost()
                                        dismiss()
                                    }
                                    .padding(.vertical, 12)

                            case .lost:
                                MarkWonButton(text: "Set as won")
                                    .padding(.horizontal, 64)
                                    .onTapGesture {
                                        vm.markBetWon()
                                        dismiss()
                                    }
                                    .padding(.vertical, 12)
                            }
                        }
                    }
                    .background {
                        if colorScheme == .dark {
                            // Dark mode-specific background
                            RoundedRectangle(cornerRadius: 0, style: .continuous)
                                .foregroundColor(Color.black.opacity(0.7))
                                .blur(radius: 12)
                                .ignoresSafeArea()

                        } else {
                            // Light mode-specific background
                            RoundedRectangle(cornerRadius: 0, style: .continuous)
                                .foregroundColor(Color.clear)
                                .background(Material.bar.opacity(0.7))
                                .blur(radius: 12)
                                .ignoresSafeArea()
                        }
                    }
                }
            )
            .navigationBarBackButtonHidden()
        }
    }
}
