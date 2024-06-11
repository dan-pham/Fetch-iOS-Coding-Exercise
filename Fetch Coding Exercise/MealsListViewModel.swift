//
//  MealsListViewModel.swift
//  Fetch Coding Exercise
//
//  Created by Dan Pham on 6/11/24.
//

import Foundation
import Observation

@Observable
final class MealsListViewModel {
    private(set) var meals: [String] = ["Meal 1", "Meal 2", "Meal 3"]
}
