import SwiftUI

struct SearchView: View {
    
    @StateObject
    var vm = SearchVM(interactor: SearchInteractor(db: BetDao()))

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
//                .shadow(color: Color.ui.scheme.opacity(0.5), radius: 3, x: 3, y: 3)
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
                                destination: BetDetailsScreen(bet: betModel)
                            ) {
                                BetListElement(bet: betModel, currency: vm.currency.rawValue)
                            }
                        case let .betslip(betslipModel):
                            NavigationLink(
                                destination: BetslipDetailsScreen(bet: betslipModel)
                            ) {
                                BetslipListElement(
                                    bet: betslipModel,
                                    currency: vm.currency.rawValue
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
//                .shadow(color: Color.ui.scheme.opacity(0.2), radius: 6, x: 3, y: 3)
        }
    }

}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
