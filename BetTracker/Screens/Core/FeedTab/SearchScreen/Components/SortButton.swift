import SwiftUI

struct SortButton: View {
    let text: String
    let backgroundColor: Color
    @Binding
    var isChecked: Bool
    let onTap: () -> Void

    init(
        text: String,
        backgroundColor: Color = .clear,
        isChecked: Bool = false,
        onTap: @escaping () -> Void
    ) {
        self.text = text
        self.backgroundColor = backgroundColor
        _isChecked = Binding.constant(isChecked)
        self.onTap = onTap
    }

    var body: some View {
        Text(text)
            .font(.callout)
            .bold()
            .frame(alignment: .center)
            .padding(.horizontal, 12)
            .padding(.vertical, 3)
            .background {
                backgroundColor
                RoundedRectangle(cornerRadius: 25)
                    .stroke(style: StrokeStyle(lineWidth: 2))
                    .foregroundColor(isChecked ? Color.ui.scheme : Color.ui.onPrimaryContainer)
            }
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .onTapGesture {
                onTap()
            }
    }
}
