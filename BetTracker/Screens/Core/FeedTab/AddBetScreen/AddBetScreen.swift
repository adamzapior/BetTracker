import SwiftUI

struct AddBetScreen: View {
    @Environment(FeedTabRouter.self) private var router
    @StateObject var viewModel = AddBetViewModel()

    @State private var showAlert = false

    var body: some View {
        ZStack {
            if showAlert == true {
                CustomAlertView(
                    isPresented: $showAlert,
                    title: "Error",
                    messages: viewModel.validationErrors.map(\.description),
                    primaryButtonLabel: "OK",
                    primaryButtonAction: { showAlert = false }
                )
            }

            VStack {
                Form {
                    Section {
                        Picker("Bet Type", selection: $viewModel.betType) {
                            ForEach(BetType.allCases, id: \.self) { type in
                                Text(type.rawValue.uppercased())
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }

                    switch viewModel.betType {
                    case .singlebet:
                        singleBetNamesSectionView()
                    case .betslip:
                        betslipNameSectionView()
                    }

                    betValuesSectionView()

                    switch viewModel.betType {
                    case .singlebet:
                        yourPickSectionView()
                    case .betslip:
                        categorySectionView()
                    }

                    additionalInfoSectionView()

                    Section(footer:
                        HStack {
                            Spacer()
                            Button(action: { addButtonAction() }) {
                                Text("Add bet to pending")
                                    .frame(maxWidth: .infinity)
                                    .font(.headline)
                            }
                            .buttonStyle(ActionButton())

                            Spacer()
                        }
                    ) {
                        EmptyView()
                    }
                }
            }
        }
        .navigationTitle("Add new bet")
    }

    private func addButtonAction() {
        if viewModel.betType == .singlebet ? viewModel.saveBet() : viewModel.saveBetslip() {
            router.popToRoot()
        } else {
            showAlert = true
        }
    }

    private func singleBetNamesSectionView() -> some View {
        Section(header: Text("SELECT PICK")) {
            VStack {
                TextField("Enter first team or player", text: $viewModel.team1)
                    .autocapitalization(.words)
                    .onChange(of: viewModel.team1) { oldValue, newValue in
                        viewModel.team1 = viewModel.filterInput(
                            input: newValue,
                            oldValue: oldValue,
                            filterType: .name
                        )
                    }
            }
            .listRowBackground(viewModel.team1IsError ? Color.red.opacity(0.2) : Color(UIColor.secondarySystemGroupedBackground))

            VStack {
                TextField("Enter second team or player", text: $viewModel.team2)
                    .autocapitalization(.words)
                    .onChange(of: viewModel.team2) { oldValue, newValue in
                        viewModel.team2 = viewModel.filterInput(
                            input: newValue,
                            oldValue: oldValue,
                            filterType: .name
                        )
                    }
            }
            .listRowBackground(viewModel.team2IsError ? Color.red.opacity(0.2) : Color(UIColor.secondarySystemGroupedBackground))
        }
    }

    private func betslipNameSectionView() -> some View {
        Section(header: Text("YOUR BETSLIP")) {
            VStack {
                TextField("Enter your bet name", text: $viewModel.betslipName)
                    .autocapitalization(.words)
                    .onChange(of: viewModel.betslipName) { oldValue, newValue in
                        viewModel.betslipName = viewModel.filterInput(
                            input: newValue,
                            oldValue: oldValue,
                            filterType: .name
                        )
                    }
            }
            .listRowBackground(viewModel.betslipNameIsError ? Color.red.opacity(0.2) : Color(UIColor.secondarySystemGroupedBackground))
        }
    }

    private func betValuesSectionView() -> some View {
        Section("BET VALUES") {
            VStack {
                TextField("Bet odds", text: viewModel.betType == .singlebet ? $viewModel.odds : $viewModel.betslipOdds)
                    .keyboardType(.decimalPad)
                    .onChange(of: viewModel.betType == .singlebet ? viewModel.odds : viewModel.betslipOdds) { oldValue, newValue in
                        let filteredValue = viewModel.filterInput(
                            input: newValue,
                            oldValue: oldValue,
                            filterType: .odds
                        )
                        switch viewModel.betType {
                        case .singlebet:
                            viewModel.odds = filteredValue
                        case .betslip:
                            viewModel.betslipOdds = filteredValue
                        }
                    }
            }
            .listRowBackground(
                (viewModel.betType == .singlebet ? viewModel.oddsIsError : viewModel.betslipOddsIsError)
                    ? Color.red.opacity(0.2)
                    : Color(UIColor.secondarySystemGroupedBackground)
            )

            VStack {
                HStack {
                    TextField("Bet amount", text: viewModel.betType == .singlebet ? $viewModel.amount : $viewModel.betslipAmount)
                        .keyboardType(.decimalPad)
                        .onChange(of: viewModel.betType == .singlebet ? viewModel.amount : viewModel.betslipAmount) { oldValue, newValue in
                            let filteredValue = viewModel.filterInput(
                                input: newValue,
                                oldValue: oldValue,
                                filterType: .amount
                            )
                            switch viewModel.betType {
                            case .singlebet:
                                viewModel.amount = filteredValue
                            case .betslip:
                                viewModel.betslipAmount = filteredValue
                            }
                        }
                    Spacer()
                    Text(viewModel.defaultCurrency.rawValue.uppercased())
                }
                .alignmentGuide(.listRowSeparatorLeading) { _ in
                    0
                }
            }
            .listRowBackground(
                (viewModel.betType == .singlebet ? viewModel.amountIsError : viewModel.betslipAmountIsError)
                    ? Color.red.opacity(0.2)
                    : Color(UIColor.secondarySystemGroupedBackground)
            )

            if viewModel.taxFieldState == .visible {
                VStack {
                    HStack {
                        TextField("Tax", text: viewModel.betType == .singlebet ? $viewModel.tax : $viewModel.betslipTax)
                            .keyboardType(.decimalPad)
                            .onChange(of: viewModel.betType == .singlebet ? viewModel.tax : viewModel.betslipTax) { oldValue, newValue in
                                let filteredValue = viewModel.filterInput(
                                    input: newValue,
                                    oldValue: oldValue,
                                    filterType: .tax
                                )
                                switch viewModel.betType {
                                case .singlebet:
                                    viewModel.tax = filteredValue
                                case .betslip:
                                    viewModel.betslipTax = filteredValue
                                }
                            }
                        Spacer()
                        Text("%")
                    }
                }
                .listRowBackground(
                    (viewModel.betType == .singlebet ? viewModel.taxIsError : viewModel.betslipTaxIsError)
                        ? Color.red.opacity(0.2)
                        : Color(UIColor.secondarySystemGroupedBackground)
                )
            }
        }
    }

    private func yourPickSectionView() -> some View {
        Section {
            VStack {
                Picker("Sport category", selection: $viewModel.selectedCategory) {
                    ForEach(viewModel.categories, id: \.self) { category in
                        Text(category.rawValue.capitalized)
                    }
                }
                .pickerStyle(.navigationLink)
            }

            VStack {
                HStack {
                    Picker(selection: $viewModel.selectedTeam) {
                        ForEach(viewModel.betResultCases, id: \.self) { result in
                            Text(result.displayName)
                        }
                    } label: {
                        Text("Bet pick")
                    }
                }
            }

        } header: {
            Text("YOUR PICK")
        }
    }

    private func categorySectionView() -> some View {
        Section("Bet category") {
            //        Section("Bet pick") {
            VStack {
                Picker("Sport category", selection: $viewModel.selectedCategory) {
                    ForEach(viewModel.categories, id: \.self) { category in
                        Text(category.rawValue.capitalized)
                    }
                }
                .pickerStyle(.navigationLink)
            }

//            Picker("Bet type", selection: $viewModel.selectedCategory) {
//                ForEach(viewModel.categories, id: \.self) { category in
//                    Text(category.rawValue.capitalized)
//                }
//            }
//            if viewModel.selectedCategory == .f1 {
//                Picker("Bet value", selection: $viewModel.selectedCategory) {
//                    ForEach(viewModel.categories, id: \.self) { category in
//                        Text(category.rawValue.capitalized)
//                    }
//                }
//            }
        }
    }

    private func additionalInfoSectionView() -> some View {
        Section(header: Text("ADDITIONAL INFO")) {
            DatePicker("Event date", selection: $viewModel.selectedDate, displayedComponents: .date)

            Toggle("Set reminder", isOn: Binding(
                get: { viewModel.reminderPickerState != .closed },
                set: { newValue in
                    switch newValue {
                    case true:
                        viewModel.addReminder()
                    case false:
                        viewModel.deleteReminder()
                    }
                }
            ))

            if viewModel.reminderPickerState == .active {
                DatePicker("Reminder date", selection: $viewModel.selectedNotificationDate, in: viewModel.reminderDateClosedRange)
            }

            NavigationLink(destination: NoteView(note: $viewModel.note)) {
                Text("Add note")
            }

            HStack {
                Text("Your predicted profit:")
                Spacer()
                Text("\(viewModel.profit.stringValue) \(viewModel.defaultCurrency.rawValue.uppercased())")
                    .bold()
            }
        }
    }
}

struct SingleBetView: View {
    @ObservedObject var vm: AddBetViewModel

    var body: some View {
        Section(header: Text("SELECT PICK")) {
            TextField("Enter first team or player", text: $vm.team1)
                .autocapitalization(.words)
            TextField("Enter second team or player", text: $vm.team2)
                .autocapitalization(.words)
        }
    }
}

struct BetslipView: View {
    @ObservedObject var vm: AddBetViewModel

    var body: some View {
        Section(header: Text("YOUR BETSLIP")) {
            TextField("Enter your bet name", text: $vm.betslipName)
                .autocapitalization(.words)
        }
    }
}

struct NoteView: View {
    @Binding var note: String

    var body: some View {
        TextEditor(text: $note)
            .navigationTitle("Note")
    }
}
