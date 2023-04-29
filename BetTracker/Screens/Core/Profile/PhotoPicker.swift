//
//  PhotoPicker.swift
//  BetTracker
//
//  Created by Adam Zapiór on 29/04/2023.
//

import SwiftUI

struct PhotoPicker: UIViewControllerRepresentable {
    
    @Binding var avatarImage: UIImage

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(photopicker: self)
    }
    
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let photoPicker: PhotoPicker
        
        init(photopicker: PhotoPicker) {
            self.photoPicker = photopicker
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage {
                photoPicker.avatarImage = image
            } else {
                // return an error show alert
            }
            picker.dismiss(animated: true)
        }
    }
}
