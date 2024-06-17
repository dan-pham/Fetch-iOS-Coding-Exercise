//
//  MealDetailView.swift
//  Fetch Coding Exercise
//
//  Created by Dan Pham on 6/17/24.
//

import SwiftUI

struct MealDetailView: View {
    
    @State private var viewModel = MealDetailViewModel()
    
    let mealID: String
    
    init(mealID: String) {
        self.mealID = mealID
    }
    
    var body: some View {
        ScrollView {
            if let meal = viewModel.meal {
                VStack(alignment: .leading) {
                    MealThumbnailImage(url: meal.thumbnailURL)
                        .frame(height: 300)
                        .clipped()
                    
                    HeaderView(meal: meal)
                        .padding()
                    
                    IngredientsView(meal: meal)
                        .padding()
                    
                    if let instructions = meal.instructions {
                        InstructionsView(instructions: instructions)
                            .padding()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                ProgressView()
                    .padding(.top, 200)
                    .frame(maxWidth: .infinity)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadMealDetailData(for: mealID)
        }
    }
}

#Preview {
    MealDetailView(mealID: "52855")
}

private struct HeaderView: View {
    let meal: MealDetail
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(meal.title)
                .font(.title)
                .fontWeight(.bold)
            
            Text(formatDescription(category: meal.category, area: meal.area))
                .font(.headline)
        }
        .padding()
    }
    
    private func formatDescription(category: String?, area: String?) -> String {
        switch (category, area) {
        case let (category?, area?):
            return "\(category) | \(area)"
        case let (category?, _):
            return category
        case let (_, area?):
            return area
        case (.none, .none):
            return ""
        }
    }
}

private struct IngredientsView: View {
    let meal: MealDetail
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.mint)
                
                Text("Ingredients")
                    .bold()
            }
            .font(.title3)
            .padding(.bottom, 8)
            
            ForEach(meal.ingredients, id: \.self) { ingredient in
                Text(ingredient)
            }
        }
    }
}

private struct InstructionsView: View {
    let instructions: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Image(systemName: "list.clipboard.fill")
                    .foregroundStyle(.mint)
                
                Text("Instructions")
                    .bold()
            }
            .font(.title3)
            .padding(.bottom, 8)
            
            Text(instructions)
        }
    }
}
