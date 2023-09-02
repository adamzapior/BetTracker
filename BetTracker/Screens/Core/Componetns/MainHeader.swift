import SwiftUI

struct MainHeader: View {
    let name: String
    let destinationView: () -> AnyView
    let icon: String
    
    init(name: String, destinationView: @escaping () -> AnyView, icon: String) {
        self.name = name
        self.destinationView = destinationView
        self.icon = icon
    }

    var body: some View {
        ZStack {
            Text("\(name)")
            HStack {
                Spacer()
                NavigationLink(
                    destination: destinationView,
                    label: {
                        Image(systemName: icon)
                            .foregroundColor(Color.ui.scheme)
                            .opacity(1)
                            .font(.title2)
                    }
                )
            }
            .padding(.vertical, 6)
            .padding(.trailing, 18)
        }
    }
}
