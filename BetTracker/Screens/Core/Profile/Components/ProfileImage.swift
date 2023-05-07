import PhotosUI
import SwiftUI

struct ProfileImage: View {
    let imageState: ProfileVM.ImageState

    var body: some View {
        switch imageState {
        case let .success(image):
            image.resizable()
        case .loading:
            ProgressView()
        case .empty:
            Image(systemName: "person.fill")
                .font(.system(size: 40))
                .foregroundColor(Color.ui.secondary)
        case .failure:
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(Color.ui.secondary)
        }
    }
}

struct CircularProfileImage: View {
    let imageState: ProfileVM.ImageState

    var body: some View {
        ProfileImage(imageState: imageState)
            .scaledToFill()
            .clipShape(Circle())
            .frame(width: 120, height: 120)
            .background {
                Circle().fill(
                    LinearGradient(
                        colors: [Color.ui.imageGradinetColor, Color.ui.scheme],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
    }
}

struct EditableCircularProfileImage: View {
    @ObservedObject
    var vm: ProfileVM
//    let imageSaver = ImageSaver()

    var body: some View {
        CircularProfileImage(imageState: vm.imageState)
            .overlay(alignment: .bottomTrailing) {
                PhotosPicker(
                    selection: $vm.imageSelection,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Image(systemName: "pencil.circle.fill")
                        .symbolRenderingMode(.multicolor)
                        .font(.system(size: 30))
                        .foregroundColor(Color.ui.scheme)
                }
                .buttonStyle(.borderless)
            }
    }
}
