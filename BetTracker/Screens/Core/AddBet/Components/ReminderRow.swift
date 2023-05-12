import SwiftUI

struct ReminderRow: View {

    var bodyText: String

    @Binding
    var isOn: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            VStack  {
                HStack {
                        Text(bodyText)
                            .font(.callout)
                            .foregroundColor(Color.ui.onPrimaryContainer)
                        Spacer()
                        Toggle("", isOn: $isOn)
                            .frame(maxWidth: 60)
                            .tint(Color.ui.scheme)
                }
                .frame(maxWidth: .infinity)
                .padding(.leading, 12)
                .padding(.trailing, 8)
                .padding(.vertical, 8)
            }
        }
    }
}
