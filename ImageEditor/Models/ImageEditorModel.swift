import SwiftUI

class ImageEditorModel: ObservableObject {
    @Published var currentImage: NSImage?
    private var originalImage: NSImage?
    @Published var processingTime: TimeInterval = 0
    
    
    func pickImage() {
        self.processingTime = 0
        ImagePicker.pickImage { [weak self] image in
            DispatchQueue.main.async {
                if let image = image {
                    self?.currentImage = image
                    self?.originalImage = image.copy() as? NSImage
                }
            }
        }
    }
    
    func applyRedFilter(parallel: Bool = false) {
        guard let currentImage = currentImage else { return }
        
        let start = Date()
        self.currentImage = ImageProcessing.applyRedFilter(to: currentImage, parallel: parallel)
        let end = Date()
        
        self.processingTime = end.timeIntervalSince(start)
    }
    
    func applyEdgeDetection(parallel: Bool = false) {
        guard let currentImage = currentImage else { return }
        
        let start = Date()
        self.currentImage = ImageProcessing.applyEdgeDetection(to: currentImage, parallel: parallel)
        let end = Date()
        
        self.processingTime = end.timeIntervalSince(start)
    }
    
    func resetImage() {
        self.processingTime = 0
        if let originalImage = originalImage {
            self.currentImage = originalImage.copy() as? NSImage
        }
    }
}
