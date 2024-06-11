//
//  MealsListView.swift
//  Fetch Coding Exercise
//
//  Created by Dan Pham on 6/11/24.
//

import SwiftUI

struct MealsListView: View {
    
    let meals: [String] = ["Meal 1", "Meal 2", "Meal 3"]
    
    var body: some View {
        NavigationStack {
            List(meals, id: \.self) { meal in
                MealListCellView(meal: meal)
                    .listRowSeparator(.hidden)
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Desserts")
        }
    }
}

#Preview {
    MealsListView()
}
