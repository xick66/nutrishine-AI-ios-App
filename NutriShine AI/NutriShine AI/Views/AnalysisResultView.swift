//
//  AnalysisResultView.swift
//  NutriShine AI
//
//  Created by Rahul K M on 19/02/24.
//

// AnalysisResultsView.swift

import SwiftUI

struct AnalysisResultsView: View {
    var image: UIImage?
    @State private var analysisResult: String = ""
    @State private var isLoading: Bool = true
    @ObservedObject var appModel = AppModel() // Assume AppModel has the necessary functionality

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Analyzing...")
            } else {
                Text(analysisResult)
            }
        }
        .onAppear(perform: analyzeImage)
    }

    private func analyzeImage() {
        guard let image = image else {
            analysisResult = "No image to analyze"
            isLoading = false
            return
        }

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
