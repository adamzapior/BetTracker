import SwiftUI

struct OnboardingView: View {

    let action: () -> Void
    
    @State private var scale = 1.0

    var body: some View {
        NavigationStack {
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
                    .frame(maxHeight: .infinity, alignment: .center)
                }

                Button("Continue") {
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

                Spacer()
            }
        }
        .navigationBarBackButtonHidden()
        .frame(maxHeight: .infinity, alignment: .center)
    }
}
