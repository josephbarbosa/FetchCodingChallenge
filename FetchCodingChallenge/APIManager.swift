//
//  NetworkManager.swift
//  SwiftUILearningFromUIKit
//
//  Created by Joseph Barbosa on 3/6/24.
//

import Foundation

protocol API {
    func fetchDesserts() async throws -> [Dessert]
    func fetchDessertDetails(for mealId: String) async throws -> DessertDetails
}

enum APIError: Error {
    case invalidEndpointURL
    case networkCallFailed
    case decodingError
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

struct DessertMealResponse: Decodable {
    let meals: [Dessert]
}

struct Dessert: Identifiable, Decodable {
    let id: String
    let strMeal: String
    let strMealThumb: String
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case strMeal
        case strMealThumb
    }
}

struct Ingredient: Codable, Hashable {
    let name: String
    let measurement: String
}

struct DessertDetailsMealResponse: Decodable {
    let meals: [DessertDetails]
}

struct DessertDetails: Decodable {
    let id: String
    let strMeal: String
    let strInstructions: String
    let strMealThumb: String
    let ingredients: [Ingredient]
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case strMeal
        case strInstructions
        case strMealThumb
        case strIngredient1
        case strIngredient2
        case strIngredient3
        case strIngredient4
        case strIngredient5
        case strIngredient6
        case strIngredient7
        case strIgredient8
        case strIngredient9
        case strIngredient10
        case strIngredient11
        case strIngredient12
        case strIngredient13
        case strIngredient14
        case strIngredient15
        case strIngredient16
        case strIngredient17
        case strIngredient18
        case strIngredient19
        case strIngredient20
        case strMeasure1
        case strMeasure2
        case strMeasure3
        case strMeasure4
        case strMeasure5
        case strMeasure6
        case strMeasure7
        case strMeasure8
        case strMeasure9
        case strMeasure10
        case strMeasure11
        case strMeasure12
        case strMeasure13
        case strMeasure14
        case strMeasure15
        case strMeasure16
        case strMeasure17
        case strMeasure18
        case strMeasure19
        case strMeasure20
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        strMeal = try container.decode(String.self, forKey: .strMeal)
        strInstructions = try container.decode(String.self, forKey: .strInstructions)
        strMealThumb = try container.decode(String.self, forKey: .strMealThumb)
        
        ingredients = (1...20).compactMap { index in
            let ingredientKey = DessertDetails.CodingKeys(rawValue: "strIngredient\(index)")
            let measureKey = DessertDetails.CodingKeys(rawValue: "strMeasure\(index)")
            
            guard let iKey = ingredientKey, let mKey = measureKey else {
                return nil
            }
            guard let ingredient = try? container.decodeIfPresent(String.self, forKey: iKey), let measure = try? container.decode(String.self, forKey: mKey) else {
                return nil
            }
            
            guard !ingredient.isEmpty && !measure.isEmpty else { return nil }
            return Ingredient(name: ingredient, measurement: measure)
        }
    }
    
    // Unit testing purposes
    init(id: String, strMeal: String, strInstructions: String, strMealThumb: String, ingredients: [Ingredient]) {
        self.id = id
        self.strMeal = strMeal
        self.strInstructions = strInstructions
        self.strMealThumb = strMealThumb
        self.ingredients = ingredients
    }
}

final class APIManager: API {
    static let shared = APIManager()
    
    private static let dessertBaseURL: String = "https://themealdb.com/api/json/v1/1/filter.php"
    private static let dessertDetailsBaseURL: String = "https://themealdb.com/api/json/v1/1/lookup.php"
    
    func fetchDesserts() async throws -> [Dessert] {
        guard var urlComponents = URLComponents(string: APIManager.dessertBaseURL)
        else {
            throw APIError.invalidEndpointURL
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "c", value: "Dessert")
        ]
        
        guard let url = urlComponents.url else {
            throw APIError.invalidEndpointURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw APIError.networkCallFailed
        }
        
        guard let mealsResponse = try? JSONDecoder().decode(DessertMealResponse.self, from: data) else {
            throw APIError.decodingError
        }
        
        return mealsResponse.meals.sorted { $0.strMeal < $1.strMeal }
    }
    
    func fetchDessertDetails(for mealId: String) async throws -> DessertDetails {
        guard var urlComponents = URLComponents(string: APIManager.dessertDetailsBaseURL)
        else {
            throw APIError.invalidEndpointURL
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "i", value: mealId)
        ]
        
        guard let url = urlComponents.url else {
            throw APIError.invalidEndpointURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw APIError.networkCallFailed
        }
        
        let mealResponse = try JSONDecoder().decode(DessertDetailsMealResponse.self, from: data)
        guard let details = mealResponse.meals.first else {
            throw APIError.decodingError
        }
        
        return details
    }
}
