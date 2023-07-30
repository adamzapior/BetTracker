import Combine
import SwiftUI

struct PreferencesView: View {

    @Environment(\.colorScheme)
    var colorScheme

    @StateObject
    var vm = PreferencesVM(interactor: PreferencesInteractor())


    @State
    private var selection = "Red"

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 2) {
                    HStack {
                        Text("Preferences")
                            .foregroundColor(Color.ui.scheme)
                            .bold()
                            .font(.largeTitle)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.top, 12)

                    Form {
                        Section(
                            header: Text("Your profile")
                                .foregroundColor(Color.ui.onPrimaryContainer)
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .leading
                                )
                        ) {
                            TextField("Enter your name", text: $vm.username)
                                .textFieldStyle(.plain)
                            Picker("Choose your currency", selection: $vm.defaultCurrency) {
                                ForEach(Currency.allCases, id: \.self) { currency in
                                    Text("\(currency.rawValue.uppercased())")
                                }
                            }
                            .tint(Color.ui.scheme)
                            .pickerStyle(.menu)

                            Toggle("Do you want set default tax?", isOn: $vm.isDefaultTaxOn)
                                .tint(Color.ui.scheme)

                            if vm.taxStatus == .taxUnsaved {
                                TextField("0", text: $vm.defaultTax)
                                    .disabled(!vm.isDefaultTaxOn)
                                    .overlay {
                                        Text("%")
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                            .opacity(0.5)
                                    }
                                    .textFieldStyle(.plain)
                                    .animation(.easeInOut, value: 1)
                            }
                        }

                        Section(
                            header: Text("About app")
                                .foregroundColor(Color.ui.onPrimaryContainer)
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .leading
                                )
                        ) {
                            Text("Help")
                            Picker("Choose your currency", selection: $vm.defaultCurrency) {
                                ForEach(Currency.allCases, id: \.self) { currency in
                                    Text("\(currency.rawValue.uppercased())")
                                }
                            }
                            .tint(Color.ui.scheme)
                            .pickerStyle(.menu)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .frame(height: 500, alignment: .topLeading)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5)
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.bottom, 48)
                .onTapGesture {
                    hideKeyboard()
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onDisappear {
            vm.ifTaxEmpty()
            vm.savePreferences()
            vm.save()
        }
        .onAppear {
//            vm.loadPreferences()
//            vm.getDefaultCurrency()
        }
    }
}
