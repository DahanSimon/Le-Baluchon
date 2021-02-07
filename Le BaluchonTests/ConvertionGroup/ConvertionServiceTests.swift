//
//  ConvertionServiceTests.swift
//  Le BaluchonTests
//
//  Created by Simon Dahan on 24/01/2021.
//

import XCTest
@testable import Le_Baluchon

class ConvertionServiceTests: XCTestCase {

    func testGetConvertionReponseForEuroShouldGetEuroBasedRates() {
        // Given
        let euroBasedMock = MockApiConvertion(baseCurrency: "EUR")
        let convertionService = ConvertionService(api: euroBasedMock)
        convertionService.baseCurrency = "EUR"
        // When
        let expectation = XCTestExpectation(description: "Wait for convertion to be done")
    
        var euroBasedRates: ConvertionResponse? = nil
        
        convertionService.convert { (success, convertionResponse) in
            euroBasedRates = convertionResponse
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
        XCTAssertNotNil(euroBasedRates)
        XCTAssertTrue(euroBasedRates?.base == "EUR")
    }
    
    func testGetConvertionReponseForUSDShouldGetUSDBasedRates() {
        // Given
        let usdBasedMock = MockApiConvertion(baseCurrency: "USD")
        let convertionService = ConvertionService(api: usdBasedMock)
        convertionService.baseCurrency = "USD"
        // When
        let expectation = XCTestExpectation(description: "Wait for convertion to be done")
    
        var usdBasedRates: ConvertionResponse? = nil
        convertionService.convert { (success, convertionResponse) in
            usdBasedRates = convertionResponse
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
        XCTAssertNotNil(usdBasedRates)
        XCTAssertTrue(usdBasedRates?.base == "USD")
    }
}
