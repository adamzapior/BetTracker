import SwiftUI

struct BetslipDetailsScreen: View {
    @StateObject var viewModel: BetslipDetailsViewModel
    @Environment(FeedTabRouter.self) private var router

    @State private var showDeleteAlert = false
    @State private var showReminderAlert = false

    init(betslip: BetslipModel) {
        _viewModel = StateObject(wrappedValue: BetslipDetailsViewModel(betslip: betslip))
    }

    var body: some View {
        ZStack {
            DeleteBetAlertView(isPresented: $showDeleteAlert, viewModel: viewModel)
                .environment(router)
            DeleteReminderBetAlertView(isPresented: $showReminderAlert, viewModel: viewModel)

            VStack {
                ScrollView(showsIndicators: false) {
                    headerView()
                    Divider()
                        .padding()
                    betslipDetailsView()
                    BetStatusActionView(viewModel: viewModel) {
                        viewModel.setBetslipTo(.won)
                        router.popToRoot()
                    } setToLost: {
                        viewModel.setBetslipTo(.lost)
                        router.popToRoot()
                    }
                }
                .padding(.top, 1)
                .accessibilityElement(children: .contain)
                .accessibilityLabel("Betslip details")
            }
        }
        .navigationTitle("Your betslip")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if viewModel.isAlertSet {
                    Image(systemName: "bell.fill")
                        .foregroundColor(Color.yellow)
                        .opacity(0.7)
                        .padding(.trailing, 6)
                        .onTapGesture {
                            showReminderAlert = true
                        }
                        .accessibilityLabel("Remove reminder")
                        .accessibilityHint("Tap to remove the reminder for this betslip")
                } else {
                    EmptyView()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Image(systemName: "trash")
                    .foregroundColor(Color.red)
                    .onTapGesture {
                        showDeleteAlert = true
                    }
                    .accessibilityLabel("Delete betslip")
                    .accessibilityHint("Tap to delete this betslip")
            }
        }
    }

    private func headerView() -> some View {
        VStack(spacing: 5) {
            HStack {
                Text(viewModel.betslip.name.uppercased())
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
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Betslip name: \(viewModel.betslip.name)")
    }

    private func betslipDetailsView() -> some View {
        VStack(spacing: 8) {
            Group {
                VStack {
                    HStack {
                        BetsDetailRowView(
                            labelText: "DATE",
                            valueText: viewModel.betslip.date.formatSelectedDate()
                        )
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Date: \(viewModel.betslip.date.formatSelectedDate())")

                        BetsDetailRowView(
                            labelText: "CATEGORY",
                            valueText: viewModel.betslip.category.rawValue.uppercased()
                        )
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Category: \(viewModel.betslip.category.rawValue)")
                    }
                    .fixedSize(horizontal: false, vertical: true)

                    HStack {
                        BetsDetailRowView(
                            labelText: "ODDS",
                            valueText: viewModel.betslip.odds.doubleValue.formattedWith2Digits()
                        )
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Odds: \(viewModel.betslip.odds.doubleValue.formattedWith2Digits())")

                        BetsDetailRowView(
                            labelText: "TAX",
                            valueText: "\(viewModel.betslip.tax.doubleValue.formattedWith2Digits()) %"
                        )
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Tax: \(viewModel.betslip.tax.doubleValue.formattedWith2Digits()) percent")
                    }
                    .fixedSize(horizontal: false, vertical: true)

                    BetsDetailRowView(
                        labelText: "AMOUNT",
                        valueText: viewModel.betslip.amount.doubleValue.formattedWith2Digits(),
                        currency: viewModel.defaultCurrency.rawValue.uppercased()
                    )
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Amount: \(viewModel.betslip.amount.doubleValue.formattedWith2Digits()) \(viewModel.defaultCurrency.rawValue.uppercased())")
                }
                .fixedSize(horizontal: false, vertical: true)

                switch viewModel.betslip.isWon {
                case true:
                    BetsDetailRowView(
                        labelText: "NET PROFIT",
                        valueText: viewModel.betslip.score!.doubleValue.formattedWith2Digits(),
                        currency: viewModel.defaultCurrency.rawValue.uppercased()
                    )
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Net profit: \(viewModel.betslip.score!.doubleValue.formattedWith2Digits()) \(viewModel.defaultCurrency.rawValue.uppercased())")
                case false:
                    BetsDetailRowView(
                        labelText: "YOUR LOSS",
                        valueText: viewModel.betslip.score!.doubleValue.formattedWith2Digits(),
                        currency: viewModel.defaultCurrency.rawValue.uppercased()
                    )
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Your loss: \(viewModel.betslip.score!.doubleValue.formattedWith2Digits()) \(viewModel.defaultCurrency.rawValue.uppercased())")
                case nil:
                    BetsDetailRowView(
                        labelText: "PREDICTED WIN",
                        valueText: viewModel.betslip.profit.doubleValue.formattedWith2Digits(),
                        currency: viewModel.defaultCurrency.rawValue.uppercased()
                    )
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Predicted win: \(viewModel.betslip.profit.doubleValue.formattedWith2Digits()) \(viewModel.defaultCurrency.rawValue.uppercased())")
                default:
                    EmptyView()
                }

                VStack {
                    if let note = viewModel.betslip.note, !note.isEmpty {
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
    }
}
