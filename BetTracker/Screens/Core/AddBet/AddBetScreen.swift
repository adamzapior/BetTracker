//
//  AddBetView.swift
//  BetTrackerUI
//
//  Created by Adam Zapiór on 21/02/2023.
//
import GRDB
import SwiftUI

struct AddBetScreen: View {
    @Environment(\.dismiss)
    var dismiss

    @Environment(\.colorScheme)
    var colorScheme

    @StateObject
    var vm = AddBetVM()

    @State
    var alertCheck: Bool = false

    var body: some View {
        VStack(spacing: 2) {
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
//
//                HStack  {
//                    Text("ADD NEW BET")
//                        .padding()
//                        .font(.subheadline)
//                    Image(systemName: "chevron.down")
//                        .padding(.trailing, 4)
//                        .foregroundColor(Color.red)
//                        .opacity(0.7)
//                        .font(.title2)
//                        .onTapGesture {
//                        }
//                }
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

            if vm.betType == .solobet {
                ScrollView { // Here was ScrollView
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
                            .padding(.horizontal, 12)

                            VStack(spacing: 12) {
                                HStack {
                                    TeamInput(
                                        hint: "Enter first team or player*",
                                        text: $vm.team1,
                                        isError: vm.team1IsError,
                                        isOn: Binding(
                                            get: { vm.selectedTeam == .team1 },
                                            set: { _ in vm.onTeam1Selected() }
                                        ),
                                        action: vm.onTeam1Selected
                                    )
                                }
                                TeamInput(
                                    hint: "Enter second team or player*",
                                    text: $vm.team2,
                                    isError: vm.team2IsError,
                                    isOn: Binding(
                                        get: { vm.selectedTeam == .team2 },
                                        set: { _ in vm.onTeam2Selected() }
                                    ),
                                    action: vm.onTeam2Selected
                                )
                            }
                            .padding(.horizontal, 12)
                        }
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
                                // ** Odds input **
                                AmountInput(
                                    hint: "Bet odds*",
                                    text: $vm.odds,
                                    isError: vm.oddsIsError, // TODO:
                                    overlayText: "" // to funkcja stworzona, żeby zablokować
                                    // mozliwosc edytowania textfielda, musze wyciagnac kolejny
                                    // obiet tylko dla tego parametru
                                )

                                if vm.taxRowStateValue == .active {
                                    AmountInput(
                                        hint: "Insert your tax",
                                        text: $vm.tax,
                                        isError: vm.taxIsError,
                                        overlayText: "%"
                                    )
                                }
                            }

                            AmountInput(
                                hint: "Enter your bet amount*",
                                text: $vm.amount,
                                isError: vm.amountIsError,
                                overlayText: vm.defaultCurrency.rawValue.uppercased()
                            )
                            CategoryRow(
                                icon: "mark",
                                selectedCategory: $vm.selectedCategory,
                                vm: vm
                            )
                        }
                        .padding(.horizontal, 12)

                        VStack {
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
                                        EventDatePicker(
                                            showDatePicker: $vm.showDatePicker,
                                            selectedDate: $vm.selectedDate,
                                            action: vm.closeDate, vm: vm
                                        )
                                        .transition(.opacity)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .padding(.horizontal, 12)
                            .animation(.easeInOut, value: vm.dateState)

                            ZStack {
                                switch vm.reminderState {
                                case .add:
                                    ReminderIsActive(
                                        icon: "bell",
                                        labelText: "Reminder is off",
                                        actionButtonIcon: "plus.app.fill",
                                        actionButtonColor: Color.ui.onBackground
                                    ) {
                                        vm.isAddClicked()
                                    }

                                case .editing:
                                    VStack {
                                        HStack {
                                            HStack {
                                                DatePickerWithButtons(
                                                    showDatePicker: $vm.showDatePicker,
                                                    selectedDate: $vm.selectedNotificationDate,
                                                    vm: vm
                                                )
                                                .transition(.opacity)
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                    }

                                case .delete:
                                    ReminderIsActive(
                                        icon: "bell",
                                        labelText: "Reminder is on",
                                        actionButtonIcon: "xmark.app.fill",
                                        actionButtonColor: Color.red
                                    ) {
                                        vm.deleteRemind()
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .animation(.easeInOut, value: vm.reminderState)
                            .padding(.horizontal, 12)

                            PredictedProfit(
                                labelText: "Your predicted profit:",
                                profitText: vm.profit.stringValue,
                                currency: "PLN"
                            )
                            .padding(.horizontal, 12)
                        }
                        .padding(.top, 12)
                    }
                    .safeAreaInset(edge: .bottom) {
                        VStack {
                            AddBetButton(text: "Add bet to pending") {
                                if vm.saveBet() {
                                    dismiss()
                                    vm.clearTextField()
                                } else {
                                    alertCheck = true
                                }
                            }
                        }
                        .padding(.top, 36)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }

            if vm.betType == .betslip {
                ScrollView {
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
                            .padding(.horizontal, 12)

                            VStack(spacing: 12) {
                                HStack {
                                    AmountInput(
                                        hint: "Enter your bet name*",
                                        text: $vm.amount,
                                        isError: vm.amountIsError,
                                        overlayText: ""
                                    )
                                }
                            }
                            .padding(.horizontal, 12)
                        }
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
                                // ** Odds input **
                                AmountInput(
                                    hint: "Bet odds*",
                                    text: $vm.odds,
                                    isError: vm.oddsIsError, // TODO:
                                    overlayText: "" // to funkcja stworzona, żeby zablokować
                                    // mozliwosc edytowania textfielda, musze wyciagnac kolejny
                                    // obiet tylko dla tego parametru
                                )

                                if vm.taxRowStateValue == .active {
                                    AmountInput(
                                        hint: "Insert your tax",
                                        text: $vm.tax,
                                        isError: vm.taxIsError,
                                        overlayText: "%"
                                    )
                                }
                            }

                            AmountInput(
                                hint: "Enter your bet amount*",
                                text: $vm.amount,
                                isError: vm.amountIsError,
                                overlayText: vm.defaultCurrency.rawValue.uppercased()
                            )
                            CategoryRow(
                                icon: "mark",
                                selectedCategory: $vm.selectedCategory,
                                vm: vm
                            )
                        }
                        .padding(.horizontal, 12)

                        VStack {
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
                                        EventDatePicker(
                                            showDatePicker: $vm.showDatePicker,
                                            selectedDate: $vm.selectedDate,
                                            action: vm.closeDate, vm: vm
                                        )
                                        .transition(.opacity)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .padding(.horizontal, 12)
                            .animation(.easeInOut, value: vm.dateState)

                            ZStack {
                                switch vm.reminderState {
                                case .add:
                                    ReminderIsActive(
                                        icon: "bell",
                                        labelText: "Reminder is off",
                                        actionButtonIcon: "plus.app.fill",
                                        actionButtonColor: Color.ui.onBackground
                                    ) {
                                        vm.isAddClicked()
                                    }

                                case .editing:
                                    VStack {
                                        HStack {
                                            HStack {
                                                DatePickerWithButtons(
                                                    showDatePicker: $vm.showDatePicker,
                                                    selectedDate: $vm.selectedNotificationDate,
                                                    vm: vm
                                                )
                                                .transition(.opacity)
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                    }

                                case .delete:
                                    ReminderIsActive(
                                        icon: "bell",
                                        labelText: "Reminder is on",
                                        actionButtonIcon: "xmark.app.fill",
                                        actionButtonColor: Color.red
                                    ) {
                                        vm.deleteRemind()
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .animation(.easeInOut, value: vm.reminderState)
                            .padding(.horizontal, 12)

                            PredictedProfit(
                                labelText: "Your predicted profit:",
                                profitText: vm.profit.stringValue,
                                currency: "PLN"
                            )
                            .padding(.horizontal, 12)
                        }
                        .padding(.top, 12)
                    }
                    .safeAreaInset(edge: .bottom) {
                        VStack {
                            AddBetButton(text: "Add bet to pending") {
                                if vm.saveBet() {
                                    dismiss()
                                    vm.clearTextField()
                                } else {
                                    alertCheck = true
                                }
                            }
                        }
                        .padding(.top, 36)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .onAppear {
                    vm.clearTextField()
                }
            }
        }
        .padding(.top, 12)
        .navigationBarBackButtonHidden()
        .onTapGesture { hideKeyboard() }

        .onDisappear {
            vm.saveTextInTexfield()
        }
        .onAppear {
            print(vm.tax)
            vm.loadTextInTextfield()
        }
    }
}
