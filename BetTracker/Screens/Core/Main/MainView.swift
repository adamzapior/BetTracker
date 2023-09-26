import Charts
import Combine
import SwiftUI

struct MainView: View {

    @StateObject
    var vm: MainViewVM

    init() {
        _vm = StateObject(wrappedValue: MainViewVM())
    }

    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    VStack {
                        if vm.pendingMerged!.isEmpty {
                            EmptyView()
                        } else {
                            HStack {
                                MainLabel(text: "Pending")
                                Spacer()
                                Spacer()
                            }
                            .padding(.horizontal, 22)
                            .padding(.bottom, 1)
                        }

                        if vm.pendingMerged!.isEmpty {
                            EmptyView()

                        } else if vm.isPendingMergedCompleted == false {
                            ProgressView()
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(
                                    vm.pendingMerged!,
                                    id: \.id
                                ) { betWrapper in
                                    switch betWrapper {
                                    case let .bet(betModel):
                                        NavigationLink(
                                            destination: BetDetailsView(
                                                bet: betModel
                                            )
                                        ) {
                                            BetCell(
                                                bet: betModel,
                                                currency: vm.defaultCurrency.rawValue
                                            )
                                        }
                                    case let .betslip(betslipModel):
                                        NavigationLink(
                                            destination: BetslipDetailsView(
                                                bet: betslipModel
                                            )
                                        ) {
                                            BetslipCell(
                                                bet: betslipModel,
                                                currency: vm.defaultCurrency.rawValue
                                            )
                                        }
                                    }
                                }
                            }
                            .padding(.bottom, 24)
                        }
                    }

                    VStack {
                        HStack {
                            MainLabel(text: "History")
                            Spacer()
                            Spacer()
                        }
                        .padding(.horizontal, 22)
                        .padding(.bottom, 1)

                        if vm.historyMerged!.isEmpty {
                            VStack {
                                Text("History is empty")
                            }
                            .padding(.vertical, 48)
                        } else if vm.isHistoryMergedCompleted == false {
                            ProgressView()
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(vm.historyMerged!, id: \.id) { betWrapper in
                                    switch betWrapper {
                                    case let .bet(betModel):
                                        NavigationLink(
                                            destination: BetDetailsView(
                                                bet: betModel
                                            )
                                        ) {
                                            BetCell(
                                                bet: betModel,
                                                currency: vm.defaultCurrency.rawValue
                                            )
                                        }
                                    case let .betslip(betslipModel):
                                        NavigationLink(
                                            destination: BetslipDetailsView(
                                                bet: betslipModel
                                            )
                                        ) {
                                            BetslipCell(
                                                bet: betslipModel,
                                                currency: vm.defaultCurrency.rawValue
                                            )
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.bottom, 64)
                }
            }
            .padding(
                .top,
                1
            )
        }
        .background(Color.ui.background)
        .safeAreaInset(edge: .top, content: {
            if vm.showUsername == true {
                MainHeader(
                    name: "Welcome \(vm.username)!",
                    destinationView: { AnyView(SearchView()) },
                    icon: "magnifyingglass"
                )
            } else {
                MainHeader(
                    name: "Welcome!",
                    destinationView: { AnyView(SearchView()) },
                    icon: "magnifyingglass"
                )
            }
        })
    }
}
