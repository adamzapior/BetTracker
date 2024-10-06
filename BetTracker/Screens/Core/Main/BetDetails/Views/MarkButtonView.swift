import SwiftUI

enum MarkButtonType {
    case win
    case loss
}

struct MarkButtonView: View {
    let text: String
    var buttonType: MarkButtonType

    var body: some View {
        HStack {
            Spacer()
            Text(text)
                .font(.headline)
                .bold()
                .foregroundColor(Color.ui.secondary)
            Spacer()
            switch buttonType {
            case .win:
                Image(systemName: "checkmark.square.fill")
                    .font(.headline)
            case .loss:
                Image(systemName: "minus.square.fill")
                    .font(.headline)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background {
            switch buttonType {
            case .win:
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(
                        Color.ui.scheme
                    )
                    .opacity(0.7)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.secondary, lineWidth: 0.2)
                    )
            case .loss:
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(
                        Color.red
                    )
                    .opacity(0.7)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.secondary, lineWidth: 0.2)
                    )
            }
        }
        .frame(maxWidth: .infinity)
        .standardShadow()
    }
}
