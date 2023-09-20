import GRDB
import SwiftUI

struct AddBetScreen: View {
    @Environment(\.dismiss)
    var dismiss

    @Environment(\.colorScheme)
    var colorScheme

    @StateObject
    var vm = AddBetVM(respository: Respository())

    @State
    private var showAlert = false

    @FocusState
    private var isFocused: Bool

    var body: some View {
        ZStack {
            if showAlert == true {
                CustomAlertView(
                    title: "Error",
                    messages: vm.validationErrors.map(\.description),
                    primaryButtonLabel: "OK",
                    primaryButtonAction: { showAlert = false }
                )
            }

            VStack(spacing: 2) {
                if vm.betType == .singlebet {
                    ScrollView(showsIndicators: false) {
                        Group {
                            VStack(alignment: .leading, spacing: 8) {
                                VStack {
                                    HStack {
                                        Text("SELECT PICK")
                                            .foregroundColor(Color.ui.scheme)
                                            .bold()
                                    }
                                    .padding(.bottom, 4)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }

                                VStack(spacing: 12) {
                                    HStack {
                                        TeamInputRow(
                                            hint: "Enter first team or player*",
                                            text: $vm.team1,
                                            isError: vm.team1IsError,
                                            isOn: Binding(
                                                get: { vm.selectedTeam == .team1 },
                                                set: { _ in vm.onTeam1Selected() }
                                            ),
                                            action: vm.onTeam1Selected, isFocused: $isFocused
                                        )
                                    }
                                    TeamInputRow(
                                        hint: "Enter second team or player*",
                                        text: $vm.team2,
                                        isError: vm.team2IsError,
                                        isOn: Binding(
                                            get: { vm.selectedTeam == .team2 },
                                            set: { _ in vm.onTeam2Selected() }
                                        ),
                                        action: vm.onTeam2Selected,
                                        isFocused: $isFocused
                                    )
                                }
                            }
                            .padding(.horizontal, 12)
                            .frame(maxWidth: .infinity, alignment: .leading)

                            VStack(spacing: 12) {
                                VStack {
                                    HStack {
                                        Text("BET VALUES")
                                            .foregroundColor(Color.ui.scheme)
                                            .bold()
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(.top, 12)

                                HStack {
                                    AddBetInputRow(
                                        hint: "Bet odds*",
                                        text: $vm.odds,
                                        isError: vm.oddsIsError,
                                        overlayText: "",
                                        isFocused: $isFocused,
                                        keyboardType: .decimalPad

                                    )

                                    if vm.taxRowStateValue == .active {
                                        AddBetInputRow(
                                            hint: "Insert your tax",
                                            text: $vm.tax,
                                            isError: vm.taxIsError,
                                            overlayText: "%",
                                            isFocused: $isFocused,
                                            keyboardType: .decimalPad
                                        )
                                    }
                                }
                                AddBetInputRow(
                                    hint: "Enter your bet amount*",
                                    text: $vm.amount,
                                    isError: vm.amountIsError,
                                    overlayText: vm.defaultCurrency.rawValue.uppercased(),
                                    isFocused: $isFocused,
                                    keyboardType: .decimalPad
                                )
                                CategoryRow(
                                    icon: "mark",
                                    selectedCategory: $vm.selectedCategory,
                                    vm: vm
                                )
                            }
                            .padding(.horizontal, 12)

                            VStack(spacing: 12) {
                                // state
                                ZStack {
                                    switch vm.dateState {
                                    case .closed:
                                        EventDateRow(
                                            icon: "calendar",
                                            labelText: "Event date:",
                                            dateText: vm.selectedDate.formatSelectedDate(),
                                            actionButtonIcon: "chevron.right",
                                            actionButtonColor: .red
                                        ) {
                                            vm.openDate()
                                        }
                                    case .opened:
                                        HStack {
                                            EventDatePickerRow(
                                                showDatePicker: $vm.showDatePicker,
                                                selectedDate: $vm.selectedDate,
                                                action: vm.closeDate, vm: vm
                                            )
                                            .transition(.opacity)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                                .animation(.easeInOut, value: vm.dateState)

                                ZStack {
                                    switch vm.reminderState {
                                    case .add:
                                        IconTextActionButtonRow(
                                            icon: "bell",
                                            labelText: "Reminder is off",
                                            actionButtonIcon: "plus.app.fill",
                                            actionButtonColor: Color.ui.onPrimaryContainer
                                        ) {
                                            vm.addReminder()
                                        }

                                    case .editing:
                                        HStack {
                                            ReminderDatePickerRow(
                                                showDatePicker: $vm.showDatePicker,
                                                selectedDate: $vm.selectedNotificationDate,
                                                vm: vm
                                            )
                                            .transition(.opacity)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                    case .delete:
                                        IconTextActionButtonRow(
                                            icon: "bell",
                                            labelText: "Reminder is on",
                                            actionButtonIcon: "xmark.app.fill",
                                            actionButtonColor: Color.red
                                        ) {
                                            vm.deleteReminder()
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .animation(.easeInOut, value: vm.reminderState)

                                ZStack {
                                    switch vm.noteState {
                                    case .closed:
                                        IconTextActionButtonRow(
                                            icon: "note",
                                            labelText: "Add note",
                                            actionButtonIcon: "chevron.right",
                                            actionButtonColor: Color.ui.onPrimaryContainer
                                        ) {
                                            vm.openNote()
                                        }
                                    case .opened:
                                        NoteRow(text: $vm.note) {
                                            vm.closeNote()
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .animation(.easeInOut, value: vm.noteState)

                                PredictedProfitRow(
                                    labelText: "Your predicted profit:",
                                    profitText: vm.profit.stringValue,
                                    currency: vm.defaultCurrency.rawValue.uppercased()
                                )
                            }
                            .padding(.horizontal, 12)
                            .padding(.top, 12)
                            .padding(.bottom, 64)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .transition(.slide) 
                }

                if vm.betType == .betslip {
                    ScrollView(showsIndicators: false) {
                        Group {
                            VStack(alignment: .leading, spacing: 8) {
                                VStack {
                                    HStack {
                                        Text("YOUR BETSLIP")
                                            .foregroundColor(Color.ui.scheme)
                                            .bold()
                                    }
                                    .padding(.bottom, 4)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }

                                VStack(spacing: 12) {
                                    HStack {
                                        AddBetInputRow(
                                            hint: "Enter your bet name*",
                                            text: $vm.betslipName,
                                            isError: vm.betslipNameIsError,
                                            overlayText: "",
                                            isFocused: $isFocused,
                                            keyboardType: .default
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal, 12)
                            .frame(maxWidth: .infinity, alignment: .leading)

                            VStack(spacing: 12) {
                                VStack {
                                    HStack {
                                        Text("BET VALUES")
                                            .foregroundColor(Color.ui.scheme)
                                            .bold()
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(.top, 12)

                                HStack {
                                    AddBetInputRow(
                                        hint: "Bet odds*",
                                        text: $vm.betslipOdds,
                                        isError: vm.betslipOddsIsError,
                                        overlayText: "",
                                        isFocused: $isFocused,
                                        keyboardType: .decimalPad
                                    )

                                    if vm.taxRowStateValue == .active {
                                        AddBetInputRow(
                                            hint: "Insert your tax",
                                            text: $vm.tax,
                                            isError: vm.taxIsError,
                                            overlayText: "%",
                                            isFocused: $isFocused,
                                            keyboardType: .decimalPad
                                        )
                                    }
                                }

                                AddBetInputRow(
                                    hint: "Enter your bet amount*",
                                    text: $vm.betslipAmount,
                                    isError: vm.betslipAmountIsError,
                                    overlayText: vm.defaultCurrency.rawValue.uppercased(),
                                    isFocused: $isFocused,
                                    keyboardType: .decimalPad
                                )
                                CategoryRow(
                                    icon: "mark",
                                    selectedCategory: $vm.selectedCategory,
                                    vm: vm
                                )
                            }
                            .padding(.horizontal, 12)

                            VStack(spacing: 12) {
                                ZStack {
                                    switch vm.dateState {
                                    case .closed:
                                        EventDateRow(
                                            icon: "calendar",
                                            labelText: "Event date:",
                                            dateText: vm.selectedDate.formatSelectedDate(),
                                            actionButtonIcon: "chevron.right",
                                            actionButtonColor: .red
                                        ) {
                                            vm.openDate()
                                        }
                                    case .opened:
                                        HStack {
                                            EventDatePickerRow(
                                                showDatePicker: $vm.showDatePicker,
                                                selectedDate: $vm.selectedDate,
                                                action: vm.closeDate, vm: vm
                                            )
                                            .transition(.opacity)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                                .animation(.easeInOut, value: vm.dateState)

                                ZStack {
                                    switch vm.reminderState {
                                    case .add:
                                        IconTextActionButtonRow(
                                            icon: "bell",
                                            labelText: "Reminder is off",
                                            actionButtonIcon: "plus.app.fill",
                                            actionButtonColor: Color.ui.onPrimaryContainer
                                        ) {
                                            vm.addReminder()
                                        }

                                    case .editing:
                                        HStack {
                                            ReminderDatePickerRow(
                                                showDatePicker: $vm.showDatePicker,
                                                selectedDate: $vm.selectedNotificationDate,
                                                vm: vm
                                            )
                                            .transition(.opacity)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                    case .delete:
                                        IconTextActionButtonRow(
                                            icon: "bell",
                                            labelText: "Reminder is on",
                                            actionButtonIcon: "xmark.app.fill",
                                            actionButtonColor: Color.red
                                        ) {
                                            vm.deleteReminder()
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .animation(.easeInOut, value: vm.reminderState)

                                ZStack {
                                    switch vm.noteState {
                                    case .closed:
                                        IconTextActionButtonRow(
                                            icon: "note",
                                            labelText: "Add note",
                                            actionButtonIcon: "chevron.right",
                                            actionButtonColor: Color.ui.onPrimaryContainer
                                        ) {
                                            vm.openNote()
                                        }
                                    case .opened:
                                        NoteRow(text: $vm.note) {
                                            vm.closeNote()
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .animation(.easeInOut, value: vm.noteState)

                                PredictedProfitRow(
                                    labelText: "Your predicted profit:",
                                    profitText: vm.profit.stringValue,
                                    currency: vm.defaultCurrency.rawValue.uppercased()
                                )
                            }
                            .padding(.horizontal, 12)
                            .padding(.top, 12)
                            .padding(.bottom, 64)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
            .padding(.top, 12)
            .navigationBarBackButtonHidden()
            .onTapGesture { hideKeyboard() }
            .safeAreaInset(edge: .top, alignment: .center, content: {
                ZStack {
                    HStack {
                        Picker("Select an option", selection: $vm.betType) {
                            ForEach(BetType.allCases, id: \.self) { currentState in
                                Text(currentState.rawValue.uppercased())
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .pickerStyle(.menu)
                    .tint(Color.ui.secondary)

                    HStack {
                        Spacer()
                        Image(systemName: "xmark")
                            .foregroundColor(Color.red)
                            .opacity(0.7)
                            .font(.title2)
                            .onTapGesture {
                                dismiss()
                            }
                    }
                    .padding(.trailing, 18)
                }
            })
            .safeAreaInset(
                edge: .bottom,
                alignment: .center,
                content: {
                    if isFocused == true {
                        EmptyView()
                    } else {
                        VStack {
                            if vm.betType == .singlebet {
                                Button {
                                    if vm.saveBet() {
                                        vm.clearTextField()
                                        dismiss()
                                    } else {
                                        showAlert = true
                                    }
                                } label: {
                                    AddBetButton(text: "Add bet to pending")
                                        .padding(.horizontal, 64)
                                        .padding(.vertical, 12)
                                }
                            }

                            if vm.betType == .betslip {
                                Button {
                                    if vm.saveBetslip() {
                                        vm.clearTextField()
                                        dismiss()
                                    } else {
                                        showAlert = true
                                    }
                                } label: {
                                    AddBetButton(text: "Add bet to pending")
                                        .padding(.horizontal, 64)
                                        .padding(.vertical, 12)
                                }
                            }
                        }
                        .background {
                            if colorScheme == .dark {
                                // Dark mode-specific background
                                RoundedRectangle(cornerRadius: 0, style: .continuous)
                                    .foregroundColor(Color.black.opacity(0.7))
                                    .blur(radius: 12)
                                    .ignoresSafeArea()

                            } else {
                                // Light mode-specific background
                                RoundedRectangle(cornerRadius: 0, style: .continuous)
                                    .foregroundColor(Color.clear)
                                    .background(Material.bar.opacity(0.7))
                                    .blur(radius: 12)
                                    .ignoresSafeArea()
                            }
                        }
                    }
                }
            )
        }
        .animation(.easeInOut, value: vm.betType)
        .onDisappear {
            vm.saveTextInTexfield()
        }
        .onAppear {
            vm.loadTextInTextfield()
        }
    }
}
