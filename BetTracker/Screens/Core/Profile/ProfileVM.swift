import CoreTransferable
import PhotosUI
import SwiftUI
import Combine

@MainActor
class ProfileVM: ObservableObject {
    
    @Published
    var allBetsAmount: NSDecimalNumber = .zero
    
    @Published
    var cancellables = Set<AnyCancellable>()
    
    init() {
        checkImageFileExists()
        
        getBetsAmount()
        
        print($cancellables)
    }

    
    func getBetsAmount() {
        BetDao.allBetsAmount()
            .handleEvents(receiveSubscription: { _ in
                       print("getLostBetsSum(): Subscription started")
                   }, receiveOutput: { sum in
                       print("getLostBetsSum(): Sum received: \(sum)")
                   }, receiveCompletion: { completion in
                       print("getLostBetsSum(): Completion received: \(completion)")
                   }, receiveCancel: {
                       print("getLostBetsSum(): Subscription cancelled")
                   })
                   .sink(receiveCompletion: { completion in
                       print("getLostBetsSum(): Sink completed with \(completion)")
                   }, receiveValue: { sum in
                       print("getLostBetsSum(): Sink received value: \(sum)")
                       self.allBetsAmount = sum
                   })
                   .store(in: &cancellables)
        }
    
//    func getBetsAmount() {
//        BetDao.allBetsAmount()
//            .map { .some($0) }
//            .assign(to: &$allBetsAmount)
//    }
//
    
    // MARK: Profile Image Logic

    enum ImageState {
        case empty
        case loading(Progress)
        case success(Image)
        case failure(Error)
    }

    enum TransferError: Error {
        case importFailed
    }

    @Published
    var uiImageToSave: UIImage? // Added***

    struct ProfileImage: Transferable {
        let image: Image
        let uiImageX: UIImage // Added***

        static var transferRepresentation: some TransferRepresentation {
            DataRepresentation(importedContentType: .image) { data in
                    guard let uiImage = UIImage(data: data) else {
                        throw TransferError.importFailed
                    }
                    let image = Image(uiImage: uiImage)
                    return ProfileImage(image: image, uiImageX: uiImage)
            }
        }
    }

    @Published
    private(set) var imageState: ImageState = .empty

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
    
    // MARK:  Public Methods

    func saveImageIfNeeded() {
        switch imageState {
        case .success(_):
            let imageSaver = ImageSaver()
            
            guard uiImageToSave != nil else {
                print("Error: Could not get a new valid UIImage to save")
                return
            }
            imageSaver.writeToDisk(
                image: uiImageToSave!,
                imageName: "image.jpg"
            )
        case .failure:
            print("Image state is failure")
        case .empty:
            print("Image state is empty")
        case .loading(_):
            print("Loading")
        }
    }
    
    // MARK: Private Methods

    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        imageSelection.loadTransferable(type: ProfileImage.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.imageSelection else {
                    print("Failed to get the selected item.")
                    return
                }
                switch result {
                case let .success(profileImage?):
                    self.imageState = .success(profileImage.image)
                    self.uiImageToSave = (profileImage.uiImageX) // Added***
                case .success(nil):
                    self.imageState = .empty
                case let .failure(error):
                    self.imageState = .failure(error)
                }
            }
        }
    }

     func checkImageFileExists() {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
            .first!
        let imageUrl = documentsDirectory.appendingPathComponent("image.jpg")

        if fileManager.fileExists(atPath: imageUrl.path) {
            do {
                let imageData = try Data(contentsOf: imageUrl)
                guard let uiImage = UIImage(data: imageData) else {
                    imageState = .empty
                    return
                }
                let image = Image(uiImage: uiImage)
                imageState = .success(image)
            } catch {
                imageState = .empty
            }
        } else {
            imageState = .empty
        }
    }
}

// Save the user image

class ImageSaver: NSObject {
//    var successHandler: (() -> Void)?
////    var errorHandler: ((Error) -> Void)?

    func writeToDisk(image: UIImage, imageName _: String) {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("image.jpg")

        guard let jpegData = image.jpegData(compressionQuality: 0.5) else {
            print("Error: Unable to convert image to JPEG data")
            return
        }
        do {
            try jpegData.write(to: path, options: [.atomic, .completeFileProtection])
            print("User image saved & updated")
        } catch {
            print("Error: Unable to save image to disk")
        }
    }

}
