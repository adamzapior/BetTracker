import SwiftUI

struct AmountInput: View {
    let hint: String
    @Binding
    var text: String
    let isError: Bool
    let overlayText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                TextField(
                    hint,
                    text: $text,
                    prompt: Text(hint)
                        .foregroundColor(Color.ui.onPrimaryContainer)
                )
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
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(Color.ui.onPrimary)
            }
            .shadow(color: Color.black.opacity(0.1), radius: 1, x: 3, y: 2)
        }
        .keyboardType(.decimalPad)
    }
}
