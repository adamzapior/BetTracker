import SwiftUI

struct OnboardingSetupView: View {

    @StateObject
    var vm: PreferencesVM

    @FocusState
    private var isTaxFocused

    let action: () -> Void

    var body: some View {
        VStack(spacing: 48) {
            VStack {
                VStack(alignment: .leading) {
                    VStack {
                        Text("Setup your")
                            .foregroundColor(Color.ui.secondary)
                            .font(.largeTitle)
                            .bold()

                        Text("preferences")
                            .foregroundColor(Color.ui.scheme)
                            .font(.largeTitle)
                            .bold()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 24)

                    VStack(spacing: 6) {
                        VStack {
                            VStack {
                                Text("YOUR CURRENCY")
                                    .font(.footnote)
                                    .foregroundColor(Color.ui.onPrimaryContainer)
                                    .padding(.vertical, 3)
                                    .padding(.horizontal, 6)
                                    .frame(
                                        maxWidth: .infinity,
                                        alignment: .leading
                                    )
                            }
                            HStack {
                                ZStack {
                                    HStack {
                                        Text("Choose your currency")
                                            .font(.body)
                                            .frame(height: 36)
                                            .foregroundColor(Color.ui.secondary)
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 6)
                                    .background {
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundColor(
                                                Color.ui.onPrimary
                                            )
                                    }
                                    Picker(
                                        "Choose your currency",
                                        selection: $vm.defaultCurrency
                                    ) {
                                        ForEach(
                                            Currency.allCases
                                                .sorted(by: { $0.rawValue < $1.rawValue }),
                                            id: \.self
                                        ) { currency in
                                            Text("\(currency.rawValue.uppercased())")
                                        }
                                    }
                                    .pickerStyle(.menu)
                                    .tint(Color.ui.scheme)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .edgesIgnoringSafeArea(.all)
                                }
                            }
                            .standardShadow()
                        }
                        .frame(maxWidth: .infinity, alignment: .top)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 12)
                        .keyboardType(.decimalPad)

                        VStack {
                            VStack {
                                Text("TAX RATE")
                                    .font(.footnote)
                                    .foregroundColor(Color.ui.onPrimaryContainer)
                                    .padding(.vertical, 3)
                                    .padding(.horizontal, 6)
                                    .frame(
                                        maxWidth: .infinity,
                                        alignment: .leading
                                    )
                                HStack {
                                    HStack {
                                        Text("Do you want use tax rate?")
                                            .font(.body)
                                            .frame(height: 36)
                                            .foregroundColor(Color.ui.secondary)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal)
                                    .padding(.vertical, 6)
                                    .background {
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundColor(Color.ui.onPrimary)
                                    }
                                    .clipped(antialiased: false)
                                    .standardShadow()

                                    Image(
                                        systemName: vm.isTaxTextfieldOn
                                            ? "checkmark.square.fill"
                                            : "checkmark.square"
                                    )
                                    .font(.largeTitle)
                                    .foregroundColor(
                                        vm.isTaxTextfieldOn
                                            ? Color.ui.scheme
                                            : Color.ui
                                                .onPrimaryContainer
                                    )
                                    .onTapGesture {
                                        vm.isTaxTextfieldOn.toggle()
                                    }
                                }

                                if vm.isTaxTextfieldOn == true {
                                    HStack {
                                        TextField(
                                            "",
                                            text: $vm.defaultTax,
                                            prompt: Text("Input your default tax")
                                                .foregroundColor(Color.ui.onPrimaryContainer)
                                        )
                                        .frame(height: 36)
                                        .keyboardType(.decimalPad)
                                        .overlay {
                                            Text("%")
                                                .frame(
                                                    maxWidth: .infinity,
                                                    alignment: .trailing
                                                )
                                                .opacity(0.5)
                                        }
                                        .textFieldStyle(.plain)
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 6)
                                    .background {
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundColor(Color.ui.onPrimary)
                                    }
                                    .standardShadow()
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .padding(.horizontal, 12)
                        .keyboardType(.decimalPad)

                        HStack(alignment: .bottom) {
                            Button("Get started") {
                                action()
                            }
                            .font(.title2)
                            .bold()
                            .foregroundColor(Color.ui.secondary)
                            .frame(minWidth: 200, minHeight: 56, alignment: .center)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 3)
                            .clipShape(RoundedRectangle(cornerRadius: 150))
                            .background {
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(style: StrokeStyle(lineWidth: 2))
                                    .foregroundColor(Color.ui.secondary)
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                        }
                        .padding(.bottom, 48)
                    }
                    .navigationBarBackButtonHidden()
                }
                .frame(maxHeight: .infinity, alignment: .center)
                .onTapGesture {
                    hideKeyboard()
                }
                .onDisappear {
                    vm.savePreferences()
                    vm.saveTaxSettings()
                }
            }
        }
    }
}
