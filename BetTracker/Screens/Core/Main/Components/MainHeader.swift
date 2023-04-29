import SwiftUI

struct MainHeader: View {
    var body: some View {
        ZStack {
            Text("Welconm, Adam")
            HStack {
                Spacer()
                NavigationLink(
                    destination: { SearchView() },
                    label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color.ui.scheme)
                            .opacity(0.7)
                            .font(.title2)
                    }
                )
            }
            .padding(.trailing, 18)
        }
    }
}
