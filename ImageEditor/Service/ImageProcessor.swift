//
//  ImageProcessor.swift
//  ImageEditor
//
//  Created by Adam Kalina on 11/28/24.
//

import AppKit

struct ImageProcessing {
    mutating func applyRedFilter(to image: NSImage, parallel: Bool) -> NSImage {
        // get a bitmap
        guard let bitmap = NSBitmapImageRep(data: image.tiffRepresentation!) else { return image }
        
        // Ensure we have access to bitmap data
        guard let pixelBuffer = bitmap.bitmapData else { return image }
        
        let bytesPerPixel = bitmap.bitsPerPixel / 8
        let width = bitmap.pixelsWide
        let height = bitmap.pixelsHigh
        
//        currentTask?.cancel()
        
        if(parallel){
            DispatchQueue.concurrentPerform(iterations: height) { row in
                for col in 0..<width {
                    let pixelIndex = (row * width + col) * bytesPerPixel
                    pixelBuffer[pixelIndex] = 255
                }
            }
        }
        else{
            for row in 0..<height {
                for col in 0..<width {
                    
                    let pixelIndex = (row * width + col) * bytesPerPixel
                                    
                    // Modify the red component
                    pixelBuffer[pixelIndex] = 255
                }
            }
            
        }
        
        
        // Create a new NSImage from the modified bitmap
        let filteredImage = NSImage(size: image.size)
        filteredImage.addRepresentation(bitmap)
        
        print("Applied red filter")
        return filteredImage
    }
    
    func applyEdgeDetection(to image: NSImage, parallel: Bool) -> NSImage{
        // Convert the image into bitmap
        guard let bitmap = NSBitmapImageRep(data: image.tiffRepresentation!) else { return image }
        guard let pixelBuffer = bitmap.bitmapData else { return image }
        
        let bytesPerPixel = bitmap.bitsPerPixel / 8
        let width = bitmap.pixelsWide
        let height = bitmap.pixelsHigh
        
        // Create a buffer for the output image
        var outputBuffer = [UInt8](repeating: 0, count: width * height * bytesPerPixel)
        
        // Sobel kernels
        let kx: [[Int]] = [
            [-1, 0, 1],
            [-2, 0, 2],
            [-1, 0, 1]
        ]
        
        let ky: [[Int]] = [
            [1, 2, 1],
            [0, 0, 0],
            [-1, -2, -1]
        ]
        
        if(parallel){
            
            DispatchQueue.concurrentPerform(iterations: height - 2) { row in
                let actualRow = row + 1 // Adjust row index to match the original range (1..<height-1)
                for col in 1..<width-1 {
                    var gx = 0
                    var gy = 0
                    
                    for kyIndex in -1...1 {
                        for kxIndex in -1...1 {
                            let pixelIndex = ((actualRow + kyIndex) * width + (col + kxIndex)) * bytesPerPixel
                            let intensity = Int(pixelBuffer[pixelIndex + 1]) // Use red component as intensity
                            
                            gx += intensity * kx[kyIndex + 1][kxIndex + 1]
                            gy += intensity * ky[kyIndex + 1][kxIndex + 1]
                        }
                    }
                    
                    let magnitude = UInt8(min(sqrt(Double(gx * gx + gy * gy)), 255))
                    
                    let outputIndex = (actualRow * width + col) * bytesPerPixel
                    outputBuffer[outputIndex] = magnitude
                    outputBuffer[outputIndex + 1] = magnitude
                    outputBuffer[outputIndex + 2] = magnitude
                    outputBuffer[outputIndex + 3] = 255 // Alpha channel
                }
            }
        }
        else{
            
            for row in 1..<height-1 {
                for col in 1..<width-1 {
                    var gx = 0
                    var gy = 0
                    
                    for kyIndex in -1...1 {
                        for kxIndex in -1...1 {
                            let pixelIndex = ((row + kyIndex) * width + (col + kxIndex)) * bytesPerPixel
                            let intensity = Int(pixelBuffer[pixelIndex+1]) // Use red component as intensity
                                            
                            gx += intensity * kx[kyIndex + 1][kxIndex + 1]
                            gy += intensity * ky[kyIndex + 1][kxIndex + 1]
                        }
                    }
                    
                    let magnitude = UInt8(min(sqrt(Double(gx * gx + gy * gy)), 255))
                    
                    let outputIndex = (row * width + col) * bytesPerPixel
                    outputBuffer[outputIndex] = magnitude
                    outputBuffer[outputIndex + 1] = magnitude
                    outputBuffer[outputIndex + 2] = magnitude
                    outputBuffer[outputIndex + 3] = 255 // Alpha channel
                }
            }
        }
        
        
        
        // Create a new bitmap with the output buffer
        let outputImage = NSImage(size: image.size)
        
        outputBuffer.withUnsafeMutableBytes { rawBuffer in
            if let baseAddress = rawBuffer.baseAddress {
                // Create a mutable pointer for the bitmapDataPlanes parameter
                var planes: [UnsafeMutablePointer<UInt8>?] = [baseAddress.assumingMemoryBound(to: UInt8.self)]
                planes.withUnsafeMutableBufferPointer { planesBuffer in
                    let outputBitmap = NSBitmapImageRep(
                        bitmapDataPlanes: planesBuffer.baseAddress,
                        pixelsWide: width,
                        pixelsHigh: height,
                        bitsPerSample: 8,
                        samplesPerPixel: 4,
                        hasAlpha: true,
                        isPlanar: false,
                        colorSpaceName: .deviceRGB,
                        bytesPerRow: bytesPerPixel * width,
                        bitsPerPixel: 32
                    )
                    if let outputBitmap = outputBitmap {
                        outputImage.addRepresentation(outputBitmap)
                    }
                }
            }
        }
        
        return outputImage
    }
    
