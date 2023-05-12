import SwiftUI

// TODO: 4 View refactor - TextStyle func.

struct BetDetail: View {
    let category: String
    let text: String

    var body: some View {
        HStack {
            Text(category)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title3)
                .bold()
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
            Text(text)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .font(.body)
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
        }
    }
}
