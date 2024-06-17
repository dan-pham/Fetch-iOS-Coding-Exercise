//
//  MealDetail.swift
//  Fetch Coding Exercise
//
//  Created by Dan Pham on 6/17/24.
//

import Foundation

struct MealsDetail: Decodable {
    var meals: [MealDetail]
}

struct MealDetail {
    let id: String
    let title: String
    let category: String?
    let area: String?
    let instructions: String?
    let thumbnailURL: String
    
    let ingredients: [String]
}

extension MealDetail: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case title = "strMeal"
        case category = "strCategory"
        case area = "strArea"
        case instructions = "strInstructions"
        case thumbnailURL = "strMealThumb"
        
        case strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5,
             strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10,
             strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15,
             strIngredient16, strIngredient17, strIngredient18, strIngredient19, strIngredient20
        
        case strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5,
             strMeasure6, strMeasure7, strMeasure8, strMeasure9, strMeasure10,
             strMeasure11, strMeasure12, strMeasure13, strMeasure14, strMeasure15,
             strMeasure16, strMeasure17, strMeasure18, strMeasure19, strMeasure20
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        category = try container.decode(String.self, forKey: .category)
        area = try container.decode(String.self, forKey: .area)
        instructions = try container.decode(String.self, forKey: .instructions)
        thumbnailURL = try container.decode(String.self, forKey: .thumbnailURL)
        
        var composedIngredients: [String] = []
        for index in 1...20 {
            if let measurementKey = CodingKeys(stringValue: "strMeasure\(index)"),
               let ingredientKey = CodingKeys(stringValue: "strIngredient\(index)"),
               let measurement = try container.decodeIfPresent(String.self, forKey: measurementKey),
               let ingredient = try container.decodeIfPresent(String.self, forKey: ingredientKey) {
                let composedIngredient = "\(measurement.trimmingCharacters(in: .whitespacesAndNewlines)) \(ingredient.trimmingCharacters(in: .whitespacesAndNewlines).lowercased())"
                if !composedIngredient.trimmingCharacters(in: .whitespaces).isEmpty && !composedIngredients.contains(composedIngredient) {
                    composedIngredients.append(composedIngredient)
                }
            }
        }
        
        ingredients = composedIngredients.map { "• \($0)" }
    }
}
