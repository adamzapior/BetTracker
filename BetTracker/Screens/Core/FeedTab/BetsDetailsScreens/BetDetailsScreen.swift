import SwiftUI

struct BetDetailsScreen: View {
    @StateObject var viewModel: BetDetailsViewModel
    @Environment(FeedTabRouter.self) private var router

    @State private var isDeleteAlertPresented = false
    @State private var isReminderAlertPresented = false

    init(bet: BetModel) {
        _viewModel = StateObject(wrappedValue: BetDetailsViewModel(bet: bet))
    }

    var body: some View {
        ZStack {
            deleteReminderAlertView()
            deleteBetAlertView()

            VStack {
                ScrollView(showsIndicators: false) {
                    headerView()
                    Divider()
                        .padding()
                    betDetailsView()
                    BetStatusActionView(viewModel: viewModel) {
                        viewModel.setBetTo(.won)
                        router.popToRoot()
                    } setToLost: {
                        viewModel.setBetTo(.lost)
                        router.popToRoot()
                    }
                }
                .padding(.top, 1)
                .accessibilityElement(children: .contain)
                .accessibilityLabel("Bet details")
            }
        }
        .navigationTitle("Your bet")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if viewModel.isAlertSet {
                    Image(systemName: "bell.fill")
                        .foregroundColor(Color.yellow)
                        .opacity(0.7)
                        .padding(.trailing, 6)
                        .onTapGesture {
                            isReminderAlertPresented = true
                        }
                        .accessibilityLabel("Remove reminder")
                        .accessibilityHint("Tap to remove the reminder for this bet")
                } else {
                    EmptyView()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Image(systemName: "trash")
                    .foregroundColor(Color.red)
                    .onTapGesture {
                        isDeleteAlertPresented = true
                    }
                    .accessibilityLabel("Delete bet")
                    .accessibilityHint("Tap to delete this bet")
            }
        }
    }

    private func headerView() -> some View {
        VStack(spacing: 5) {
            HStack {
                Text(viewModel.bet.team1.uppercased())
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.title3)
                    .bold()
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .foregroundColor(
                        viewModel.bet.selectedTeam == .team1
                            ? Color.ui.scheme
                            : Color.ui.secondary
                    )
            }
            Text("vs.")
                .font(.body)
            HStack {
                Text(viewModel.bet.team2.uppercased())
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.title3)
                    .bold()
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .foregroundColor(
                        viewModel.bet.selectedTeam == .team2
                            ? Color.ui.scheme
                            : Color.ui.secondary
                    )
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Match: \(viewModel.bet.team1) versus \(viewModel.bet.team2)")
        .accessibilityHint("Selected team: \(viewModel.bet.selectedTeam == .team1 ? viewModel.bet.team1 : viewModel.bet.team2)")
    }

    private func betDetailsView() -> some View {
        VStack(spacing: 8) {
            Group {
                VStack {
                    HStack {
                        BetsDetailRowView(
                            labelText: "DATE",
                            valueText: viewModel.bet.date.formatSelectedDate()
                        )
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Date: \(viewModel.bet.date.formatSelectedDate())")

                        BetsDetailRowView(
                            labelText: "SPORT",
                            valueText: viewModel.bet.category.rawValue.capitalized
                        )
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Sport: \(viewModel.bet.category.rawValue.capitalized)")
                    }
                    .fixedSize(horizontal: false, vertical: true)

                    HStack {
                        BetsDetailRowView(
                            labelText: "ODDS",
                            valueText: viewModel.bet.odds.doubleValue.formattedWith2Digits()
                        )
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Odds: \(viewModel.bet.odds.doubleValue.formattedWith2Digits())")

                        BetsDetailRowView(
                            labelText: "TAX",
                            valueText: "\(viewModel.bet.tax.doubleValue.formattedWith2Digits()) %"
                        )
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Tax: \(viewModel.bet.tax.doubleValue.formattedWith2Digits()) percent")
                    }
                    .fixedSize(horizontal: false, vertical: true)

                    BetsDetailRowView(
                        labelText: "AMOUNT",
                        valueText: viewModel.bet.amount.doubleValue.formattedWith2Digits(),
                        currency: viewModel.defaultCurrency.rawValue.uppercased()
                    )
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Amount: \(viewModel.bet.amount.doubleValue.formattedWith2Digits()) \(viewModel.defaultCurrency.rawValue.uppercased())")
                }
                .fixedSize(horizontal: false, vertical: true)

                switch viewModel.bet.isWon {
                case true:
                    BetsDetailRowView(
                        labelText: "NET PROFIT",
                        valueText: viewModel.bet.score!.doubleValue.formattedWith2Digits(),
                        currency: viewModel.defaultCurrency.rawValue.uppercased()
                    )
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Net profit: \(viewModel.bet.score!.doubleValue.formattedWith2Digits()) \(viewModel.defaultCurrency.rawValue.uppercased())")
                case false:
                    BetsDetailRowView(
                        labelText: "YOUR LOSS",
                        valueText: viewModel.bet.score!.doubleValue.formattedWith2Digits(),
                        currency: viewModel.defaultCurrency.rawValue.uppercased()
                    )
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Your loss: \(viewModel.bet.score!.doubleValue.formattedWith2Digits()) \(viewModel.defaultCurrency.rawValue.uppercased())")
                case nil:
                    BetsDetailRowView(
                        labelText: "PREDICTED WIN",
                        valueText: viewModel.bet.profit.doubleValue.formattedWith2Digits(),
                        currency: viewModel.defaultCurrency.rawValue.uppercased()
                    )
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Predicted win: \(viewModel.bet.profit.doubleValue.formattedWith2Digits()) \(viewModel.defaultCurrency.rawValue.uppercased())")
                default:
                    EmptyView()
                }

                VStack {
                    if let note = viewModel.bet.note, !note.isEmpty {
                        BetsDetailRowView(
                            labelText: "NOTE",
                            valueText: note
                        )
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Note: \(note)")
                    } else {
                        EmptyView()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 12)
        .padding(.bottom, 12)
    }
    
    private func deleteBetAlertView() -> some View {
        CustomAlertView(
            isPresented: $isDeleteAlertPresented,
            title: "Warning",
            messages: ["Do you want to delete bet?"],
            primaryButtonLabel: "OK",
            primaryButtonAction: {
                viewModel.deleteBet()
                viewModel.deleteBetNotification()
                router.popToRoot()
            },
            secondaryButtonLabel: "Cancel",
            secondaryButtonAction: { isDeleteAlertPresented = false }
        )
    }
    
    private func deleteReminderAlertView() -> some View {
        CustomAlertView(
            isPresented: $isReminderAlertPresented,
            title: "Warning",
            messages: ["Do you want to remove notification?"],
            primaryButtonLabel: "OK",
            primaryButtonAction: {
                viewModel.deleteBetNotification()
                viewModel.isAlertSet = false
                isReminderAlertPresented = false
            },
            secondaryButtonLabel: "Cancel",
            secondaryButtonAction: { isReminderAlertPresented = false }
        )
    }
}
