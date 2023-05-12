import SwiftUI

struct SearchBarView: View {

    @Binding
    var searchText: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.ui.scheme)
                .shadow(color: Color.ui.shadow.opacity(0.7), radius: 3, x: 3, y: 3)
            TextField(text: $searchText) {
                Text("Find your bet")
                    .foregroundColor(Color.ui.onPrimaryContainer)
                    .shadow(color: Color.ui.scheme.opacity(0.7), radius: 3, x: 3, y: 3)
            }
            .textInputAutocapitalization(.never)
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(Color.red) // TODO: Color.ui.red
                .onTapGesture {
                    searchText = ""
                }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .stroke(style: StrokeStyle(lineWidth: 1))
                .foregroundColor(Color.ui.onPrimaryContainer)
                .shadow(color: Color.ui.shadow.opacity(0.7), radius: 3, x: 3, y: 3)
        )
    }
}
