//
//  FoodQueryView.swift
//  NutriShine AI
//
//  Created by Rahul K M on 19/02/24.
//

import SwiftUI

struct FoodQueryView: View {
    @State private var foodQuery: String = ""
    @State private var result: String = ""
    @State private var isChecking: Bool = false
    @ObservedObject var appModel: AppModel  // ObservableObject instance of AppModel

    // Initializer accepting AppModel instance
    init(appModel: AppModel) {
        self.appModel = appModel
    }

    var body: some View {
        VStack(spacing: 20) {
            TextField("Enter food item", text: $foodQuery)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            if isChecking {
                ProgressView()
            } else {
                Button("Check") {
                    checkFoodItem()
                }
                .padding()
                .disabled(foodQuery.isEmpty)
                .background(foodQuery.isEmpty ? Color.gray : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }

            Text(result)
                .padding()
        }
        .navigationTitle("Food Query")
    }

    private func checkFoodItem() {
        isChecking = true
        appModel.checkFoodItem(foodQuery) { response in
            self.result = response
            self.isChecking = false
        }
    }
}

struct FoodQueryView_Previews: PreviewProvider {
    static var previews: some View {
        FoodQueryView(appModel: AppModel())
    }
}


