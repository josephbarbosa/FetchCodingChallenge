//
//  ContentViewModel.swift
//  SwiftUILearningFromUIKit
//
//  Created by Joseph Barbosa on 3/7/24.
//

import Foundation

class ContentViewModel: ObservableObject {
    @Published var desserts: [Dessert] = []
    @Published var isLoading: Bool = true
    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""
    
    private var apiManager: API
    
    init(apiManager: API = APIManager.shared) {
        self.apiManager = apiManager
    }
    
    @MainActor
    func fetchDesserts() async {
        do {
            let response = try await apiManager.fetchDesserts()
            isLoading = false
            desserts = response
        } catch(let error) {
            errorMessage = "There was an error fetching desserts API. Please restart app. \n\nError: \(error.localizedDescription)"
            showAlert = true
        }
    }
}
