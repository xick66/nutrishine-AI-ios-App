//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
//  AppModel.swift
//  NutriShine AI
//
//  Created by Rahul K M on 19/02/24.
//

import Foundation
import UIKit

class AppModel: ObservableObject {
    private let apiKey = "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"  // Replace with your actual API key
    
    // Function to analyze an image with GPT-4 Vision API
    func analyzeImageWithGPT4Vision(image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.9) else {
            completion(.failure(APIError.imageProcessingError))
            return
        }
        
        let base64Image = imageData.base64EncodedString()
        
        guard let url = URL(string: "https://api.openai.com/v1/completions") else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let requestBody: [String: Any] = [
            "model": "gpt-4-vision-preview",
            "messages": [
                [
                    "role": "user",
                    "content": [
                        ["type": "text", "text": "What’s in this image?"],
                        ["type": "image_url", "image_url": base64Image]
                    ]
                ]
            ],
            "max_tokens": 2000
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? APIError.networkError))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                completion(.failure(APIError.invalidResponse))
                return
            }
            
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let choices = jsonResponse["choices"] as? [[String: Any]],
                   let firstChoice = choices.first,
                   let messageContent = firstChoice["message"] as? [String: Any],
                   let content = messageContent["content"] as? String {
                    completion(.success(content))
                } else {
                    completion(.failure(APIError.invalidResponse))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    // Simulated function for checking a food item
    func checkFoodItem(_ query: String, completion: @escaping (String) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            let response = "Information about \(query)"
            DispatchQueue.main.async {
                completion(response)
            }
        }
    }

    // API Error enumeration
    enum APIError: Error {
        case invalidURL
        case networkError
        case invalidResponse
        case imageProcessingError
    }
}
