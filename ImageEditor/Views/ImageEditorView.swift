import SwiftUI

struct ImageEditorView: View {
    @StateObject private var model = ImageEditorModel()
    
    var body: some View {
        VStack {
            ZStack{
                if let image = model.currentImage {
                    Image(nsImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 400, maxHeight: 400)
                        .border(Color.gray, width: 1)
                        .cornerRadius(4)
                } else {
                    Text("No Image Selected")
                        .frame(maxWidth: 400, maxHeight: 400)
                        .border(Color.gray, width: 1)
                }
                
                // Dim overlay when task is running
                if model.taskIsRunning {
                    Color.black.opacity(0.6)
                        .frame(maxWidth: 400, maxHeight: 400)
                        .cornerRadius(4)
                }
                
                // Cancel button when task is running
                if model.taskIsRunning {
                    Button("Cancel") {
                        model.cancelTask()
                    }
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .shadow(radius: 5)
                }
            }
            
            
            HStack(alignment: .top, spacing: 20){
                Button("Upload Image") {
                    model.pickImage()
                }.background(Color.blue).cornerRadius(3)
                
                VStack(alignment: .leading) {
                    Button("Red Filter") {
                        model.applyRedFilter()
                    }
                    
                    Button("Red Filter +") {
                        model.applyRedFilter(parallel: true)
                    }
                }
                
                VStack(alignment: .leading) {
                    Button("Black & White"){
                        model.applyBlackAndWhiteFilter()
                    }
                    
                    Button("Black & White +"){
                        model.applyBlackAndWhiteFilter(parallel: true)
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
                
                Button("Clear") {
                    model.resetImage()
                }.background(Color.red).cornerRadius(3)
            }
            .padding()
            
            if model.processingTime > 0 {
                Text("Processing Time: \(model.processingTime, specifier: "%.2f") seconds")
            }
        }
        .padding()
        
    }
}

#Preview {
    ImageEditorView()
}
