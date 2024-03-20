//
//  CameraCaptureView.swift
//  NutriShine AI
//
//  Created by Rahul K M on 19/02/24.
//

//import SwiftUI
//
//struct CameraCaptureView: View {
//    @State private var isShowingImagePicker = false
//    @State private var capturedImage: UIImage?
//    @State private var analysisResult: String?
//    @State private var isAnalyzing = false
//    @ObservedObject var appModel = AppModel()
//
//    var body: some View {
//        VStack {
//            if let image = capturedImage {
//                Image(uiImage: image)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(maxWidth: 300, maxHeight: 300)
//            }
//
//            Button("Capture Image") {
//                isShowingImagePicker = true
//            }
//            .padding()
//            .sheet(isPresented: $isShowingImagePicker) {
//                ImagePicker(image: $capturedImage, sourceType: .camera)
//            }
//
//            if isAnalyzing {
//                ProgressView("Analyzing...")
//            } else if let result = analysisResult {
//                Text(result)
//            }
//        }
//        .navigationTitle("Capture and Analyze")
//        .onChange(of: capturedImage) { _ in
//            analyzeCapturedImage()
//        }
//    }
//
//    private func analyzeCapturedImage() {
//        guard let image = capturedImage else { return }
//        isAnalyzing = true
//       
//    }
//}

import SwiftUI
import UIKit

struct CameraCaptureView: View {
    @State private var isShowingImagePicker = false
    @State private var capturedImage: UIImage?
    @State private var analysisResult: String = ""
    @State private var isLoading: Bool = false
    @ObservedObject var appModel: AppModel

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Analyzing...")
            } else {
                if let image = capturedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 300, maxHeight: 300)
                    
                    if !analysisResult.isEmpty {
                        Text(analysisResult)
                            .padding()
                    }
                } else {
                    Text("Tap below to capture or select an image.")
                        .padding()
                }
                
                Button("Capture or Select Image") {
                    isShowingImagePicker = true
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(image: $capturedImage, sourceType: .photoLibrary) { selectedImage in
                guard let selectedImage = selectedImage else { return }
                analyzeImage(image: selectedImage)
            }
        }
        .navigationTitle("Capture and Analyze")
    }

    private func analyzeImage(image: UIImage) {
        isLoading = true
        appModel.analyzeImageWithGPT4Vision(image: image) { result in
            switch result {
            case .success(let response):
                analysisResult = response
            case .failure(let error):
                analysisResult = "Analysis failed: \(error.localizedDescription)"
            }
            isLoading = false
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    var sourceType: UIImagePickerController.SourceType
    var completion: (UIImage?) -> Void

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self, completion: completion)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker
        var completion: (UIImage?) -> Void

        init(_ parent: ImagePicker, completion: @escaping (UIImage?) -> Void) {
            self.parent = parent
            self.completion = completion
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
                completion(image)
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

