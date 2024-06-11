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
                VStack {
                    HStack(spacing: 16) {
                        Color.secondary
                            .frame(width: 64, height: 64)
                            .cornerRadius(12)
                        
                        Text(meal)
                            .fontWeight(.bold)
                    }
                }
                .padding(12)
            }
            .navigationTitle("Desserts")
        }
    }
}

#Preview {
    MealsListView()
}
