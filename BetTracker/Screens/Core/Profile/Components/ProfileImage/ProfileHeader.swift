import SwiftUI

struct ProfileHeader: View {

   
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Text("Your stats - last 7 days")
                    Image(systemName: "chevron.down")
                    
                }
                .pickerStyle(.menu)
                .tint(Color.ui.scheme)
            }
            
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

