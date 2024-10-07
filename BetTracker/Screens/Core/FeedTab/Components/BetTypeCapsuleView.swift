import SwiftUI

struct BetTypeCapsuleView: View {
    let text: String
    let backgroundColor: Color

    init(text: String, backgroundColor: Color = .clear) {
        self.text = text
        self.backgroundColor = backgroundColor
    }

    var body: some View {
        Text(text)
            .font(.title3)
            .bold()
            .frame(minWidth: 76, alignment: .center)
            .padding(.horizontal, 12)
            .padding(.vertical, 3)
            .background {
                backgroundColor
                RoundedRectangle(cornerRadius: 25)
                    .stroke(style: StrokeStyle(lineWidth: 2))
                    .foregroundColor(Color.ui.secondary)
            }
            .clipShape(RoundedRectangle(cornerRadius: 25))
    }
}
