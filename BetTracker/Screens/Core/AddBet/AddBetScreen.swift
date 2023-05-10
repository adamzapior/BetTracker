//
//  AddBetView.swift
//  BetTrackerUI
//
//  Created by Adam Zapiór on 21/02/2023.
//
import GRDB
import SwiftUI

struct AddBetScreen: View {
    @Environment(\.closeTab)
    var dismiss

    @Environment(\.colorScheme)
    var colorScheme

    @StateObject
    var vm = AddBetVM()

    @State
    var alertCheck: Bool = false


    var body: some View {
        VStack {
            HStack {
                Text("Add bet")
                    .foregroundColor(Color.ui.scheme)
                    .bold()
                    .font(.largeTitle)
                Spacer()
                Spacer()
                Image(systemName: "x.square")
                    .foregroundColor(Color.ui.secondary)
                    .font(.title)
                    .onTapGesture {
                        dismiss()
                    }
            }
            .padding()
            .padding(.horizontal, 6)

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Group {
                        HStack {
                            VStack {
                                HStack {
                                    TeamInput(
                                        hint: "Wprowadź 1 drużyne*",
                                        text: $vm.team1,
                                        isError: vm.team1IsError,
                                        isOn: Binding(
                                            get: { vm.selectedTeam == .team1 },
                                            set: { _ in vm.onTeam1Selected() }
                                        )
                                    )
                                }
                                TeamInput(
                                    hint: "Wprowadź 2 drużyne*",
                                    text: $vm.team2,
                                    isError: vm.team2IsError,
                                    isOn: Binding(
                                        get: { vm.selectedTeam == .team2 },
                                        set: { _ in vm.onTeam2Selected() }
                                    )
                                )
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        Divider()
                        VStack(spacing: 8) {
                            HStack {
                                AmountInput(
                                    hint: "Kurs zdarzenia*",
                                    text: $vm.odds,
                                    isError: vm.oddsIsError,
                                    overlayText: ""
                                )

                                AmountInput(
                                    hint: "0",
                                    text: $vm.tax,
                                    isError: vm.taxIsError,
                                    overlayText: "%"
                                )
                            }

                                AmountInput(
                                    hint: "Wprowadź kwotę*",
                                    text: $vm.amount,
                                    isError: vm.amountIsError,
                                    overlayText: vm.defaultCurrency
                                )
                            
                            OptionalDataInput(
                                hint: "Wprowadź dyscyplinę*",
                                text: $vm.category,
                                isError: false
                            )
                        }
                    }
                    Divider()

                    HStack {
                        Button {
                            vm.toggleMoreOptionsButton()
                        } label: {
                            HStack {
                                Text("WANNA SEE MORE OPTIONS?")
                                    .foregroundColor(Color.ui.onPrimaryContainer)
                                Image(
                                    systemName: vm.isMoreOptionHIdden
                                    ? "arrowtriangle.down.fill"
                                    :  "arrowtriangle.forward.fill"
                                )
                                .foregroundColor(Color.ui.scheme)
                            }
                            .padding(.horizontal, 4)
                        }

                        Image(
                            systemName: vm.isMoreOptionHIdden
                                ? "arrowtriangle.forward.fill"
                                : "arrowtriangle.down.fill"
                        )
                    }
                    .padding(.top, -6)
                    
                    if vm.moreOptionHiddenStatus ==  .statusOn {
                        VStack(spacing: 8) {
                            OptionalDataInput(
                                hint: "Wprowadź ligę",
                                text: $vm.league,
                                isError: false
                            )
                            
                            DatePicker(
                                selection: $vm.selectedDate,
                                displayedComponents: .date
                            ) {
                                Text("Wprowadź datę zdarzenia:")
                                    .foregroundColor(Color.ui.onBackground)
                                    .padding(.horizontal, 12)
                            }
                            .datePickerStyle(.compact)
                            .font(.body)
                            
                            .padding(.top, 8)
                        }
                    }

                    Divider()
                    HStack {
                        ReminderInput(bodyText: "Czy chcesz dodać przypomnienie?", isOn: $vm.reminderStatus)
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(Color.ui.onPrimary)
                    }
                    .shadow(color: Color.black.opacity(0.1), radius: 1, x: 3, y: 2)

                    PredictedProfit(text: vm.profit)

                    Spacer()
                    HStack {
                        AddBetButton(text: "Dodaj")
                            .onTapGesture {
                                if vm.saveBet() {
                                    dismiss()
                                    vm.clearTextField()
                                } else {
                                    alertCheck = true
                                }
                            }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, -12)
                }
                .padding(.horizontal, 12)
            }
        }
        .navigationBarBackButtonHidden()
        .onTapGesture { hideKeyboard() }

        .onDisappear {
            vm.saveTextInTexfield()
        }
        .onAppear {
            vm.loadTextInTextfield()
        }
    }
}
