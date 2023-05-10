import SwiftUI

struct ReminderInput: View {

    var bodyText: String

    @Binding
    var isOn: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            VStack {
                HStack {
                    HStack {
                        Spacer()
                        Text(bodyText)
                            .foregroundColor(Color.ui.onBackground)
                        Spacer()
                        Toggle("", isOn: $isOn)
                            .frame(maxWidth: 60)
                            .tint(Color.ui.scheme)
                        Spacer()
                    }
                    Spacer()
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 12)
            }
        }
    }
}
