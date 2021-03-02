//
//  MockTranslation.swift
//  Le BaluchonTests
//
//  Created by Simon Dahan on 25/01/2021.
//

import Foundation
@testable import Le_Baluchon
class MockTranslationAPI: TranslationAPIProtocol {
    var incorrectTranslationResponse: IncorrectTranslationResponse?
    
    var sourceLanguage: String?
    var expectedResult: String?
    let translationResponse: TranslationResponse?
    let detectionResponse: DetectionResponse?
    var isValid: Bool
    init(sourceLanguageExpected: String?, expectedResult: String?, isValid: Bool) {
        self.expectedResult = expectedResult
        self.isValid = isValid
        if let str = expectedResult{
            self.translationResponse = TranslationResponse(data: TranslationDataClass(translations: [Translation(translatedText: str)]))
        } else {
            self.translationResponse = nil
        }
        if let source = sourceLanguageExpected {
            self.detectionResponse = DetectionResponse(data: DetectionDataClass(detections: [[Detection(isReliable: true, confidence: 1, language: source)]]))
        } else {
            self.detectionResponse = nil
        }
        
    }
    
    func getSourceLanguage(textToTranslate: String, callback: @escaping (Bool, String?) -> Void) {
        if self.isValid {
            self.sourceLanguage = self.detectionResponse?.data.detections.first?.first?.language
            callback(true, sourceLanguage)
        } else {
            self.sourceLanguage = self.detectionResponse?.data.detections.first?.first?.language
            callback(false, sourceLanguage)
        }
    }
    
    func getTranslation(textToTranslate: String, callback: @escaping (RequestResponse<TranslationResponse>) -> Void) {
        if let translationResponse = self.translationResponse, self.isValid {
            
            callback(RequestResponse.success(translationResponse))
        } else {
            callback(RequestResponse.failure(ServiceError.translationError))
        }
    }
}
