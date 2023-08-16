import SwiftUI

struct MainHeader: View {
    let name: String
    var body: some View {
        ZStack {
            Text("\(name)")
            HStack {
                Spacer()
                NavigationLink(
                    destination: { SearchView() },
                    label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color.ui.scheme)
                            .opacity(1)
                            .font(.title2)
                    }
                )
            }
            .padding(.trailing, 18)
        }
    }
}
