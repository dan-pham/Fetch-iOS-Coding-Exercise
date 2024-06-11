//
//  MealListCellView.swift
//  Fetch Coding Exercise
//
//  Created by Dan Pham on 6/11/24.
//

import SwiftUI

struct MealListCellView: View {
    
    let meal: String
    
    var body: some View {
        HStack(spacing: 16) {
            Color.secondary
                .frame(width: 64, height: 64)
                .cornerRadius(12)
            
            Text(meal)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color(uiColor: .lightGray), radius: 2, x: 1, y: 1)
    }
}

#Preview {
    MealListCellView(meal: "Meal 1")
}
