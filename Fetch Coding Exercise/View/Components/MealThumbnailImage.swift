//
//  MealThumbnailImage.swift
//  Fetch Coding Exercise
//
//  Created by Dan Pham on 6/17/24.
//

import SwiftUI

struct MealThumbnailImage: View {
    
    let url: String
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                
            case .failure:
                ImagePlaceholder()
                
            case .empty:
                ProgressView()
                
            @unknown default:
                ImagePlaceholder()
            }
        }
    }
}

struct ImagePlaceholder: View {
    var body: some View {
        Color.gray
    }
}
