import SwiftUI

struct ReminderIsActive: View {

    let icon: String
    let labelText: String
    let actionButtonIcon: String
    let actionButtonColor: Color

    let action: () -> Void

    init(
        icon: String,
        labelText: String,
        actionButtonIcon: String,
        actionButtonColor: Color,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.labelText = labelText
        self.actionButtonColor = actionButtonColor
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
                    .foregroundColor(Color.ui.secondary)
                    .onTapGesture {
                        action()
                    }
//                    .padding(.leading, 100)
            }
//            .padding(.leading, 3)
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
    }

}

//
// struct ReminderIsActive_Previews: PreviewProvider {
//
//    static var previews: some View {
//        ReminderIsActive(icon: "bell", labelText: "Reminder is off", actionButtonIcon: "plus.app.fill", actionButtonColor: Color.red) {
//            //
//        }
//
//    }
// }
