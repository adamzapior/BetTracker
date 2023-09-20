import PhotosUI
import SwiftUI

struct ProfileView: View {

    @Environment(\.colorScheme)
    var colorScheme

    @StateObject
    var vm = ProfileVM(respository: Respository())

    @StateObject
    var vmProfilePhoto = ProfilePhotoVM()

    var body: some View {
        VStack {
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
                                if let mgv = vm.mergedBalanceValue {
                                    BalanceRow(
                                        cellTitle: "YOUR TOTAL BALANCE",
                                        valueText: mgv.doubleValue
                                            .formattedWith2Digits(),
                                        font: .title2,
                                        currency: vm.defaultCurrency.rawValue.uppercased()
                                    )
                                    .padding(.horizontal, 12)
                                } else {
                                    ProgressView()
                                }

                                HStack {
                                    if let mts = vm.mergedTotalSpent {
                                        BalanceRow(
                                            cellTitle: "TOTAL SPENT",
                                            valueText: mts.doubleValue
                                                .formattedWith2Digits(),
                                            currency: vm.defaultCurrency.rawValue.uppercased()
                                        )
                                    } else {
                                        ProgressView()
                                    }

                                    if let wr = vm.wonRate {
                                        BalanceRow(
                                            cellTitle: "WON RATE",
                                            valueText: wr.doubleValue.formattedWith2Digits(),
                                            currency: "%"
                                        )
                                    } else {
                                        ProgressView()
                                    }
                                }
                                .padding(.horizontal, 12)

                                if let mpc = vm.mergedPendingBetsCount,
                                   let mwc = vm.mergedWonBetsCount,
                                   let mlc = vm.mergedLostBetsCount {
                                    BetCountRow(
                                        labelText: "YOUR BETS IN NUMBERS",
                                        icon: "flag.and.flag.filled.crossed",
                                        icon2: "flag.checkered.2.crossed",
                                        icon3: "flag.checkered.2.crossed",
                                        text: "PENDING",
                                        text2: "WON",
                                        text3: "LOST",
                                        betsPendingText: mpc.stringValue,
                                        betsPendingText2: mwc.stringValue,
                                        betsPendingText3: mlc.stringValue
                                    )
                                    .padding(.horizontal, 12)
                                } else {
                                    ProgressView()
                                }

                                if let mvwb = vm.mergedAvgWonBet,
                                   let mvlb = vm.mergedAvgLostBet,
                                   let maab = vm.mergedAvgAmountBet {
                                    BetAverageRow(
                                        labelText: "AVERAGE VALUES",
                                        icon: "arrow.up.forward",
                                        icon2: "arrow.down.forward",
                                        icon3: "arrow.forward",
                                        text1: "AVG WON",
                                        text2: "AVG LOSE",
                                        text3: "AVG AMOUNT",
                                        betsPendingText: mvwb.doubleValue
                                            .formattedWith2Digits(),
                                        betsPendingText2: mvlb.doubleValue
                                            .formattedWith2Digits(),
                                        betsPendingText3: maab.doubleValue
                                            .formattedWith2Digits(),
                                        currency: vm.defaultCurrency.rawValue.uppercased()
                                    )
                                    .padding(.horizontal, 12)
                                } else {
                                    ProgressView()
                                }

                                HStack {
                                    if let mlbp = vm.mergedLargestBetProfit {
                                        BalanceRow(
                                            cellTitle: "BIGGEST PROFIT",
                                            valueText: mlbp.doubleValue
                                                .formattedWith2Digits(),
                                            currency: vm.defaultCurrency.rawValue.uppercased()
                                        )
                                    } else {
                                        ProgressView()
                                    }
                                    if let mbbl = vm.mergedBiggestBetLoss {
                                        BalanceRow(
                                            cellTitle: "BIGGEST LOSS",
                                            valueText: mbbl.doubleValue
                                                .formattedWith2Digits(),
                                            currency: vm.defaultCurrency.rawValue.uppercased()
                                        )
                                    } else {
                                        ProgressView()
                                    }
                                }
                                .padding(.horizontal, 12)

                                HStack {
                                    if let mhbo = vm.mergedHiggestBetOddsWon {
                                        BalanceRow(
                                            cellTitle: "HIGHEST ODDS WON",
                                            valueText: mhbo.doubleValue
                                                .formattedWith2Digits(),
                                            currency: ""
                                        )
                                    } else {
                                        ProgressView()
                                    }

                                    if let mhba = vm.mergedHiggestBetAmount {
                                        BalanceRow(
                                            cellTitle: "HIGGEST AMOUNT",
                                            valueText: mhba.doubleValue
                                                .formattedWith2Digits(),
                                            currency: vm.defaultCurrency.rawValue.uppercased()
                                        )
                                    } else {
                                        ProgressView()
                                    }
                                }
                                .padding(.horizontal, 12)
                            }
                            .padding(.horizontal, 12)
                        }
                    }
                    .padding(.bottom, 64)
                    .animation(.easeInOut, value: vm.currentStatsState)
                }
            }
            .padding(
                .top,
                1
            )
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, -8)
        }
        .safeAreaInset(edge: .top, content: {
            MainHeader(
                name: "Your stats",
                destinationView: { AnyView(PreferencesView()) },
                icon: "gear"
            )
        })
        .background(Color.ui.background)
        .onDisappear {
            vmProfilePhoto.saveImageIfNeeded()
        }
        .onAppear {
            vm.loadUserDefaultsData()
        }
    }
}
