//
//  MockTranslation.swift
//  Le BaluchonTests
//
//  Created by Simon Dahan on 25/01/2021.
//

import Foundation
@testable import Le_Baluchon
class MockTranslationAPI: TranslationAPIProtocol {
    let helloTranslationData: Data? = FakeTranslationData.helloTranslationData
    
    func getTranslation(textToTranslate: String, callback: @escaping (Bool, TranslationResponse?) -> Void) {
        
        guard let helloTranslationData = self.helloTranslationData else {
            callback(false,nil)
            return
        }
        
        if textToTranslate == "Bonjour" {
            if let responseJSON = try? JSONDecoder().decode(TranslationResponse.self, from: helloTranslationData) {
                callback(true,responseJSON)
            } else {
                callback(false,nil)
            }
        }
    }
}
