//
//  TranslationService.swift
//  Le BaluchonTests
//
//  Created by Simon Dahan on 25/01/2021.
//

import XCTest
@testable import Le_Baluchon

class TranslationServiceTests: XCTestCase {
    
    func testGetTranslationForBonjourShouldGetHello() {
        // Given
        let translationService = TranslationService(api: MockTranslationAPI(sourceLanguageExpected: "fr", expectedResult: "Hello", isValid: true))
        var translatedText: String?
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
    
        translationService.detectAndTranslate(textToTranslate: "Bonjour") { (success, translation) in
            guard let translation = translation else {
                return
            }
            translatedText = translation.translatedText
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.010)
        XCTAssertEqual(translatedText, "Hello")
    }
    
    func testGetDetectionForUndifinedWordsShouldGetError() {
        // Given
        let translationService = TranslationService(api: MockTranslationAPI(sourceLanguageExpected: "und", expectedResult: "gfysdugf", isValid: false))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
    
        translationService.detectAndTranslate(textToTranslate: "gfysdugf") { (success, translation) in
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.010)
        XCTAssertEqual(translationService.detectionError, ServiceError.undefined)
    }
    
    func testGetTranslationForHelloSHouldGetHello() {
        // Given
        let translationService = TranslationService(api: MockTranslationAPI(sourceLanguageExpected: "en", expectedResult: "Hello", isValid: true))
        var translatedText: String?
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
    
        translationService.detectAndTranslate(textToTranslate: "Hello") { (success, translation) in
            guard let translation = translation else {
                return
            }
            translatedText = translation.translatedText
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.010)
        XCTAssertEqual(translatedText, "Hello")
    }
    
}
