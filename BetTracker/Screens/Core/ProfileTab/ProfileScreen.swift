import PhotosUI
import SwiftUI

struct ProfileScreen: View {
    typealias Destination = ProfileTabRouter.Destination
    @Environment(ProfileTabRouter.self) private var router
    @Environment(\.colorScheme) var colorScheme

    @StateObject var viewModel = ProfileViewModel()
    @StateObject var vmProfilePhoto = ProfilePhotoVM()

    var body: some View {
        @Bindable var router = router

        NavigationStack(path: $router.path) {
            profileScreenView
                .routerDestination(router: router, destination: navigationDestination)
        }
        .onDisappear {
            vmProfilePhoto.saveImageIfNeeded()
        }
        .onAppear {
            viewModel.loadUserDefaultsData()
        }
    }

    private var profileScreenView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                profileHeaderView
                statsSelectorView
                statsContentView
            }
            .padding(.horizontal)
        }
        .navigationTitle("Your stats")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                settingsButton
            }
        }
    }

    private var profileHeaderView: some View {
        VStack {
            EditableCircularProfileImage(vm: vmProfilePhoto)
            if !viewModel.username.isEmpty {
                Text(viewModel.username)
                    .font(.body)
                    .bold()
                    .padding(.top, 6)
            }
        }
    }

    private var statsSelectorView: some View {
        Picker("Select an option", selection: $viewModel.selectedStatsPeriod) {
            ForEach(StatsPeriod.allCases, id: \.self) { currentState in
                Text(LocalizedStringKey(currentState.rawValue))
            }
        }
        .pickerStyle(.menu)
        .tint(Color.ui.scheme)
        .accessibilityValue(viewModel.selectedStatsPeriod.rawValue)
        .accessibilityHint("Your stats will show data only from selected peroid")
    }

    private var statsContentView: some View {
        VStack(spacing: 12) {
            totalBalanceView
            HStack {
                totalSpentView
                wonRateView
            }
            betsCountView
            averageValuesView

            HStack {
                biggestProfitView
                biggestLossView
            }
            .fixedSize(horizontal: false, vertical: true)

            HStack {
                highestOddsWonView
                highestAmountView
            }
            .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var totalBalanceView: some View {
        Group {
            if let mgv = viewModel.mergedBalanceValue {
                BalanceStatsRowView(
                    cellTitle: "Your total balance",
                    valueText: mgv.doubleValue.formattedWith2Digits(),
                    font: .title2,
                    currency: viewModel.defaultCurrency.rawValue
                )
                .accessibilityLabel("Total spent cell")
                .accessibilityLabel("Total balance of your bets in selected peroid is \(mgv.doubleValue.formattedWith2Digits()) \(viewModel.defaultCurrency.rawValue)")
            } else {
                ProgressView()
            }
        }
    }

    private var totalSpentView: some View {
        Group {
            if let mts = viewModel.mergedTotalSpent {
                let totalSpentValue = mts.doubleValue.formattedWith2Digits()

                BalanceStatsRowView(
                    cellTitle: "Total spent",
                    valueText: totalSpentValue,
                    currency: viewModel.defaultCurrency.rawValue
                )
                .accessibilityLabel("Total spent cell")
                .accessibilityValue("You spent \(totalSpentValue) \(viewModel.defaultCurrency.rawValue) on your bets")
            } else {
                ProgressView()
            }
        }
    }

    private var wonRateView: some View {
        Group {
            if let wr = viewModel.wonRate {
                let wonRateValue = wr.doubleValue.formattedWith2Digits()

                BalanceStatsRowView(
                    cellTitle: "Won rate",
                    valueText: wonRateValue,
                    currency: "%"
                )
                .accessibilityLabel("Won rate cell")
                .accessibilityValue("You won \(wonRateValue) percent of your bets")
            } else {
                ProgressView()
            }
        }
    }

    private var betsCountView: some View {
        Group {
            if let mwc = viewModel.mergedWonBetsCount,
               let mlc = viewModel.mergedLostBetsCount
            {
                BetsInNumbersView(
                    wonValue: mwc.stringValue,
                    lostValue: mlc.stringValue
                )
                /// Accesibility is set up in child view
            } else {
                ProgressView()
            }
        }
    }

    private var averageValuesView: some View {
        Group {
            if let mvwb = viewModel.mergedAvgWonBet,
               let mvlb = viewModel.mergedAvgLostBet,
               let maab = viewModel.mergedAvgAmountBet
            {
                BetsInAverageView(
                    viewModel: viewModel,
                    averageWonValue: mvwb.doubleValue.formattedWith2Digits(),
                    averageLostValue: mvlb.doubleValue.formattedWith2Digits(),
                    averagePendingValue: maab.doubleValue.formattedWith2Digits()
                )
                /// Accesibility is set up in child view
            } else {
                ProgressView()
            }
        }
    }

    private var biggestProfitView: some View {
        Group {
            if let mlbp = viewModel.mergedLargestBetProfit {
                let biggestProfitValue = mlbp.doubleValue.formattedWith2Digits()

                BalanceStatsRowView(
                    cellTitle: "Biggest profit",
                    valueText: biggestProfitValue,
                    currency: viewModel.defaultCurrency.rawValue
                )
                .accessibilityLabel("Biggest profit cell")
                .accessibilityValue("Your biggest profit from one bet was \(biggestProfitValue) \(viewModel.defaultCurrency.rawValue)")
            } else {
                ProgressView()
            }
        }
    }

    private var biggestLossView: some View {
        Group {
            if let mbbl = viewModel.mergedBiggestBetLoss {
                let largestLossValue = mbbl.doubleValue.formattedWith2Digits()

                BalanceStatsRowView(
                    cellTitle: "Biggest loss",
                    valueText: largestLossValue,
                    currency: viewModel.defaultCurrency.rawValue
                )
                .accessibilityLabel("Biggest profit cell")
                .accessibilityValue("Your largest loss from one bet was \(largestLossValue) \(viewModel.defaultCurrency.rawValue)")
            } else {
                ProgressView()
            }
        }
    }

    private var highestOddsWonView: some View {
        Group {
            if let mhbo = viewModel.mergedHiggestBetOddsWon {
                let higgestOddsWonValue = mhbo.doubleValue.formattedWith2Digits()

                BalanceStatsRowView(
                    cellTitle: "Higest odds won",
                    valueText: higgestOddsWonValue,
                    currency: ""
                )
                .accessibilityLabel("Higest odds won cell")
                .accessibilityValue("Your biggest odds in won bet was \(higgestOddsWonValue)")
            } else {
                ProgressView()
            }
        }
    }

    private var highestAmountView: some View {
        Group {
            if let mhba = viewModel.mergedHiggestBetAmount {
                let highestBestAmountValue = mhba.doubleValue.formattedWith2Digits()

                BalanceStatsRowView(
                    cellTitle: "Higgest amount",
                    valueText: highestBestAmountValue,
                    currency: viewModel.defaultCurrency.rawValue.uppercased()
                )
                .accessibilityLabel("Higgest amount cell")
                .accessibilityValue("The largest amount of your bet was \(highestBestAmountValue) \(viewModel.defaultCurrency.rawValue)")
            } else {
                ProgressView()
            }
        }
    }

    private var settingsButton: some View {
        Image(systemName: "gear")
            .foregroundStyle(Color.ui.scheme)
            .accessibilityLabel("Settings")
            .accessibilityHint("Tap to open settings")
            .onTapGesture {
                router.navigate(to: .settings)
            }
    }

    @ViewBuilder private func navigationDestination(_ destination: Destination) -> some View {
        switch destination {
        case .settings:
            PreferencesScreen()
                .toolbar(.hidden, for: .tabBar)
        }
    }
}

// MARK: - BalanceStatsRowView

struct BalanceStatsRowView: View {
    let cellTitle: String
    let valueText: String
    let font: Font
    let currency: String

    init(cellTitle: String, valueText: String, font: Font = .headline, currency: String) {
        self.cellTitle = cellTitle
        self.valueText = valueText
        self.font = font
        self.currency = currency
    }

    var body: some View {
        VStack(spacing: 4) {
            Text(cellTitle)
                .font(.subheadline)
                .foregroundColor(Color.ui.onPrimaryContainer)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 12)
                .padding(.top, 6)

            Text(valueText)
                .bold()
                .font(font)
                .foregroundColor(Color.ui.secondary)
                .padding(.horizontal, 4)

            Text(currency)
                .textCase(.uppercase)
                .font(.subheadline)
                .foregroundColor(Color.ui.secondary)
        }
        .padding(.bottom, 6)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color.ui.onPrimary)
        )
        .standardShadow()
    }
}

