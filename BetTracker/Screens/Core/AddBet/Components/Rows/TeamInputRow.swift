import SwiftUI

struct TeamInputRow: View {
    let hint: String
    @Binding
    var text: String
    let isError: Bool
    @Binding
    var isOn: Bool
    var action: () -> Void
    
    @FocusState.Binding var isFocused: Bool
    
    var body: some View {
        HStack {
            HStack {
                TextField(
                    hint,
                    text: $text,
                    prompt: Text(hint)
                        .foregroundColor(Color.ui.onPrimaryContainer)
                )
                .focused($isFocused)
                
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(isError ? Color.ui.onError : Color.ui.onPrimary)
            }
            .standardShadow()

            Image(
                systemName: isOn
                    ? "checkmark.square.fill"
                    : "checkmark.square"
            )
            .font(.largeTitle)
            .foregroundColor(isOn ? Color.ui.scheme : Color.ui.onPrimaryContainer)
            .onTapGesture {
                action()
            }
        }
    }
}
