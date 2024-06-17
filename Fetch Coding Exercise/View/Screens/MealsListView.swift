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

private struct MealListCellView: View {
    
    let meal: Meal
    
    var body: some View {
        HStack(spacing: 16) {
            MealThumbnailImage(url: meal.thumbnailURL)
                .frame(width: 64, height: 64)
                .cornerRadius(12)
            
            Text(meal.title)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color(uiColor: .lightGray), radius: 2, x: 1, y: 1)
    }
}
