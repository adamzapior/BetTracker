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
            BetDetailHeader(title: "Your betslip", isNotificationOn: true) {
                dismiss()
            } onDelete: {
                vm.isShowingAlert = true
            }
            ScrollView(showsIndicators: false) {
                VStack(spacing: 5) {
                    HStack {
                        Text(vm.bet.name)
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
                            profitText: vm.bet.date.toString()
                        )
                        BetsDetailRow(
                            icon: "sportscourt",
                            labelText: "CATEGORY",
                            profitText: vm.bet.category.rawValue.uppercased()
                        )

                        BetsDetailRow(
                            icon: "banknote",
                            labelText: "AMOUNT",
                            profitText: vm.bet.amount.stringValue,
                            currency: vm.defaultCurrency.rawValue
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
                                profitText: vm.bet.score!.stringValue,
                                currency: vm.defaultCurrency.rawValue.uppercased()
                            )
                        } else if vm.bet.isWon == false {
                            BetsDetailRow(
                                icon: "arrow.down.forward",
                                labelText: "YOUR LOSS",
                                profitText: vm.bet.score!.stringValue,
                                currency: vm.defaultCurrency.rawValue.uppercased()
                            )
                        } else {
                            BetsDetailRow(
                                icon: "arrow.forward",
                                labelText: "PREDICTED WIN",
                                profitText: vm.bet.profit.stringValue,
                                currency: vm.defaultCurrency.rawValue.uppercased()
                            )
                        }

                        BetsDetailRow(
                            icon: "note",
                            labelText: "NOTE",
                            profitText: vm.bet.odds.doubleValue.formattedWith2Digits()
                        )
                        .standardShadow()
                    }
                }

                .frame(maxWidth: .infinity)
                .padding(.horizontal, 12)
            }
        }
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
                                        // TODO: vm and respository

                                        dismiss()
                                    }
                                MarkLostButton(text: "BET LOST")
                                    .onTapGesture {
                                        // TODO: vm and respository

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
                                    // TODO: vm and respository

                                    dismiss()
                                }
                                .padding(.vertical, 12)

                        case .lost:
                            MarkWonButton(text: "Set as won")
                                .padding(.horizontal, 64)
                                .onTapGesture {
                                    // TODO: vm and respository

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
