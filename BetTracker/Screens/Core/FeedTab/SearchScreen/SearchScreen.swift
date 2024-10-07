import SwiftUI

struct SearchScreen: View {
    @Environment(FeedTabRouter.self) private var router

    @StateObject
    var vm = SearchVM()

    @State
    private var selectedSortOption: String = "All"

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                SearchBarView(searchText: $vm.searchText)
                    .padding(.top, 6)
                    .padding(.horizontal, 12)
                SortButtonsView(vm: vm)

                LazyVStack(spacing: 12) {
                    ForEach(vm.searchResults!, id: \.id) { betWrapper in
                        switch betWrapper {
                        case let .bet(betModel):
                            BetCellView(
                                bet: betModel,
                                currency: vm.defaultCurrency.rawValue
                            )
                            .onTapGesture {
                                router.navigate(to: .bet(betModel))
                            }
                        case let .betslip(betslipModel):
                            BetslipCellView(
                                bet: betslipModel,
                                currency: vm.defaultCurrency.rawValue
                            )
                            .onTapGesture {
                                router.navigate(to: .betslip(betslipModel))
                            }
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 64)
            }
        }
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .padding(.top, 6)
    }
}

struct SortButtonsView: View {
    @ObservedObject var vm: SearchVM

    var body: some View {
        VStack {
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
        }
        .shadow(
            color: Color.ui.shadow,
            radius: 25, x: 0, y: 0
        )
        .padding(.vertical, 4)
    }
}
