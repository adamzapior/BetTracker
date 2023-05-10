import PhotosUI
import SwiftUI

struct ProfileView: View {

    @Environment(\.colorScheme)
    var colorScheme

    @StateObject
    var vm = ProfileVM()

    @StateObject
    var vmProfilePhoto = ProfilePhotoVM()

    var body: some View {
        VStack {
            ProfileHeader()
                .padding(.top, 18)
                .padding(.bottom, 12)
            ScrollView(showsIndicators: false) {
                EditableCircularProfileImage(vm: vmProfilePhoto)

                VStack {
                    HStack {
                        Spacer()
                        VStack(spacing: 4) {
                            Text("Hello, Adam!")
                                .font(.title2)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Your actual sum of bet amount is: \(vm.allBetsAmount)")
                                .font(.footnote)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.top, 12)
                .padding(.bottom, 12)
                .background {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(Color.ui.onPrimary)
                }
                .frame(maxWidth: .infinity, maxHeight: 100)
                .padding(.horizontal, 20)
                .padding(
                    .top,
                    12
                ) // Spacing beetwen VStack and EditableCircularProfileImage(vm: vm)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: 5)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, -8)
        }
        .onDisappear {
            vmProfilePhoto.saveImageIfNeeded()
        }
    }
}
