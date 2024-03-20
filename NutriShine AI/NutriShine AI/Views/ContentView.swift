//
//  ContentView.swift
//  NutriShine AI
//
//  Created by Rahul K M on 19/02/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var appModel = AppModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                NavigationLink(destination: UploadDocumentsView()) {
                    Text("Upload Medical Documents")
                        .foregroundColor(.white)
                        .frame(width: 280, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }

                NavigationLink(destination: FoodQueryView(appModel: appModel)) {
                    Text("Check Food")
                        .foregroundColor(.white)
                        .frame(width: 280, height: 50)
                        .background(Color.green)
                        .cornerRadius(10)
                }

                NavigationLink(destination: CameraCaptureView(appModel: appModel)) {
                    Text("Capture or Upload Food Image")
                        .foregroundColor(.white)
                        .frame(width: 280, height: 50)
                        .background(Color.orange)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("NutriShine")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
