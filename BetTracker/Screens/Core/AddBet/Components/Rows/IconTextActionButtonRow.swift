import SwiftUI

struct IconTextActionButtonRow: View {

    let icon: String
    let labelText: String
    let actionButtonIcon: String
    let action: () -> Void

    init(
        icon: String,
        labelText: String,
        actionButtonIcon: String,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.labelText = labelText
        self.actionButtonIcon = actionButtonIcon
        self.action = action
    }

    var body: some View {
        ZStack {
            HStack {
                Image(systemName: "\(icon)")
                    .font(.title2)
                    .foregroundColor(Color.ui.scheme)
                    .padding(.trailing, 12)
                    .frame(width: 36, height: 36)

                Text(labelText)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(Color.ui.secondary)
                    .padding(.vertical, 16)
                Spacer()
                Image(systemName: "\(actionButtonIcon)")
                    .font(.title)
                    .foregroundColor(Color.ui.onPrimaryContainer)
                    .onTapGesture {
                        action()
                    }
            }
            .padding(.horizontal)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(
                        Color.ui.onPrimary
                    )
            }

            .frame(maxWidth: .infinity)
            .edgesIgnoringSafeArea(.all)
        }
        .standardShadow()
    }

}
