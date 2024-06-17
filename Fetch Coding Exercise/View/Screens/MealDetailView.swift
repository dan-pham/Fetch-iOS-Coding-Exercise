//
//  MealDetailView.swift
//  Fetch Coding Exercise
//
//  Created by Dan Pham on 6/17/24.
//

import SwiftUI

struct MealDetailView: View {
    
    let title = "Meal Title"
    let description = "Meal description Meal description Meal description Meal description Meal description Meal description"
    let ingredients: [String] = ["Apples", "Bananas", "Flour", "Water"]
    let instructions: String? = "Instructions instructions"
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Color.gray
                    .frame(height: 300)
                
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(description)
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
                    
                    ForEach(ingredients, id: \.self) { ingredient in
                        Text(ingredient)
                    }
                }
                .padding()
                
                if let instructions = instructions {
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
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MealDetailView()
}
