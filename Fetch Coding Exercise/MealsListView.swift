//
//  MealsListView.swift
//  Fetch Coding Exercise
//
//  Created by Dan Pham on 6/11/24.
//

import SwiftUI

struct MealsListView: View {
    
    @State private var viewModel = MealsListViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.meals) { meal in
                MealListCellView(meal: meal)
                    .listRowSeparator(.hidden)
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Desserts")
        }
        .task {
            await viewModel.loadMealsData()
        }
    }
}

#Preview {
    MealsListView()
}
