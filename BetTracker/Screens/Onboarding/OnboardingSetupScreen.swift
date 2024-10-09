import SwiftUI

struct OnboardingSetupScreen: View {
    @StateObject var viewModel = PreferencesViewModel()
    let action: () -> Void
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    Color(UIColor.systemGroupedBackground).ignoresSafeArea()
                    VStack(spacing: 0) {
                        Form {
                            nameSectionView()
                            appSettingsSectionView()
                        }
                        .frame(height: geometry.size.height * 0.75)
                            
                        Spacer(minLength: 20)
                            
                        getStartedButtonView()
                            .frame(height: geometry.size.height * 0.25)
                    }
                }
            }
            .navigationTitle("Setup preferences")
            .navigationBarTitleDisplayMode(.inline)
            .onTapGesture {
                hideKeyboard()
            }
            .onDisappear {
                viewModel.savePreferences()
            }
        }
    }
    
    private func nameSectionView() -> some View {
        Section(header: Text("YOUR NAME")) {
            TextField("Enter your name", text: $viewModel.username)
                .onChange(of: viewModel.username) { _, newValue in
                    viewModel.username = viewModel.filterNameInput(newValue)
                    viewModel.savePreferences()
                }
        }
    }
    
    private func appSettingsSectionView() -> some View {
        Section(header: Text("APP SETTINGS")) {
            Picker("Choose your currency", selection: $viewModel.defaultCurrency) {
                ForEach(Currency.allCases.sorted(by: { $0.rawValue < $1.rawValue }), id: \.self) { currency in
                    Text(currency.rawValue.uppercased())
                }
            }
            .onChange(of: viewModel.defaultCurrency) {
                viewModel.savePreferences()
            }
            
            Toggle("Do you want to use tax rate?", isOn: $viewModel.isTaxTextfieldOn)
            
            if viewModel.isTaxTextfieldOn {
                HStack {
                    TextField("Input your default tax", text: $viewModel.defaultTax)
                        .keyboardType(.decimalPad)
                        .onChange(of: viewModel.defaultTax) { _, newValue in
                            viewModel.defaultTax = viewModel.filterTaxInput(newValue)
                            viewModel.savePreferences()
                        }
                    Text("%")
                }
            }
        }
    }

    private func getStartedButtonView() -> some View {
        GeometryReader { geometry in
            VStack {
                Button(action: {
                    action()
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.ui.background)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.ui.secondary, lineWidth: 1)
                            )
                        
                        Text("Get started")
                            .font(.title2)
                            .bold()
                            .foregroundColor(Color.ui.secondary)
                    }
                    .frame(width: max(min(geometry.size.width - 24, 300), 100), height: 56)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 72)
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottom)
            .padding(.bottom, 48)
        }
    }
}
