//
//  FetchCodingChallengeTests.swift
//  FetchCodingChallengeTests
//
//  Created by Joseph Barbosa on 3/7/24.
//

import XCTest
@testable import FetchCodingChallenge

final class ViewModelTests: XCTestCase {
    var contentViewModel: ContentViewModel!
    var detailViewModel: DessertDetailViewModel!
    var mockAPIManager: MockAPIManager!

    override func setUpWithError() throws {
        mockAPIManager = MockAPIManager()
        contentViewModel = ContentViewModel(apiManager: mockAPIManager)
        detailViewModel = DessertDetailViewModel(apiManager: mockAPIManager)
    }

    // ContentViewModelTests
    
    func testFetchDessertsSuccess() async {
        mockAPIManager.expectedDesserts = [Dessert(id: "1", strMeal: "Test", strMealThumb: "Test.com")]
        await contentViewModel.fetchDesserts()
        
        XCTAssertTrue(contentViewModel.errorMessage.isEmpty)
        XCTAssertFalse(detailViewModel.showAlert)
        XCTAssertFalse(contentViewModel.isLoading)
        XCTAssertTrue(contentViewModel.desserts.count == 1)
        XCTAssertTrue(contentViewModel.desserts.first?.strMeal == "Test")
        XCTAssertTrue(contentViewModel.desserts.first?.strMealThumb == "Test.com")
    }
    
    func testFetchDessertsFailure() async {
        mockAPIManager.fetchDessertsError = APIError.networkCallFailed
        await contentViewModel.fetchDesserts()
        
        XCTAssertTrue(!contentViewModel.errorMessage.isEmpty)
        XCTAssertEqual(contentViewModel.desserts.count, 0)
        XCTAssertTrue(contentViewModel.showAlert)
    }

    // DetailViewModelTests
    
    func testFetchDessertDetailsSuccess() async {
        mockAPIManager.expectedDessertDetail = DessertDetails(id: "TestID", strMeal: "TestName", strInstructions: "TestInstructions", strMealThumb: "TestThumb", ingredients: [Ingredient(name: "TestIG", measurement: "TestMG")])
        await detailViewModel.fetchDessertDetails(for: "TestID")
        
        XCTAssertTrue(detailViewModel.errorMessage.isEmpty)
        XCTAssertFalse(detailViewModel.showAlert)
        XCTAssertNotNil(detailViewModel.dessertDetails)
        XCTAssertTrue(detailViewModel.dessertDetails!.id == "TestID")
        XCTAssertTrue(detailViewModel.dessertDetails!.strMeal == "TestName")
        XCTAssertTrue(detailViewModel.dessertDetails!.strInstructions == "TestInstructions")
    }
    
    func testFetchDessertDetailsFailure() async {
        mockAPIManager.fetchDessertsDetailError = APIError.networkCallFailed
        await detailViewModel.fetchDessertDetails(for: "Test")
        
        XCTAssertTrue(!detailViewModel.errorMessage.isEmpty)
        XCTAssertNil(detailViewModel.dessertDetails)
        XCTAssertTrue(detailViewModel.showAlert)
    }
}

class MockAPIManager: API {
    var expectedDesserts: [Dessert] = []
    var expectedDessertDetail: DessertDetails = DessertDetails(id: "Test", strMeal: "Test", strInstructions: "Test", strMealThumb: "Test", ingredients: [])
    var fetchDessertsError: Error?
    var fetchDessertsDetailError: Error?
    
    func fetchDesserts() async throws -> [Dessert] {
        if let error = fetchDessertsError {
            throw error
        }
        return expectedDesserts
    }
    
    func fetchDessertDetails(for mealId: String) async throws -> DessertDetails {
        if let error = fetchDessertsDetailError {
            throw error
        }
        return expectedDessertDetail
    }
}
