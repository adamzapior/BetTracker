import SwiftUI

struct SearchView: View {
    @StateObject
    var vm = SearchVM()

    @State
    private var selectedSortOption: String = "All"

    var body: some View {
        LazyVStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(vm.sortOptions) { button in
                        SortButton(
                            text: button.rawValue.capitalized,
                            isChecked: vm.selectedSortOption == button
                        ) {
                            vm.selectedSortOption = button
                            switch button {
                            case .all:
                                vm.getSavedBets()
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
            .padding(.vertical, 2)
            ScrollView {
                ForEach(vm.searchResults ?? [], id: \.id) { bet in
                    NavigationLink(destination: BetDetailsScreen(bet: bet)) {
                        BetListElement(bet: bet, currency: vm.currency)
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

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
