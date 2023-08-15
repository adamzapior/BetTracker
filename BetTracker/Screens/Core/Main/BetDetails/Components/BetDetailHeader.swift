import SwiftUI

/// TODO: 3 View refactor - opacity, itp
struct BetDetailHeader: View {
    let onDelete: () -> Void

    var body: some View {
        ZStack {
            Text("Your pick")
            HStack {
                Spacer()
                Image(systemName: "trash")
                    .foregroundColor(Color.red)
                    .opacity(0.7)
                    .font(.title2)
                    .onTapGesture {
                        onDelete()
                    }
            }
            .padding(.trailing, 18)
        }
    }
}
