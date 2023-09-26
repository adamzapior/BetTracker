import Combine
import SwiftUI

struct PreferencesView: View {

    @Environment(\.dismiss)
    var dismiss

    @Environment(\.colorScheme)
    var colorScheme

    @Environment(\.openURL)
    var openURL

    @StateObject
    var vm = PreferencesVM()

    @State
    private var showAlert = false

    @State
    private var isTaxOn: Bool = false

    @FocusState
    private var isFocused: Bool
    

    var body: some View {
        NavigationView {
            ZStack {
                if showAlert == true {
                    CustomAlertView(
                        title: "Are you sure you want to export the file to CSV?",
                        messages: [
                            "Your file will be saved in your files, in the BetTracker folder"
                        ],
                        primaryButtonLabel: "OK",
                        primaryButtonAction: {
                            showAlert = false
                            vm.exportToCSV()
                        },
                        secondaryButtonLabel: "Cancel",
                        secondaryButtonAction: { showAlert = false }
                    )
                }

                VStack(spacing: 2) {
                    ScrollView {
                        VStack(spacing: 24) {
                            VStack {
                                Text("YOUR NAME")
                                    .font(.footnote)
                                    .foregroundColor(Color.ui.onPrimaryContainer)
                                    .padding(.vertical, 3)
                                    .padding(.horizontal, 6)
                                    .frame(
                                        maxWidth: .infinity,
                                        alignment: .leading
                                    )

                                HStack {
                                    TextField(
                                        "",
                                        text: $vm.username,
                                        prompt: Text("Enter your name")
                                            .foregroundColor(Color.ui.onPrimaryContainer)
                                    )
                                    .focused($isFocused)
                                    .onChange(of: vm.username, perform: { newValue in
                                        vm.savePreferences()
                                    })
                                    .frame(height: 36)
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 6)
                                .background {
                                    RoundedRectangle(cornerRadius: 15)
                                        .foregroundColor(Color.ui.onPrimary)
                                }
                                .clipped(antialiased: false)
                                .standardShadow()
                            }
                            .padding(.horizontal, 12)

                            VStack {
                                Text("APP SETTINGS")
                                    .font(.footnote)
                                    .foregroundColor(Color.ui.onPrimaryContainer)
                                    .padding(.vertical, 3)
                                    .padding(.horizontal, 6)
                                    .frame(
                                        maxWidth: .infinity,
                                        alignment: .leading
                                    )
                                VStack(spacing: 12) {
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
                                            .onChange(of: vm.defaultCurrency, perform: { newValue in
                                                vm.savePreferences()
                                            })
                                            .pickerStyle(.menu)
                                            .tint(Color.ui.scheme)
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                            .edgesIgnoringSafeArea(.all)
                                        }
                                    }
                                    .standardShadow()

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

                                    HStack {
                                        Image(systemName: "square.and.arrow.up")
                                            .font(.title2)
                                            .foregroundColor(Color.ui.scheme)
                                            .padding(.trailing, 12)
                                            .frame(width: 36, height: 36)
                                        Text("Export history to spreadsheet")
                                            .foregroundColor(Color.ui.secondary)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal)
                                    .padding(.vertical, 6)
                                    .background {
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundColor(
                                                Color.ui.onPrimary
                                            )
                                    }
                                    .standardShadow()
                                    .onTapGesture {
                                        showAlert = true
                                    }
                                }
                            }
                            .padding(.horizontal, 12)

                            VStack {
                                Text("ABOUT APP")
                                    .font(.footnote)
                                    .foregroundColor(Color.ui.onPrimaryContainer)
                                    .padding(.vertical, 3)
                                    .padding(.horizontal, 6)
                                    .frame(
                                        maxWidth: .infinity,
                                        alignment: .leading
                                    )

                                VStack(spacing: 12) {
                                    HStack {
                                        Image(systemName: "link")
                                            .font(.title2)
                                            .foregroundColor(Color.ui.scheme)
                                            .padding(.trailing, 12)
                                            .frame(width: 36, height: 36)
                                        Text("Privacy Policy")
                                            .foregroundColor(Color.ui.secondary)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal)
                                    .padding(.vertical, 6)
                                    .background {
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundColor(
                                                Color.ui.onPrimary
                                            )
                                    }
                                    .onTapGesture {
                                        openURL(
                                            URL(
                                                string: "https://adamzapior.github.io/bettracker.html"
                                            )!
                                        )
                                    }
                                    .standardShadow()

                                    HStack {
                                        Image(systemName: "link")
                                            .font(.title2)
                                            .foregroundColor(Color.ui.scheme)
                                            .padding(.trailing, 12)
                                            .frame(width: 36, height: 36)
                                        Text("Terms of use")
                                            .foregroundColor(Color.ui.secondary)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal)
                                    .padding(.vertical, 6)
                                    .background {
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundColor(
                                                Color.ui.onPrimary
                                            )
                                    }
                                    .onTapGesture {
                                        openURL(
                                            URL(
                                                string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/"
                                            )!
                                        )
                                    }
                                    .standardShadow()
                                }
                            }
                            .padding(.horizontal, 12)
                        }
                    }
                }
                .safeAreaInset(
                    edge: .top,
                    content: {
                        Text("Preferences")
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "chevron.backward")
                                    .foregroundColor(Color.ui.secondary)
                                    .bold()
                                    .opacity(0.7)
                                    .font(.title2)
                            }

                            Spacer()
                            Spacer()
                        }
                        .padding(.vertical, 6)
                        .padding(.horizontal, 18)
                    }
                )
                .safeAreaInset(edge: .bottom, content: {
                    if isFocused == true {
                        EmptyView()
                    } else {
                        VStack(spacing: 2) {
                            Text("Developed by Adam Zapiór")
                                .font(.footnote)
                                .foregroundColor(Color.ui.onPrimaryContainer)
                        }
                        .padding(.bottom, 12)
                    }
                })
                .frame(maxHeight: .infinity, alignment: .top)
                .onTapGesture {
                    hideKeyboard()
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onDisappear {
            vm.saveTaxSettings()
            vm.savePreferences()
        }
        .onAppear {
            vm.loadSavedPreferences()
        }
    }
}
