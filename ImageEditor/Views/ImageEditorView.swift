import SwiftUI

struct ImageEditorView: View {
    @StateObject private var model = ImageEditorModel()
    
    var body: some View {
        VStack {
            if let image = model.currentImage {
                Image(nsImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 400, maxHeight: 400)
                    .border(Color.gray, width: 1)
            } else {
                Text("No Image Selected")
                    .frame(maxWidth: 400, maxHeight: 400)
                    .border(Color.gray, width: 1)
            }
            
            HStack(alignment: .top, spacing: 20){
                Button("Upload Image") {
                    model.pickImage()
                }
                
                VStack(alignment: .leading) {
                    Button("Red Filter") {
                        model.applyRedFilter()
                    }
                    
                    Button("Red Filter +") {
                        model.applyRedFilter(parallel: true)
                    }
                }
                
                VStack(alignment: .leading) {
                    Button("Edge Detection") {
                        model.applyEdgeDetection()
                    }
                    
                    Button("Edge Detection +") {
                        model.applyEdgeDetection(parallel: true)
                    }
                }
                
                Button("Cancel") {
                    model.resetImage()
                }
            }
            .padding()
            
            if model.processingTime > 0 {
                Text("Processing Time: \(model.processingTime, specifier: "%.2f") seconds")
            }
        }
        .padding()
    }
}

