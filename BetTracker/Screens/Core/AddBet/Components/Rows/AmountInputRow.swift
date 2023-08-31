import SwiftUI

struct AmountInputRow: View {
    let hint: String
    @Binding
    var text: String
    let isError: Bool
    let overlayText: String

    var body: some View {
        ZStack {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                TextField(
                    hint,
                    text: $text,
                    prompt: Text(hint)
                        .foregroundColor(Color.ui.onPrimaryContainer)
                )
                .frame(minHeight: 24)
                .overlay {
                    Text(overlayText)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .opacity(0.5)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 12)
                .background {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(isError ? Color.ui.onError : Color.ui.onPrimary)
                }
            }
        }
    }
        .keyboardType(.decimalPad)
        .standardShadow()

    }
}
