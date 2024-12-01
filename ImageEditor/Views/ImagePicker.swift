//
//  ImagePicker.swift
//  ImageEditor
//
//  Created by Adam Kalina on 11/28/24.
//

import SwiftUI
import AppKit

struct ImagePicker {
    static func pickImage(completion: @escaping (NSImage?) -> Void) {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.image]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.begin { response in
            if response == .OK, let url = panel.url {
                completion(NSImage(contentsOf: url))
            } else {
                completion(nil)
            }
        }
    }
}

