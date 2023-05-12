import SwiftUI

struct ReminderIsActive: View {

    let icon: String
    let labelText: String
    let actionButtonIcon: String
    
    let action: () -> Void


    var body: some View {
        ZStack {
         
                
                HStack {
                    Image(systemName: "\(icon)")
                        .font(.headline)
                        .foregroundColor(Color.ui.scheme)
                        .padding(.vertical, 12)
                    Spacer()
                        Text(labelText)
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(Color.ui.onPrimaryContainer)
                            .padding(.vertical, 16)
                    Spacer()
                    Image(systemName: "\(actionButtonIcon)")
                        .font(.title)
                        .foregroundColor(Color.ui.secondary)
                        .onTapGesture {
                            action()
                        }
                        .padding(.leading, 100)
                }
                .padding(.leading, 3)
                .padding(.horizontal)
                .background {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(
                            Color.ui.onPrimary
                        )
                }
            
            .frame(maxWidth: .infinity)
            .edgesIgnoringSafeArea(.all)
        }
    }

}

// struct ReminderIsActive_Previews: PreviewProvider {
//
//    static var previews: some View {
//        ReminderIsActive(vm: vm)
//    }
// }
