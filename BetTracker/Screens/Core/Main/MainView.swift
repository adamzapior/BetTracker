import Charts
import Combine
import SwiftDate
import SwiftUI

struct MainView: View {


    @StateObject
    var vm: MainViewVM
    
    let database = BetDao()
    
    init(database: BetDao) {
        let interactor = MainInteractor(db: database)
        _vm = StateObject(wrappedValue: MainViewVM(interactor: interactor))
    }


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
                if vm.pendingMerged!.isEmpty {
                    NoContentElement(text: "Add bet to show pending")
                } else {
                    LazyVStack(spacing: 12) {
                        LazyVStack(spacing: 12) {
                            ForEach(vm.pendingMerged!, id: \.id) { betWrapper in
                                switch betWrapper {
                                case let .bet(betModel):
                                    NavigationLink(
                                        destination: BetDetailsScreen(bet: betModel)
                                    ) {
                                        BetListElement(bet: betModel, currency: vm.currency)
                                    }
                                case let .betslip(betslipModel):
                                    NavigationLink(
                                        destination: BetslipDetailsScreen(bet: betslipModel)
                                    ) {
                                        BetslipListElement(bet: betslipModel, currency: vm.currency)
                                    }
                                }
                            }
                        }
                        .frame(minWidth: 5)
                        
                        
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

                if vm.mergedBets!.isEmpty {
                    NoContentElement(
                        text: "History is empty"
                    )
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach(vm.mergedBets!, id: \.id) { betWrapper in
                            switch betWrapper {
                            case let .bet(betModel):
                                NavigationLink(
                                    destination: BetDetailsScreen(bet: betModel)
                                ) {
                                    BetListElement(bet: betModel, currency: vm.currency)
                                }
                            case let .betslip(betslipModel):
                                NavigationLink(
                                    destination: BetslipDetailsScreen(bet: betslipModel)
                                ) {
                                    BetslipListElement(bet: betslipModel, currency: vm.currency)
                                }
                            }
                        }
                    }
                    .frame(minWidth: 5)
                    .onAppear {
                    }
                }
            }
            .background(Color.ui.background)
        }
    }
}
