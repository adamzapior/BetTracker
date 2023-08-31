import PhotosUI
import SwiftUI

struct ProfileView: View {

    @Environment(\.colorScheme)
    var colorScheme

    @StateObject
    var vm = ProfileVM(respository: MainInteractor(db: BetDao()))

    @StateObject
    var vmProfilePhoto = ProfilePhotoVM()

    var body: some View {
        VStack {
            MainHeader(
                name: "Your stats",
                destinationView: { AnyView(PreferencesView()) },
                icon: "gear"
            )
            .padding(.top, 18)
            .padding(.bottom, 26)

            ScrollView(showsIndicators: false) {
                EditableCircularProfileImage(vm: vmProfilePhoto)

                if !vm.username.isEmpty {
                    Text(vm.username)
                        .font(.body)
                        .bold()
                        .padding(.top, 6)
                }

                HStack {
                    Picker("Select an option", selection: $vm.currentStatsState) {
                        ForEach(StatsState.allCases, id: \.self) { currentState in
                            Text(currentState.rawValue)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .pickerStyle(.menu)
                .tint(Color.ui.scheme)

                if vm.isLoading {
                    ProgressView()
                } else {
                    ZStack {
                        Group {
                            VStack(spacing: 12) {
                                BalanceRow(
                                    cellTitle: "YOUR TOTAL BALANCE",
                                    valueText: vm.mergedBalanceValue.doubleValue
                                        .formattedWith2Digits(),
                                    font: .title2,
                                    currency: vm.defaultCurrency.uppercased()
                                )

                                HStack {
                                    if let mts = vm.mergedTotalSpent {
                                        BalanceRow(
                                            cellTitle: "TOTAL SPENT",
                                            valueText: mts.doubleValue
                                                .formattedWith2Digits(),
                                            currency: vm.defaultCurrency.uppercased()
                                        )
                                    } else {
                                        ProgressView()
                                    }

                                    BalanceRow(
                                        cellTitle: "WON RATE",
                                        valueText: vm.wonRate.formattedWith2Digits(),
                                        currency: "%"
                                    )
                                }

                                BetCountRow(
                                    labelText: "YOUR BETS IN NUMBERS",
                                    icon: "flag.and.flag.filled.crossed",
                                    icon2: "flag.checkered.2.crossed",
                                    icon3: "flag.checkered.2.crossed",
                                    text: "PENDING",
                                    text2: "WON",
                                    text3: "LOST",
                                    betsPendingText: vm.mergedPendingBetsCount.stringValue,
                                    betsPendingText2: vm.mergedWonBetsCount.stringValue,
                                    betsPendingText3: vm.mergedLostBetsCount.stringValue
                                )

                                BetAverageRow(
                                    labelText: "AVERAGE VALUES",
                                    icon: "arrow.up.forward",
                                    icon2: "arrow.down.forward",
                                    icon3: "arrow.forward",
                                    text1: "AVG WON",
                                    text2: "AVG LOSE",
                                    text3: "AVG AMOUNT",
                                    betsPendingText: vm.mergedAvgWonBet.doubleValue
                                        .formattedWith2Digits(),
                                    betsPendingText2: vm.mergedAvgLostBet.doubleValue
                                        .formattedWith2Digits(),
                                    betsPendingText3: vm.mergedAvgAmountBet.doubleValue
                                        .formattedWith2Digits(),
                                    currency: vm.defaultCurrency.uppercased()
                                )

                                HStack {
                                    BalanceRow(
                                        cellTitle: "BIGGEST PROFIT",
                                        valueText: vm.mergedLargestBetProfit.stringValue,
                                        currency: vm.defaultCurrency.uppercased()
                                    )
                                    BalanceRow(
                                        cellTitle: "BIGGEST LOSS",
                                        valueText: vm.mergedBiggestBetLoss.stringValue,
                                        currency: vm.defaultCurrency.uppercased()
                                    )
                                }
                                HStack {
                                    BalanceRow(
                                        cellTitle: "HIGHEST ODDS WON",
                                        valueText: vm.mergedHiggestBetOddsWon.doubleValue
                                            .formattedWith2Digits(),
                                        currency: vm.defaultCurrency.uppercased()
                                    )
                                    BalanceRow(
                                        cellTitle: "HIGGEST AMOUNT",
                                        valueText: vm.mergedHiggestBetAmount.stringValue,
                                        currency: vm.defaultCurrency.uppercased()
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .animation(.easeInOut, value: vm.currentStatsState)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, -8)
        }
        .background(Color.ui.background)
        .onDisappear {
            vmProfilePhoto.saveImageIfNeeded()
        }
    }
}
