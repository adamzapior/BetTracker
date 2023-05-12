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

    @FocusState
    private var hasFocus: Bool
    

    var body: some View {
        VStack (spacing: 2) {
            ScrollView { // Here was ScrollView
                Group {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            VStack {
                                HStack {
                                    Text("SELECT PICK")
                                        .foregroundColor(Color.ui.scheme)
                                        .bold()
                                        .opacity(1)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.horizontal, 12)
                            
                            VStack (spacing: 8) {
                                HStack {
                                    TeamInput(
                                        hint: "Input first team or player*",
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
                                    hint: "Input second team or player*",
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
                    }
                    //                        Divider()
                    VStack(spacing: 8) {
                        VStack {
                            Divider()
                            HStack {
                                Text("BET VALUES")
                                    .foregroundColor(Color.ui.scheme)
                                    .bold()
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.horizontal, 12)
                        VStack {
                            HStack {
                                AmountInput(
                                    hint: "Odds*",
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
                                hint: "Wprowadź kwotę*",
                                text: $vm.amount,
                                isError: vm.amountIsError,
                                overlayText: vm.defaultCurrency
                            )
                            
                            VStack {
                                HStack {
                                    OptionalDataInput(
                                        hint: "Wprowadź dyscyplinę*",
                                        text: $vm.category,
                                        isError: false
                                    )
                                }
                                HStack {
                                    Image(systemName: "calendar")
                                        .font(.headline)
                                        .foregroundColor(Color.ui.scheme)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 12)
                                    DatePicker("Event data", selection: $vm.selectedDate, displayedComponents: .date)
                                }
                                .tint(Color.ui.scheme)
                                .background {
                                    RoundedRectangle(cornerRadius: 15)
                                        .foregroundColor(Color.ui.onPrimary)
                                }
                                .shadow(color: Color.black.opacity(0.1), radius: 1, x: 3, y: 2)
                                
                            }
                        }
                        .padding(.horizontal, 12)
                    }
  
                    ZStack {
                        switch vm.reminderState {
                        case .add:
                            VStack {
                                HStack {
                                    Spacer()
                                    Image(systemName: "bell")
                                        .font(.headline)
                                        .foregroundColor(Color.ui.scheme)
                                        .padding(.vertical, 12)
                                    Spacer()
                                    Spacer()
                                    Text("Bet reminder")
                                        .font(.subheadline)
                                        .bold()
                                        .foregroundColor(Color.ui.onPrimaryContainer)
                                        .padding(.vertical, 16)
                                    Spacer()
                                    Image(systemName: "plus.app.fill")
                                        .font(.title)
                                        .foregroundColor(Color.ui.secondary)
                                        .onTapGesture {
                                            vm.isAddClicked()
                                        }
                                        .padding(.leading, 100)
                                }
                                .padding(.leading, 3)
                                .padding(.horizontal)
                                .background {
                                    RoundedRectangle(cornerRadius: 15)
                                        .foregroundColor(
                                            Color.ui.onPrimary
                                        )
                                }
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                            .edgesIgnoringSafeArea(.all)
                            
                        case .editing:
                            VStack {
                                HStack {
                                    HStack {
                                        DatePickerWithButtons(
                                            showDatePicker: $vm.showDatePicker,
                                            savedDate: $vm.pickedDate,
                                            selectedDate: vm.selectedDate,
                                            savedSuccesfully: vm.deleteRemind,
                                            vm: vm
                                        )
                                        .transition(.opacity)
                                        
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            
                            
                        case .delete:
                            VStack {
                                HStack {
                                    Spacer()
                                    Spacer()
                                    Image(systemName: "bell")
                                        .foregroundColor(Color.ui.scheme)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 12)
                                    Text("Bet reminder")
                                        .font(.subheadline)
                                        .bold()
                                        .foregroundColor(Color.ui.onPrimaryContainer)
                                        .padding(.horizontal, 12)
                                        .padding(.leading, 4)
                                        .padding(.vertical, 16)
                                    HStack {
                                        Text("Delete")
                                            .background {
                                                RoundedRectangle(cornerRadius: 15)
                                                    .foregroundColor(
                                                        Color.red
                                                    )
                                            }
                                    }
                                    .onTapGesture {
                                        vm.deleteRemind()
                                    }
                                    .padding(.horizontal)
                                }
                                .background {
                                    RoundedRectangle(cornerRadius: 15)
                                        .foregroundColor(
                                            Color.ui.onPrimary
                                        )
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    //                .edgesIgnoringSafeArea(.all)
                    .animation(.easeInOut, value: vm.reminderState)
                    .padding(.horizontal, 12)
                    
                    PredictedProfit(text: vm.profit, currency: vm.defaultCurrency)
                        .padding(.horizontal, 12)
                }
                .safeAreaInset(edge: .bottom)  {
                    VStack {
                        HStack {
                            AddDeclineButton(text: "X") {
                                dismiss()
                            }
                            Spacer()
                            AddBetButton(text: "Add new bet") {
                                if vm.saveBet() {
                                    dismiss()
                                    vm.clearTextField()
                                } else {
                                    alertCheck = true
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, 24)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
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
