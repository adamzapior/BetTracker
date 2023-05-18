import Combine
import SwiftUI

struct PreferencesView: View {

    @Environment(\.colorScheme)
    var colorScheme

    @ObservedObject
    var vm = PreferencesVM()
    
//    init(category: Category) {
//        self._vm = ObservedObject(wrappedValue: PreferencesVM(category: category))
//    }

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
                            header: Text("Your name")
                                .foregroundColor(Color.ui.onPrimaryContainer)
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .leading
                                )
                        ) {
                            TextField("Enter your name", text: $vm.username)
                                .textFieldStyle(.plain)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .frame(height: 90, alignment: .topLeading)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5)

                    Form {
                        Section(
                            header: Text("Default tax")
                                .foregroundColor(Color.ui.onPrimaryContainer)
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .leading
                                )
                        ) {
                            Toggle("Do you want set default tax?", isOn: $vm.isDefaultTaxOn)

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
                    }
                    .scrollContentBackground(.hidden)
                    .frame(height: 125, alignment: .topLeading)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5)

                    Form {
                        Section(
                            header: Text("Default currency")
                                .foregroundColor(Color.ui.onPrimaryContainer)
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .leading
                                )
                        ) {
                            Picker("Choose your currency", selection: $vm.defaultCurrency) {
                                ForEach(Currency.allCases, id: \.self) { currency in
                                    Text("\(currency.rawValue.uppercased())")
                                        .foregroundColor(Color.ui.scheme)
                                        
                                }
                            }
                            .pickerStyle(.menu)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .frame(height: 150, alignment: .topLeading) // TODO: tu bylo 90
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
        }
        .onAppear {
            vm.loadPreferences()
            vm.getDefaultCurrency()
        }
    }
}
