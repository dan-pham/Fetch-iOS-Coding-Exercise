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
                    
                    VStack(alignment: .leading) {
                        Text(meal.title)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text(meal.category ?? "Miscellaneous")
                            .font(.headline)
                    }
                    .padding()
                    
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
                    .padding()
                    
                    if let instructions = meal.instructions {
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
                        .padding()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
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
