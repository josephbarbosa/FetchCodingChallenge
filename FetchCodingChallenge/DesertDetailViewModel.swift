//
//  DesertDetailViewModel.swift
//  SwiftUILearningFromUIKit
//
//  Created by Joseph Barbosa on 3/7/24.
//

import Foundation

class DessertDetailViewModel: ObservableObject {
    @Published var dessertDetails: DessertDetails?
    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""
    
    private var apiManager: API
    
    init(apiManager: API = APIManager.shared) {
        self.apiManager = apiManager
    }
    
    @MainActor
    func fetchDessertDetails(for dessert: String) async {
        do {
            let response = try await apiManager.fetchDessertDetails(for: dessert)
            dessertDetails = response
        } catch {
            errorMessage = "There was an error fetching desserts detail API. Please restart app. \n\nError: \(error.localizedDescription)"
            showAlert = true
        }
    }
}
