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
    private(set) var meals: [Meal] = []
    private(set) var errorMessage = ""
    
    private let url = URL(string: NetworkManager.TheMealDBEndpoints.dessertCategory.rawValue)
    
    func loadMealsData() async {
        NetworkManager.shared.loadMealData(from: url) { [weak self] (result: Result<Meals, Error>) in
            switch result {
            case .success(let response):
                self?.meals = response.meals.sorted()
                
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
            }
        }
    }
}
