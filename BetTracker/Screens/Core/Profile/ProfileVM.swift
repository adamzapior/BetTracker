import _PhotosUI_SwiftUI
import Foundation
import PhotosUI

class ProfileVM: ObservableObject {

    @Published
    var imageSelection: PhotosPickerItem? = nil {
        didSet {
            if let imageSelection {
                let progress = loadTransferable(from: imageSelection)
                imageState = .loading(progress)
            } else {
                imageState = .empty
            }
        }
    }

    @Published
    var data: Data?

}
