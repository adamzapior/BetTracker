import Charts
import Combine
import SwiftDate
import SwiftUI

struct MainView: View {

    let database = BetDao()

    @StateObject
    var vm: MainViewVM

    init(database _: BetDao) {
        let respository = Respository()
        _vm = StateObject(wrappedValue: MainViewVM(respository: respository))
    }

    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    VStack {
                        HStack {
                            MainLabel(text: "Pending")
                            Spacer()
                            Spacer()
                        }
                        .padding(.horizontal, 22)
                        .padding(.bottom, 1)

                        if vm.pendingMerged!.isEmpty {
                            VStack {
                                Text("Add bet to show pending")
                            }
                            .padding(.vertical, 48)
                            
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
                            Text("") // hack
                        }
                        .padding(.horizontal, 22)
                        .padding(.bottom, 1)

                        if vm.mergedBets!.isEmpty {
                            VStack {
                                Text("History is empty")
                            }
                            .padding(.vertical, 48)
                        } else if vm.isHistoryMergedCompleted == false {
                            ProgressView()
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(vm.mergedBets!, id: \.id) { betWrapper in
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
