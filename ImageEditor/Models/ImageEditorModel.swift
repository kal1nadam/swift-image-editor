import SwiftUI

class ImageEditorModel: ObservableObject {
    private var imageProcessing = ImageProcessing()
    
    @Published var currentImage: NSImage?
    private var originalImage: NSImage?
    @Published var processingTime: TimeInterval = 0
    @Published var taskIsRunning: Bool = false
    
    private var currentTask: Task<Void, Never>?
    
    
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
        
        currentTask?.cancel()
        taskIsRunning = true
        currentTask = Task{
            let start = Date()
            let processedImage = imageProcessing.applyRedFilter(to: currentImage, parallel: parallel)
            let end = Date()
            
            let elapsedTime = end.timeIntervalSince(start)
            
            // Check if Task was cancelled
            if Task.isCancelled { return }
            
            self.currentImage = processedImage
            self.processingTime = elapsedTime
            taskIsRunning = false
        }
    }
    
    func applyBlackAndWhiteFilter(parallel: Bool = false) {
        guard let currentImage = currentImage else { return }
        
        currentTask?.cancel()
        taskIsRunning = true
        currentTask = Task{
            let start = Date()
            let processedImage = imageProcessing.applyBlackAndWhiteFilter(to: currentImage, parallel: parallel)
            let end = Date()
            
            let timeElapsed = end.timeIntervalSince(start)
            
            // Check if Task was cancelled
            if Task.isCancelled { return }
            
            self.currentImage = processedImage
            self.processingTime = timeElapsed
            taskIsRunning = false
        }
    }
    
    func applyEdgeDetection(parallel: Bool = false) {
        guard let currentImage = currentImage else { return }
        
        currentTask?.cancel()
        taskIsRunning = true
        currentTask = Task{
            let start = Date()
            let processedImage = imageProcessing.applyEdgeDetection(to: currentImage, parallel: parallel)
            let end = Date()
            
            let elapsedTime = end.timeIntervalSince(start)
            
            // Check if Task was cancelled
            if Task.isCancelled { return }
            
            self.currentImage = processedImage
            self.processingTime = elapsedTime
            taskIsRunning = false
        }
    }
    
    func resetImage() {
        taskIsRunning = false
        currentTask?.cancel()
        self.processingTime = 0
        if let originalImage = originalImage {
            self.currentImage = originalImage.copy() as? NSImage
        }
    }
    
    func cancelTask(){
        taskIsRunning = false
        currentTask?.cancel()
        self.processingTime = 0
    }
}
