import SwiftUI

struct OnboardingScreen: View {
    let action: () -> Void

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    VStack(spacing: 0) {
                        headerView()
                            .frame(height: geometry.size.height * 0.75)

                        Spacer(minLength: 20)

                        Section(footer:
                            HStack {
                                Spacer()
                                Button(action: { action() }) {
                                    Text("Get started")
                                        .frame(maxWidth: .infinity)
                                        .font(.headline)
                                }
                                .buttonStyle(ActionButton())

                                Spacer()
                            }
                            .padding(.horizontal, 12)
                            .frame(height: geometry.size.height * 0.25)

                        ) {
                            EmptyView()
                        }
                    }
                }
            }
        }
    }

    private func headerView() -> some View {
        VStack(spacing: 48) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Keep your stats in one place")
                        .foregroundColor(Color.ui.scheme)
                        .font(.largeTitle)
                        .bold()

                    Text("with BetTracker.")
                        .foregroundColor(Color.ui.secondary)
                        .font(.largeTitle)
                        .bold()
                }
                .padding(.horizontal, 12)
                .frame(maxHeight: .infinity, alignment: .center)
            }
        }
    }
}
