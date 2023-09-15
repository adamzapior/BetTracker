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
    private var selection = "Red"

    @State
    private var showSheet = false

    @State
    private var isTaxOn: Bool = false
    

    var body: some View {
        NavigationView {
            VStack(spacing: 2) {
                HStack {
                    NavigationLink(destination: CategoryEditView()) {
                        Text("Go")
                    }
                }
                .padding(.horizontal, 12)
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(Color.ui.onPrimary)
                }
                .standardShadow()

                Label("Test", systemImage: "link")

                //                CustomFormCell(title: "", value: "")

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
                                .frame(height: 36)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 6)
                            .background {
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundColor(Color.ui.onPrimary)
                            }
                            .standardShadow()
                        }

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
                            VStack(spacing: 6) {
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
                                            ForEach(Currency.allCases, id: \.self) { currency in
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
                                    .standardShadow()

                                    Image(
                                        systemName: isTaxOn
                                            ? "checkmark.square.fill"
                                            : "checkmark.square"
                                    )
                                    .font(.largeTitle)
                                    .foregroundColor(
                                        isTaxOn
                                            ? Color.ui.scheme
                                            : Color.ui
                                                .onPrimaryContainer
                                    )
                                    .onTapGesture {
                                        isTaxOn.toggle()
                                    }
                                }

                                if isTaxOn == true {
                                    HStack {
                                        TextField(
                                            "",
                                            text: $vm.defaultTax,
                                            prompt: Text("Input your default tax")
                                                .foregroundColor(Color.ui.onPrimaryContainer)
                                        )
                                        .frame(height: 36)

                                        //                    .disabled(!vm.isDefaultTaxOn)
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
                                }

                                HStack {
                                    Image(systemName: "square.and.arrow.up")
                                        .font(.title2)
                                        .foregroundColor(Color.ui.scheme)
                                        .padding(.trailing, 12)
                                        .frame(width: 36, height: 36)
                                    Text("Export to spreadsheet")
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
                            }
                        }

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

                            VStack(spacing: 6) {
                                HStack {
                                    Image(systemName: "link")
                                        .font(.title2)
                                        .foregroundColor(Color.ui.scheme)
                                        .padding(.trailing, 12)
                                        .frame(height: 36)
                                    Text("Privacy Policy")
                                        .foregroundColor(Color.ui.secondary)
                                    Image(systemName: "link")
                                        .font(.title2)
                                        .foregroundColor(Color.ui.scheme)
//                                        .padding(.trailing, 12)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                    
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

                        //                Form {
                        //                    Section(
                        //                        header: Text("Your name")
                        //                            .foregroundColor(Color.ui.onPrimaryContainer)
                        //                            .frame(
                        //                                maxWidth: .infinity,
                        //                                alignment: .leading
                        //                            )
                        //                    ) {
                        //                        TextField("Enter your name", text: $vm.username)
                        //                            .textFieldStyle(.plain)
                        //                            .listRowBackground(Color.ui.onPrimary)
                        //                    }
                        //                    .standardShadow()
                        //
                        //
                        //
                        //
                        //                    Section(
                        //                        header: Text("App settings")
                        //                            .foregroundColor(Color.ui.onPrimaryContainer)
                        //                            .frame(
                        //                                maxWidth: .infinity,
                        //                                alignment: .leading
                        //                            )
                        //                    ) {
                        //                        Picker("Choose your currency", selection:
                        //                        $vm.defaultCurrency) {
                        //                            ForEach(Currency.allCases, id: \.self) {
                        //                            currency in
                        //                                Text("\(currency.rawValue.uppercased())")
                        //                            }
                        //                        }
                        //                        .listRowBackground(Color.ui.onPrimary)
                        //                        .tint(Color.ui.scheme)
                        //                        .pickerStyle(.menu)
                        //
                        //                        Toggle("Do you want use tax rate?", isOn:
                        //                        $vm.isDefaultTaxOn)
                        //                            .listRowBackground(Color.ui.onPrimary)
                        //                            .tint(Color.ui.scheme)
                        //
                        //                        if vm.taxStatus == .taxUnsaved {
                        //                            TextField("Input your default tax", text:
                        //                            $vm.defaultTax)
                        //                                .disabled(!vm.isDefaultTaxOn)
                        //                                .keyboardType(.decimalPad)
                        //                                .overlay {
                        //                                    Text("%")
                        //                                        .frame(maxWidth: .infinity, alignment: .trailing)
                        //                                        .opacity(0.5)
                        //                                }
                        //                                .textFieldStyle(.plain)
                        //                                .animation(.easeInOut, value: 1)
                        //                        }
                        //
                        //
                        //
                        //                        Button {
                        //                            vm.exportToCSV()
                        //                        } label: {
                        //                            Label("Export to CSV", systemImage:
                        //                            "square.and.arrow.up")
                        //                                .foregroundColor(Color.ui.scheme)
                        //                        }
                        //                        .listRowBackground(Color.ui.onPrimary)
                        //                        .buttonStyle(BorderlessButtonStyle())
                        //
                        //                        Button("Sheet", action: {
                        //                            showSheet.toggle()
                        //                        })
                        //                        .sheet(isPresented: $showSheet, content: {CategoryEditView()})
                        //
                        //                        Button {
                        //                            showSheet.toggle()
                        //                        } label: {
                        //                            Label("Export to CSV", systemImage:
                        //                            "square.and.arrow.up")
                        //                                .foregroundColor(Color.ui.scheme)
                        //                        }
                        //                        .sheet(isPresented: $showSheet, content: {CategoryEditView()})
                        //                        .listRowBackground(Color.ui.onPrimary)
                        //                        //
                        //                        /.buttonStyle(BorderlessButtonStyle())
                        //
                        //                        VStack {
                        //                        NavigationLink(destination: CategoryEditView()) {
                        //                            Text("Go to Setting Details")
                        //                        }
                        //                    }
                        //                    }
                        //
                        //                    Section(
                        //                        header: Text("App info")
                        //                            .foregroundColor(Color.ui.onPrimaryContainer)
                        //                            .frame(
                        //                                maxWidth: .infinity,
                        //                                alignment: .leading
                        //                            )
                        //                    ) {
                        //                        Button {
                        //                            openURL(
                        //                                URL(string: "https://adamzapior.github.io/bettracker.html")!
                        //                            )
                        //
                        //                        } label: {
                        //                            Label("Privacy Policy", systemImage: "link")
                        //                                .foregroundColor(Color.ui.secondary)
                        //                        }
                        //                        .listRowBackground(Color.ui.onPrimary)
                        //                        .buttonStyle(BorderlessButtonStyle())
                        //
                        //                                            Button {
                        //                                                openURL(
                        //                                                    URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!
                        //                                                )
                        //
                        //                        } label: {
                        //                            Label("Terms of use", systemImage: "link")
                        //                                .foregroundColor(Color.ui.secondary)
                        //                        }
                        //                        .listRowBackground(Color.ui.onPrimary)
                        //                        .buttonStyle(BorderlessButtonStyle())
                        //
                        //
                        //    //                    .padding(.top, 24)
                        //
                        //                    }
                        //
                        //                }
                        //                .scrollContentBackground(.hidden)
                        ////                    .frame(height: 800, alignment: .topLeading)
                        //                .standardShadow()
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
                VStack(spacing: 2) {
//                    Text("BetTracker")
//                        .font(.callout)
//                        .foregroundColor(Color.ui.onPrimaryContainer)
                    Text("Developed by Adam Zapiór")
                        .font(.footnote)
                        .foregroundColor(Color.ui.onPrimaryContainer)
                }
                .padding(.bottom, 12)
            })
            .padding(.horizontal, 12)
            .frame(maxHeight: .infinity, alignment: .top)
            .onTapGesture {
                hideKeyboard()
            }
        }
        .navigationBarBackButtonHidden()
        .onDisappear {
            vm.ifTaxEmpty()
            vm.savePreferences()
        }
        .onAppear {
//            vm.loadSavedPreferences()
//            vm.getDefaultCurrency()
        }
    }
}
