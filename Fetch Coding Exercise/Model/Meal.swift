//
//  Meal.swift
//  Fetch Coding Exercise
//
//  Created by Dan Pham on 6/11/24.
//

import Foundation

struct Meals: Decodable {
    var meals: [Meal]
}

struct Meal: Identifiable, Hashable {
    var id: String
    var title: String
    var thumbnailURL: String
}

extension Meal: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case title = "strMeal"
        case thumbnailURL = "strMealThumb"
    }
}

extension Meal: Comparable {
    static func < (lhs: Meal, rhs: Meal) -> Bool {
        lhs.title < rhs.title
    }
}
