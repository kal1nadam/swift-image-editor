import SwiftUI

class ImageEditorModel: ObservableObject {
    @Published var currentImage: NSImage?
    private var originalImage: NSImage?
    
    func pickImage() {
        ImagePicker.pickImage { [weak self] image in
            DispatchQueue.main.async {
                if let image = image {
                    self?.currentImage = image
                    self?.originalImage = image.copy() as? NSImage
                }
            }
        }
    }
    
    func applyRedFilter() {
        guard let currentImage = currentImage else { return }
        self.currentImage = ImageProcessing.applyRedFilter(to: currentImage)
    }
    
    func resetImage() {
        if let originalImage = originalImage {
            self.currentImage = originalImage.copy() as? NSImage
        }
    }
}
