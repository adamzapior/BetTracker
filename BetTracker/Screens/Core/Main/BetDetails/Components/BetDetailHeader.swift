import SwiftUI

/// TODO: 3 View refactor - opacity, itp
struct BetDetailHeader: View {
    let title: String
    let onBack: () -> Void
    let onDelete: () -> Void

    var body: some View {
        ZStack {
            Text("\(title)")
            HStack {
                Button {
                    onBack()
                } label: {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(Color.ui.secondary)
                        .bold()
                        .opacity(0.7)
                        .font(.title2)
                }

                Spacer()
                Image(systemName: "trash")
                    .foregroundColor(Color.red)
                    .opacity(0.7)
                    .font(.title2)
                    .onTapGesture {
                        onDelete()
                    }
            }
            .padding(.horizontal, 18)
        }
    }
}
