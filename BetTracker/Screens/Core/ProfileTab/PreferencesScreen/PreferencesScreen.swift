import Combine
import SwiftUI

struct PreferencesScreen: View {
    @Environment(\.openURL) var openURL
    @StateObject var vm = PreferencesViewModel()
    @State private var showExportAlert = false
    
    var body: some View {
        ZStack {
            alertView()
            VStack {
                Form {
                    nameSection()
                    appSettingsSection()
                    aboutAppSection()
                }
            }
        }
        .navigationTitle("Preferences")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            vm.savePreferences()
        }
        .onAppear {
            vm.loadSavedPreferences()
        }
    }
    
    private func nameSection() -> some View {
        Section(header: Text("YOUR NAME")) {
            TextField("Enter your name", text: $vm.username)
                .onChange(of: vm.username) { _, newValue in
                    vm.username = vm.filterNameInput(newValue)
                    vm.savePreferences()
                }
        }
    }
    
    private func appSettingsSection() -> some View {
        Section(header: Text("APP SETTINGS")) {
            Picker("Choose your currency", selection: $vm.defaultCurrency) {
                ForEach(Currency.allCases.sorted(by: { $0.rawValue < $1.rawValue }), id: \.self) { currency in
                    Text(currency.rawValue.uppercased())
                }
            }
            .onChange(of: vm.defaultCurrency) {
                vm.savePreferences()
            }
            
            Toggle("Do you want to use tax rate?", isOn: $vm.isTaxTextfieldOn)
            
            if vm.isTaxTextfieldOn {
                HStack {
                    TextField("Input your default tax", text: $vm.defaultTax)
                        .keyboardType(.decimalPad)
                        .onChange(of: vm.defaultTax) { _, newValue in
                            vm.defaultTax = vm.filterTaxInput(newValue)
                            vm.savePreferences()
                        }
                    Text("%")
                }
            }
            
            if let url = URL(string: UIApplication.openSettingsURLString) {
                Link(destination: url, label: {
                    Label("Notification settings", systemImage: "bell")
                })
            }
            
            Button(action: {
                showExportAlert = true
            }) {
                Label("Export history to spreadsheet", systemImage: "square.and.arrow.up")
            }
        }
    }
    
    private func aboutAppSection() -> some View {
        Section(header: Text("ABOUT APP")) {
            Link(destination: URL(string: "https://adamzapior.github.io/bettracker.html")!) {
                Label("Privacy Policy", systemImage: "link")
            }
            
            Link(destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!) {
                Label("Terms of use", systemImage: "link")
            }
        }
    }
    
    private func alertView() -> some View {
        CustomAlertView(isPresented: $showExportAlert,
                        title: "Export to CSV",
                        messages: ["Your file will be saved in your files, in the BetTracker folder"],
                        primaryButtonLabel: "Export",
                        primaryButtonAction: { vm.exportToCSV() },
                        secondaryButtonLabel: "Cancel",
                        secondaryButtonAction: { showExportAlert = false })
    }
}
