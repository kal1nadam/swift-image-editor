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
            
            HStack {
                Button("Upload Image") {
                    model.pickImage()
                }
                
                Button("Red Filter") {
                    model.applyRedFilter()
                }
                
                Button("Cancel") {
                    model.resetImage()
                }
            }
            .padding()
        }
        .padding()
    }
}
