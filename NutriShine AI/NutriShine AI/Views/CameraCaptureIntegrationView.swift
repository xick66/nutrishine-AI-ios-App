//
//  CameraCaptureIntegrationView.swift
//  NutriShine AI
//
//  Created by Rahul K M on 19/02/24.
//

import SwiftUI

struct CameraCaptureIntegrationView: View {
    @State private var isShowingCameraView = false
    @State private var capturedImage: UIImage?
    @ObservedObject var appModel = AppModel()

    var body: some View {
        VStack {
            if let image = capturedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }

            Button("Capture Image") {
                isShowingCameraView = true
            }

            // ... additional UI for showing analysis results
        }
        .sheet(isPresented: $isShowingCameraView) {
            // Conditionally show the CameraView only on iOS
            #if canImport(UIKit)
            CameraView(image: $capturedImage, isPresented: $isShowingCameraView)
            #endif
        }
    }
}

struct CameraCaptureIntegrationView_Previews: PreviewProvider {
    static var previews: some View {
        CameraCaptureIntegrationView()
    }
}
