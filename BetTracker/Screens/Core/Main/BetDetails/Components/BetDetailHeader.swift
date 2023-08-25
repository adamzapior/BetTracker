import SwiftUI

/// TODO: 3 View refactor - opacity, itp
struct BetDetailHeader: View {
    let title: String
    let isNotificationOn: Bool
    let onBack: () -> Void
    let onDelete: () -> Void
    let onNotification: (() -> Void)?

    init(
        title: String,
        isNotificationOn: Bool,
        onBack: @escaping () -> Void,
        onDelete: @escaping () -> Void,
        onNotification: (() -> Void)? = nil
    ) {
        self.title = title
        self.isNotificationOn = isNotificationOn
        self.onBack = onBack
        self.onDelete = onDelete
        self.onNotification = onNotification
    }

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
                if isNotificationOn == true {
                    Image(systemName: "bell.fill")
                        .foregroundColor(Color.yellow)
                        .opacity(0.7)
                        .font(.title2)
                        .onTapGesture {
                            (onNotification ?? { })()
                        }
                } else {
                    EmptyView()
                }
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
