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
                .foregroundColor(Color.ui.background)
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
                .opacity(1)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.secondary, lineWidth: 0.2)
                )
        }

        .frame(maxWidth: .infinity)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5)
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
                .foregroundColor(Color.ui.background)
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
                .opacity(1)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.secondary, lineWidth: 0.2)
                )
        }

        .frame(maxWidth: .infinity)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5)
    }
}
