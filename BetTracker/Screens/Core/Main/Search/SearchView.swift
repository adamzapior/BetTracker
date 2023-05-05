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
                    SortButton(text: "All", isChecked: vm.selectedSortOption == .all) {
                        vm.selectedSortOption = .all
                        vm.getSavedBets()
                    }
                    SortButton(text: "Oldest", isChecked: vm.selectedSortOption == .oldest) {
                        vm.selectedSortOption = .oldest
                        vm.getBetsFormTheOldestDate()
                    }
                    SortButton(text: "Won", isChecked: vm.selectedSortOption == .won) {
                        vm.selectedSortOption = .won
                        vm.getWonBets()
                    }
                    SortButton(text: "Lost", isChecked: vm.selectedSortOption == .lost) {
                        vm.selectedSortOption = .lost
                        vm.getLostBets()
                    }
                    SortButton(text: "Amount", isChecked: vm.selectedSortOption == .amount) {
                        vm.selectedSortOption = .amount
                        vm.getBetsByAmount()
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