// MARK: - BetsInNumbersView

struct BetsInNumbersView: View {
    let wonValue: String
    let lostValue: String

    var body: some View {
        VStack {
            Text("Your bets in numbers")
                .font(.subheadline)
                .foregroundColor(Color.ui.onPrimaryContainer)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(alignment: .center) {
                HStack(spacing: 48) {
                    VStack {
                        HStack {
                            Image(systemName: "flag.checkered.2.crossed")
                                .font(.title2)
                                .foregroundColor(Color.ui.scheme)
                                .padding(.bottom, 3)
                                .frame(width: 32, height: 32)
                        }
                        Text("Won")
                            .font(.caption2)
                            .foregroundColor(Color.ui.onPrimaryContainer)
                            .padding(.bottom, 3)

                        Text("\(wonValue)")
                            .font(.headline)
                            .foregroundColor(Color.ui.secondary)
                            .padding(.bottom, 6)
                    }
                    .padding(.vertical, 3)
                    .padding(.horizontal, 12)
                    .accessibilityElement(children: .ignore)
                    .accessibilityValue("You won \(wonValue) bets.")

                    VStack {
                        HStack {
                            Image(systemName: "flag.checkered.2.crossed")
                                .font(.title2)
                                .foregroundColor(Color.red)
                                .padding(.bottom, 3)
                                .frame(width: 32, height: 32)
                        }
                        Text("Lost")
                            .font(.caption2)
                            .foregroundColor(Color.ui.onPrimaryContainer)
                            .padding(.bottom, 3)

                        Text("\(lostValue)")
                            .font(.headline)
                            .foregroundColor(Color.ui.secondary)
                            .padding(.bottom, 6)
                    }
                    .padding(.vertical, 3)
                    .padding(.horizontal, 12)
                    .accessibilityElement(children: .ignore)
                    .accessibilityValue("You lost \(lostValue) bets.")
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color.ui.onPrimary)
        }
        .standardShadow()
        .accessibilityLabel("Bets in numbers cell")
    }
}

// MARK: - BetsInAverageView

struct BetsInAverageView: View {
    @ObservedObject var viewModel: ProfileViewModel

