import SwiftUI

struct MarkWonButton: View {
    let text: String

    init(text: String) {
        self.text = text
    }

    var body: some View {
        HStack {
            Spacer()
            Text(text)
                .font(.headline)
                .bold()
                .foregroundColor(Color.white)
            Spacer()
            Image(systemName: "checkmark.square.fill")
                .font(.headline)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(
                    Color.ui.scheme
                )
                .opacity(0.7)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.secondary, lineWidth: 0.2)
                )
        }

        .frame(maxWidth: .infinity)
        .standardShadow()
    }
}

struct MarkLostButton: View {
    let text: String

    init(text: String) {
        self.text = text
    }

    var body: some View {
        HStack {
            Spacer()
            Text(text)
                .font(.headline)
                .bold()
                .foregroundColor(Color.white)
            Spacer()
            Image(systemName: "minus.square.fill")
                .font(.headline)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background {
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

        .frame(maxWidth: .infinity)
        .standardShadow()
    }
}
