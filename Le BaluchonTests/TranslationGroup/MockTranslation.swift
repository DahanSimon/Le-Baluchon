//
//  MockTranslation.swift
//  Le BaluchonTests
//
//  Created by Simon Dahan on 25/01/2021.
//

import Foundation
@testable import Le_Baluchon
class MockTranslationAPI: TranslationAPIProtocol {
    
    var expectedResult: String
    let translationResponse: TranslationResponse?
    var isValid: Bool
    init(expectedResult: String, isValid: Bool) {
        self.expectedResult = expectedResult
        self.isValid = isValid
        self.translationResponse = TranslationResponse(data: TranslationDataClass(translations: [Translation(translatedText: expectedResult)]))
    }
    var sourceLanguage: String?
    let helloTranslationData: Data? = FakeTranslationData.helloTranslationData
    let frDetetctionData: Data? = FakeTranslationData.frDetectionData
    
    func getSourceLanguage(textToTranslate: String, callback: @escaping (Bool, DetectionResponse?) -> Void) {
        guard let frDetectionData = self.frDetetctionData else {
            return
        }
        
        if textToTranslate == "Bonjour" {
            self.sourceLanguage = "fr"
            if let responseJSON = try? JSONDecoder().decode(DetectionResponse.self, from: frDetectionData) {
                callback(true,responseJSON)
            } else {
                callback(false,nil)
            }
        }
    }
    
    
    
    func getTranslation(textToTranslate: String, callback: @escaping (Bool, TranslationResponse?) -> Void) {
        if self.isValid {
            callback(true, self.translationResponse)
        } else {
            callback(false,nil)
        }
        
    }
}
