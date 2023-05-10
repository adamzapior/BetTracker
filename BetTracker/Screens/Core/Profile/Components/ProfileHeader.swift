import SwiftUI

struct ProfileHeader: View {

    
    var body: some View {
        ZStack {
            Text("Your stats")
            HStack {
                Spacer()
                NavigationLink(
                    destination: { PreferencesView() },
                    label: {
                        Image(systemName: "gear")
                            .foregroundColor(Color.ui.scheme)
                            .font(.title2)
                    }
                )
            }
            .padding(.trailing, 18)
        }
    }
}

struct ProfileHeader_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeader()
    }
}
