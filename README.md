# ImageFilterApp

**ImageFilterApp** is a simple macOS application written in Swift that applies various filters to images. This project was created as a school assignment and serves as my first application in Swift. 🎉

---

## Features

- **Three Filters**:
  - **Red Filter**: Turns the red component of all pixels to maximum intensity.
  - **Black & White (Grayscale)**: Converts the image to grayscale using luminance-based weighting.
  - **Edge Detection**: Detects edges in the image based on pixel intensity changes.
  
- **Execution Modes**:
  - **Serial Mode**: Processes the image one pixel at a time.
  - **Parallel Mode**: Optimizes processing by splitting tasks across multiple threads.

- **Processing Time Display**: The application displays the processing time for each filter.

- **Cancellable Tasks**: Filter processing is wrapped in a `Task`, allowing users to cancel the operation mid-process by clicking a cancel button.

---

## How It Works

1. **Load an Image**: Start by loading an image into the application.
2. **Choose a Filter**: Select one of the available filters (Red, Black & White, or Edge Detection).
3. **Choose Processing Mode**: Run the filter in **serial** or **parallel** mode marked with **'+'**.
4. **Cancel If Needed**: If the operation is taking too long, cancel it anytime.
5. **View the Results**: The processed image is displayed along with the processing time.

---

## Technologies Used

- **Language**: Swift
- **Concurrency**: Swift's `Task` and `TaskGroup` for parallelism and cancellation support.
- **macOS**: Built using `NSImage` and `NSBitmapImageRep` for image processing.

---

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/kal1nadam/swift-image-editor
   cd ImageFilterApp
   ```
   
2. Open the project in Xcode:
   
   ```bash
   open ImageFilterApp.xcodeproj
   ```

3. Build and run the project

---

## Disclaimer

This project is a **school assignment** and was created as a learning exercise. While functional, it is not optimized for production use. Contributions and suggestions for improvement are welcome!

