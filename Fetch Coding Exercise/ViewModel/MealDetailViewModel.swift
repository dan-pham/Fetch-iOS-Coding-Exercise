//
//  MealDetailViewModel.swift
//  Fetch Coding Exercise
//
//  Created by Dan Pham on 6/17/24.
//

import Foundation
import Observation

@Observable
final class MealDetailViewModel {
    private(set) var meal: MealDetail? = nil
    private(set) var errorMessage = ""
    var showingAlert = false
    
    func loadMealDetailData(for id: String) async {
        let url = URL(string: NetworkManager.TheMealDBEndpoints.fetchMealDetail.rawValue + id)
        
        NetworkManager.shared.loadMealData(from: url) { [weak self] (result: Result<MealsDetail, Error>) in
            switch result {
            case .success(let response):
                self?.meal = response.meals.first
                
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
                self?.showingAlert = true
            }
        }
    }
}