    let averageWonValue: String
    let averageLostValue: String
    let averagePendingValue: String

    var body: some View {
        VStack {
            Text("Average bets values")
                .font(.subheadline)
                .foregroundColor(Color.ui.onPrimaryContainer)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .leading, spacing: 4) {
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        Image(systemName: "arrow.up.forward")
                            .font(.title2)
                            .foregroundColor(Color.ui.scheme)
                            .padding(.bottom, 3)
                            .frame(width: 32, height: 32)
                        Text("AVG won")
                            .font(.caption2)
                            .foregroundColor(Color.ui.onPrimaryContainer)
                            .padding(.leading, 4)
                            .padding(.bottom, 3)
                            .frame(minWidth: 80, alignment: .leading)
                    }
                    HStack {
                        Spacer()
                        Text("\(averageWonValue)")
                            .font(.headline)
                            .foregroundColor(Color.ui.secondary)
                            .padding(.bottom, 6)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 30)
                        Text("\(viewModel.defaultCurrency.rawValue)")
                            .textCase(.uppercase)
                            .font(.subheadline)
                            .foregroundColor(Color.ui.secondary)
                            .padding(.bottom, 6)
                            .padding(.trailing, 18)
                    }
                }
                .padding(.vertical, 3)

                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        Image(systemName: "arrow.down.forward")
                            .font(.title2)
                            .foregroundColor(Color.red)
                            .padding(.bottom, 3)
                            .frame(width: 32, height: 32)
                        Text("AVG lost")
                            .font(.caption2)
                            .foregroundColor(Color.ui.onPrimaryContainer)
                            .padding(.leading, 4)
                            .padding(.bottom, 3)
                            .frame(minWidth: 80, alignment: .leading)
                    }
                    HStack {
                        Spacer()
                        Text("\(averageLostValue)")
                            .font(.headline)
                            .foregroundColor(Color.ui.secondary)
                            .padding(.bottom, 6)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 30)
                        Text("\(viewModel.defaultCurrency.rawValue)")
                            .textCase(.uppercase)
                            .font(.subheadline)
                            .foregroundColor(Color.ui.secondary)
                            .padding(.bottom, 6)
                            .padding(.trailing, 18)
                    }
                }
                .padding(.vertical, 3)

                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        Image(systemName: "arrow.forward")
                            .font(.title2)
                            .foregroundColor(Color.orange.opacity(0.7))
                            .padding(.bottom, 3)
                            .frame(width: 32, height: 32)
                        Text("AVG amount")
                            .font(.caption2)
                            .foregroundColor(Color.ui.onPrimaryContainer)
                            .padding(.leading, 4)
                            .padding(.bottom, 3)
                            .frame(minWidth: 80, alignment: .leading)
                    }
                    HStack {
                        Spacer()
                        Text("\(averagePendingValue)")
                            .font(.headline)
                            .foregroundColor(Color.ui.secondary)
                            .padding(.bottom, 6)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 30)
                        Text("\(viewModel.defaultCurrency.rawValue)")
                            .textCase(.uppercase)
                            .font(.subheadline)
                            .foregroundColor(Color.ui.secondary)
                            .padding(.bottom, 6)
                            .padding(.trailing, 18)
                    }
                }
                .padding(.vertical, 3)
            }

            .padding(.leading, 12)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color.ui.onPrimary)
        }
        .standardShadow()
    }
}
