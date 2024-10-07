import Combine
import SwiftUI

struct FeedScreen: View {
    typealias Destination = FeedTabRouter.Destination
    
    private let navigationTitle = ContentView.Tab.a.title
    @Environment(FeedTabRouter.self) private var router

    @StateObject var vm = FeedViewModel()

    var body: some View {
        @Bindable var router = router
        
        NavigationStack(path: $router.path) {
            mainView
                .routerDestination(router: router, destination: navigationDestination)
        }
    }
    
    private var mainView: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    VStack {
                        if vm.pendingMerged!.isEmpty {
                            EmptyView()
                        } else {
                            HStack {
                                BetTypeCapsuleView(text: "Pending")
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
                                        BetCellView(bet: betModel, currency: vm.defaultCurrency.rawValue)
                                            .onTapGesture {
                                                router.navigate(to: .bet(betModel))
                                            }
                                    case let .betslip(betslipModel):
                                        BetslipCellView(bet: betslipModel, currency: vm.defaultCurrency.rawValue)
                                            .onTapGesture {
                                                router.navigate(to: .betslip(betslipModel))
                                            }
                                    }
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.bottom, 24)
                        }
                    }
                    
                    VStack {
                        HStack {
                            BetTypeCapsuleView(text: "History")
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
                                        BetCellView(bet: betModel, currency: vm.defaultCurrency.rawValue)
                                            .onTapGesture {
                                                router.navigate(to: .bet(betModel))
                                            }
                                    case let .betslip(betslipModel):
                                        BetslipCellView(bet: betslipModel, currency: vm.defaultCurrency.rawValue)
                                            .onTapGesture {
                                                router.navigate(to: .betslip(betslipModel))
                                            }
                                    }
                                }
                            }
                            .padding(.horizontal, 12)
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
        .navigationTitle("Feed")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color.ui.scheme)
                    .onTapGesture {
                        router.navigate(to: .search)
                    }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Image(systemName: "plus")
                    .foregroundStyle(Color.ui.scheme)
                    .onTapGesture {
                        router.navigate(to: .add)
                    }
            }
        }
    }
    
    @ViewBuilder private func navigationDestination(_ destination: Destination) -> some View {
        switch destination {
        case .bet(let bet):
            BetDetailsScreen(bet: bet)
                .toolbar(.hidden, for: .tabBar)
                .environment(router)
        case .betslip(let betslip):
            BetslipDetailsScreen(betslip: betslip)
        case .search:
            SearchScreen()
                .toolbar(.hidden, for: .tabBar)
                .environment(router)
        case .add:
            AddBetScreen()
                .toolbar(.hidden, for: .tabBar)
        }
    }
}
