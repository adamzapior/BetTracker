import SwiftUI

struct SearchBarView: View {

    @Binding
    var searchText: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.ui.scheme)
            TextField(text: $searchText) {
                Text("Find your bet").foregroundColor(Color.ui.secondary)
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
                .foregroundColor(Color.ui.secondary)
        )
    }
}
