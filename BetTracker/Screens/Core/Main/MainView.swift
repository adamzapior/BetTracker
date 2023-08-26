import Charts
import Combine
import SwiftDate
import SwiftUI

struct MainView: View {
    @State
    private var selectedBetModel: BetModel? = nil

    @StateObject
    var vm: MainViewVM

    let database = BetDao()

    init(database: BetDao) {
        let respository = MainInteractor(db: database)
        _vm = StateObject(wrappedValue: MainViewVM(respository: respository))
    }

    var body: some View {
        VStack(spacing: 0) {
            if vm.showUsername == true {
                MainHeader(name: "Welcome \(vm.username)!")
                    .padding(.top, 18)
                    .padding(.bottom, 26)
            } else {
                MainHeader(name: "Welcome!")
                    .padding(.top, 18)
                    .padding(.bottom, 26)
            }
            ScrollView {
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
                            NoContentElement(text: "Add bet to show pending")
                        } else {
                            LazyVStack(spacing: 12) {
                                LazyVStack(spacing: 12) {
                                    ForEach(
                                        vm.pendingMerged!,
                                        id: \.id
                                    ) { betWrapper in
                                        switch betWrapper {
                                        case let .bet(betModel):
                                            NavigationLink(
                                                destination: BetDetailsScreen(
                                                    bet: betModel
                                                )
                                            ) {
                                                BetListElement(
                                                    bet: betModel,
                                                    currency: vm.defaultCurrency.rawValue
                                                )
                                            }
                                        case let .betslip(betslipModel):
                                            NavigationLink(
                                                destination: BetslipDetailsScreen(
                                                    bet: betslipModel
                                                )
                                            ) {
                                                BetslipListElement(
                                                    bet: betslipModel,
                                                    currency: vm.defaultCurrency.rawValue
                                                )
                                            }
                                        }
                                    }
                                }
                                .frame(minWidth: 5)
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

                        if vm.isMergedCompleted && ((vm.mergedBets?.isEmpty) != nil) {
                            NoContentElement(
                                text: "History is empty"
                            )
                        } else if vm.isMergedCompleted == false {
                            ProgressView()
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(vm.mergedBets!, id: \.id) { betWrapper in
                                    switch betWrapper {
                                    case let .bet(betModel):
                                        NavigationLink(
                                            destination: BetDetailsScreen(
                                                bet: betModel
                                            )
                                        ) {
                                            BetListElement(
                                                bet: betModel,
                                                currency: vm.defaultCurrency.rawValue
                                            )
                                        }
                                    case let .betslip(betslipModel):
                                        NavigationLink(
                                            destination: BetslipDetailsScreen(
                                                bet: betslipModel
                                            )
                                        ) {
                                            BetslipListElement(
                                                bet: betslipModel,
                                                currency: vm.defaultCurrency.rawValue
                                            )
                                        }
                                    }
                                }
                            }
                            .frame(minWidth: 5)
                            .onAppear { }
                        }
                    }
                }
            }
            .background(Color.ui.background)
        }
    }
}
