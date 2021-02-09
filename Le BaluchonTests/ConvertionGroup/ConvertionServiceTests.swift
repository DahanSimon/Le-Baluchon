//
//  ConvertionServiceTests.swift
//  Le BaluchonTests
//
//  Created by Simon Dahan on 24/01/2021.
//

import XCTest
@testable import Le_Baluchon

class ConvertionServiceTests: XCTestCase {
    
    func testGetConvertionFor1DollarInEuroShouldGetConvertion() {
        // Given
        let amountToConvert = 1
        let euroBasedMock = MockApiConvertion(expectedResult: 0.825866, baseCurrency: "USD", convertToCurrency: "EUR", amountToConvert: amountToConvert, rate: 0.825866, timestamp: Date().timeIntervalSince1970)
        let convertionService = ConvertionService(api: euroBasedMock)
        convertionService.baseCurrency = "EUR"
        // When
        let expectation = XCTestExpectation(description: "Wait for convertion to be done")
        
        var usdBasedRates: ConvertionResponse? = nil
        var result: Double?
        convertionService.convert { (success, convertionResponse) in
            usdBasedRates = convertionResponse
            if let euroRate = usdBasedRates?.rates["EUR"] {
                result = euroRate * Double(amountToConvert)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
        XCTAssertEqual(result, 0.825866)
        XCTAssertNotNil(usdBasedRates)
        XCTAssertTrue(usdBasedRates?.base == "USD")
    }
    
    func testGetConvertionFor1DollarInEuroThreeTimesShouldCallApiOnce() {
        // Given
        let amountToConvert = 1
        let euroBasedMock = MockApiConvertion(expectedResult: 0.825866, baseCurrency: "USD", convertToCurrency: "EUR", amountToConvert: amountToConvert, rate: 0.825866, timestamp: Date().timeIntervalSince1970)
        let convertionService = ConvertionService(api: euroBasedMock)
        convertionService.baseCurrency = "EUR"
        // When
        let expectation = XCTestExpectation(description: "Wait for convertion to be done")
        
        var usdBasedRates: ConvertionResponse? = nil
        var result: Double?
        convertionService.convert { (success, convertionResponse) in
            usdBasedRates = convertionResponse
            if let euroRate = usdBasedRates?.rates["EUR"] {
                result = euroRate * Double(amountToConvert)
            }
            
        }
        
        convertionService.convert { (success, convertionResponse) in
            usdBasedRates = convertionResponse
            if let euroRate = usdBasedRates?.rates["EUR"] {
                result = euroRate * Double(amountToConvert)
            }
            
        }
        
        convertionService.convert { (success, convertionResponse) in
            usdBasedRates = convertionResponse
            if let euroRate = usdBasedRates?.rates["EUR"] {
                result = euroRate * Double(amountToConvert)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
        XCTAssertEqual(euroBasedMock.apiCallCounter, 1)
        XCTAssertEqual(result, 0.825866)
        XCTAssertNotNil(usdBasedRates)
        XCTAssertTrue(usdBasedRates?.base == "USD")
    }
}
