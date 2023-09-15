import SwiftUI

struct SearchView: View {

    @StateObject
    var vm = SearchVM(respository: Respository())

    @State
    private var selectedSortOption: String = "All"

    var body: some View {
        VStack {
            VStack {
                HStack(spacing: 8) {
                    ForEach(vm.sortOptions) { button in
                        SortButton(
                            text: button.rawValue.capitalized,
                            isChecked: vm.selectedSortOption == button
                        ) {
                            vm.selectedSortOption = button
                            switch button {
                            case .all:
                                vm.allBets()
                            case .oldest:
                                vm.getBetsFormTheOldestDate()
                            case .won:
                                vm.getWonBets()
                            case .lost:
                                vm.getLostBets()
                            case .amount:
                                vm.getBetsByAmount()
                            }
                        }
                    }
                }
                .padding(.horizontal, 12)
            }
            .shadow(
                color: Color.ui.shadow,
                radius: 25, x: 0, y: 0
            )
            .padding(.vertical, 4)
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(vm.searchResults!, id: \.id) { betWrapper in
                        switch betWrapper {
                        case let .bet(betModel):
                            NavigationLink(
                                destination: BetDetailsView(bet: betModel)
                            ) {
                                BetCell(bet: betModel, currency: vm.defaultCurrency.rawValue)
                            }
                        case let .betslip(betslipModel):
                            NavigationLink(
                                destination: BetslipDetailsView(bet: betslipModel)
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
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .padding(.top, 6)
        .navigationBarBackButtonHidden(true)
        .safeAreaInset(edge: .top) {
            SearchBarView(searchText: $vm.searchText)
                .padding(.top, 6)
                .padding(.horizontal, 12)
        }
    }

}