    func applyBlackAndWhiteFilter(to image: NSImage, parallel: Bool) -> NSImage{
        // get a bitmap
        guard let bitmap = NSBitmapImageRep(data: image.tiffRepresentation!) else { return image }
        
        guard let pixelBuffer = bitmap.bitmapData else { return image }
        
        let bytesPerPixel = bitmap.bitsPerPixel / 8
        let width = bitmap.pixelsWide
        let height = bitmap.pixelsHigh
        
        if(parallel){
            DispatchQueue.concurrentPerform(iterations: height) { row in
                for col in 0..<width {
                    let pixelIndex = (row * width + col) * bytesPerPixel
                    
                    // Extract RGB components
                    let red = Double(pixelBuffer[pixelIndex])
                    let green = Double(pixelBuffer[pixelIndex + 1])
                    let blue = Double(pixelBuffer[pixelIndex + 2])
                    
                    // Calculate grayscale value
                    let grayscale = UInt8(0.299 * red + 0.587 * green + 0.114 * blue)
                    
                    // Set all color components to grayscale
                    pixelBuffer[pixelIndex] = grayscale    // Red
                    pixelBuffer[pixelIndex + 1] = grayscale // Green
                    pixelBuffer[pixelIndex + 2] = grayscale // Blue
                    pixelBuffer[pixelIndex + 3] = 255       // Alpha remains the same
                }
            }
        }
        else{
            for row in 0..<height {
                for col in 0..<width {
                    let pixelIndex = (row * width + col) * bytesPerPixel
                    
                    // Extract RGB components
                    let red = Double(pixelBuffer[pixelIndex])
                    let green = Double(pixelBuffer[pixelIndex + 1])
                    let blue = Double(pixelBuffer[pixelIndex + 2])
                    
                    // Calculate grayscale value
                    let grayscale = UInt8(0.299 * red + 0.587 * green + 0.114 * blue)
                    
                    // Set all color components to grayscale
                    pixelBuffer[pixelIndex] = grayscale    // Red
                    pixelBuffer[pixelIndex + 1] = grayscale // Green
                    pixelBuffer[pixelIndex + 2] = grayscale // Blue
                    pixelBuffer[pixelIndex + 3] = 255       // Alpha remains the same
                }
            }
        }
        
        
        
        // Create a new NSImage from the modified bitmap
        let filteredImage = NSImage(size: image.size)
        filteredImage.addRepresentation(bitmap)
        
        return filteredImage
        
    }
}

