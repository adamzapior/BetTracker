import SwiftUI

struct TeamInput: View {
    let hint: String
    @Binding
    var text: String
    let isError: Bool
    @Binding
    var isOn: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {

            VStack {
                HStack {
                    HStack {
                        TextField(
                            hint,
                            text: $text,
                            prompt: Text(hint)
                                .foregroundColor(Color.ui.onPrimaryContainer)
                        )
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .background {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(isError ? Color.ui.onError : Color.ui.onPrimary)
                    }
                    .shadow(color: Color.black.opacity(0.1), radius: 1, x: 3, y: 2)
                    Toggle("", isOn: $isOn)
                        .frame(maxWidth: 60)
                        .tint(Color.ui.scheme)
                }
            }
        }
    }
}
