import PhotosUI
import SwiftUI

struct ProfileView: View {

    @Environment(\.colorScheme)
    var colorScheme

    @StateObject
    var vm = ProfileVM()

    let size: CGSize = .init()
    let safeArea: EdgeInsets = .init()

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                ProfileHeader()
                EditableCircularProfileImage(vm: vm)
                
                VStack {
                    HStack {
                        Spacer()
                        VStack(spacing: 4) {
                            Text("Hello, Adam!")
                                .font(.title2)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Click and check your betting stats")
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
                .padding(.top, 12) // Spacing beetwen VStack and EditableCircularProfileImage(vm: vm)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: 5)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, -8)
        }
        .onDisappear {
            vm.saveImageIfNeeded()
        }
    }

}
