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
        let translationService = TranslationService(api: MockTranslationAPI())
        var translatedText: String?
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
    
        translationService.translate(textToTranslate: "Bonjour") { (sucess, translation) in
            guard let translation = translation else {
                return
            }
            translatedText = translation.data.translations[0].translatedText
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.010)
        XCTAssertEqual(translatedText, "Hello")
    }
}
