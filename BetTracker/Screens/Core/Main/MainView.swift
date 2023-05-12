import Charts
import Combine
import SwiftDate
import SwiftUI

struct MainView2: View {

    @StateObject

                .padding(.top, 18)
                .padding(.bottom, 26)

            ScrollView {
//                if vm.historyBets?.isEmpty == false {
//                    Chart(vm.historyBets ?? vm.bet) { item in
//                        BarMark(x: .value("Date", item.date.oneWeekView() ), y: .value("Bet prodit", item.profit))
//                    }
//                }

                if vm.pendingBets!.isEmpty {
                    HStack {
                        BetButton(text: "Pending")
                        Spacer()
                        Spacer()
                    }
                    .padding(.horizontal, 22)
                    .padding(.bottom, 1)
                }

                if vm.pendingBets!.isEmpty {
                    NoContentElement(text: "History is empty")
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach(vm.pendingBets!, id: \.id) { bet in

                            NavigationLink(destination: BetDetailsScreen(bet: bet)) {
                                BetListElement(bet: bet, currency: vm.currency)
                            }
                        }
                    }
                    .padding(.bottom, 24)
                }

                HStack {
                    BetButton(text: "History")
                    Spacer()
                    Text("") // hack
                }
                .padding(.horizontal, 22)
                .padding(.bottom, 1)
                if vm.historyBets!.isEmpty {
                    NoContentElement(text: "History is empty")
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach(vm.historyBets!, id: \.id) { bet in
                            NavigationLink(destination: BetDetailsScreen(bet: bet)) {
                                BetListElement(bet: bet, currency: vm.currency)
                            }
                        }
                    }
                }
            }
        }
        .background(Color.ui.background)
        .onAppear {
            print(vm.pendingBets!)
        }
    }
}

struct MainView: View {

    @StateObject
    var vm = MainViewVM()

    var body: some View {
        VStack(spacing: 0) {
            MainHeader()
                .padding(.top, 18)
                .padding(.bottom, 26)
            ScrollView {
                HStack {
                    BetButton(text: "Pending")
                    Spacer()
                    Spacer()
                }
                .padding(.horizontal, 22)
                .padding(.bottom, 1)
                if vm.pendingBets!.isEmpty {
                    NoContentElement(text: "Add bet to show pending")
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach(vm.pendingBets!, id: \.id) { bet in
                            NavigationLink(destination: BetDetailsScreen(bet: bet)) {
                                BetListElement(bet: bet, currency: vm.currency)
                            }
                        }
                    }
                    .padding(.bottom, 24)
                }

                HStack {
                    BetButton(text: "History")
                    Spacer()
                    Text("") // hack
                }
                .padding(.horizontal, 22)
                .padding(.bottom, 1)

                if vm.historyBets!.isEmpty {
                    NoContentElement(
                        text: "History is empty"
                    )
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach(
                            vm.historyBets!,
                            id: \.id
                        ) { bet in
                            NavigationLink(
                                destination: BetDetailsScreen(bet: bet)
                            ) {
                                BetListElement(
                                    bet: bet,
                                    currency: vm
                                        .currency
                                )
                            }
                        }
                    }
                }
            }
        }
        .background(Color.ui.background)
    }
}
