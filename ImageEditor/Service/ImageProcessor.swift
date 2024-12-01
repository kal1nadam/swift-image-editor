//
//  ImageProcessor.swift
//  ImageEditor
//
//  Created by Adam Kalina on 11/28/24.
//

import AppKit

struct ImageProcessing {
    static func applyRedFilter(to image: NSImage) -> NSImage {
        // get a bitmap
        guard let bitmap = NSBitmapImageRep(data: image.tiffRepresentation!) else { return image }
        
        guard let pixelBuffer = bitmap.bitmapData else { return image }
        
        let bytesPerPixel = bitmap.bitsPerPixel / 8
        let pixelsWide = bitmap.pixelsWide
        let pixelsHigh = bitmap.pixelsHigh
        
        for row in 0..<pixelsHigh {
            for col in 0..<pixelsWide {
                
                let pixelIndex = (row * pixelsWide + col) * bytesPerPixel
                                
                // Modify the red component
                pixelBuffer[pixelIndex] = 255
            }
        }
        
        // Create a new NSImage from the modified bitmap
        let filteredImage = NSImage(size: image.size)
        filteredImage.addRepresentation(bitmap)
        
        print("Applied red filter")
        return filteredImage
    }
}

