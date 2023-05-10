import SwiftUI

struct OnboardingSetupView: View {

    @StateObject
    var vm = PreferencesVM()

    @State
    private var doWant = false

    @FocusState
    private var isTaxFocused

    @State
    private var scale = 1.0

    let action: () -> Void

    var body: some View {
        VStack(spacing: 48) {
            HStack {
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

                    Form {
                        Section(
                            header: Text("Choose your default tax")
                                .foregroundColor(Color.ui.onPrimaryContainer)
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .leading
                                )
                        ) {
                            Toggle("Do you want set default tax?", isOn: $vm.isDefaultTaxOn)
                            TextField("Enter your tax value", text: $vm.defaultTax)
                                .focused($isTaxFocused)
                                .overlay {
                                    Text("%")
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .opacity(0.5)
                                }
                                .toolbar {
                                    ToolbarItemGroup(placement: .keyboard) {
                                        Button("Confirm your tax") {
                                            hideKeyboard()
                                        }
                                        .foregroundColor(Color.ui.secondary)
                                        .bold()
                                        .font(.title2)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 3)
                                        .background {
                                            RoundedRectangle(cornerRadius: 25)
                                                .stroke(style: StrokeStyle(lineWidth: 2))
                                                .foregroundColor(Color.ui.secondary)
                                        }
                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                    }
                                }
                                .textFieldStyle(.plain)
                                .onAppear {
                                    vm.loadPreferences()
                                }
                                .onDisappear {
                                    vm.setDefaultTaxTo0()
                                }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .frame(height: 125, alignment: .topLeading)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5)

                    Form {
                        Section(
                            header: Text("Choose your default currency")
                                .foregroundColor(Color.ui.onPrimaryContainer)
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .leading
                                )
                        ) {
                            TextField("Enter your currency", text: $vm.defaultCurrency)
                                .textInputAutocapitalization(.characters)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .frame(height: 90, alignment: .topLeading)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding(.vertical, 24)
                .keyboardType(.decimalPad)
            }
            .navigationBarBackButtonHidden()

            HStack(alignment: .bottom) {
                if isTaxFocused {
                } else {
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
                    .animation(.linear(duration: 0.5), value: scale)
                }
            }
            Spacer()
        }
        .frame(maxHeight: .infinity, alignment: .center)
        .onTapGesture {
            hideKeyboard()
        }
        .onDisappear {
            vm.savePreferences()
        }
    }
}
