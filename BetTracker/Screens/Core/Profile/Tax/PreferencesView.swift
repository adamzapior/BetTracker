import SwiftUI

struct PreferencesView: View {

    @Environment(\.colorScheme)
    var colorScheme

    @StateObject
    var vm = PreferencesVM()

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
                            header: Text("Choose your default tax")
                                .foregroundColor(Color.ui.onPrimaryContainer)
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .leading
                                )
                        ) {
                            TextField("Enter your tax value", text: $vm.defaultTax)
                                .overlay {
                                    Text("%")
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .opacity(0.5)
                                }
                                .textFieldStyle(.plain)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .frame(height: 100, alignment: .topLeading)
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
                    .frame(height: 235, alignment: .topLeading)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5)
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.horizontal, -8)
                .padding(.bottom, 48)
            }
        }
        .navigationBarBackButtonHidden()
        .onDisappear {
            vm.savePreferences()
        }
        .onAppear {
            vm.loadPreferences()
        }
    }
}
