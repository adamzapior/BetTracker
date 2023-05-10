import SwiftUI

struct MainHeader: View {
    var body: some View {
        ZStack {
            Text("Welcome, Adam")
            HStack {
                Spacer()
                NavigationLink(
                    destination: { SearchView() },
                    label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color.ui.scheme)
                            .opacity(1) // before 0.7
                            .font(.title2)
                    }
                )
            }
            .padding(.trailing, 18)
        }
    }
}
