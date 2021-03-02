//
//  TranslationService.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 25/01/2021.
//

import Foundation

class TranslationService {
    var sourceLanguage: String?
    let api: TranslationAPIProtocol
    var languageDetectionResponse: DetectionResponse?
    var serviceError: ServiceError?
    var translationErrorMessage: String?
    init(api: TranslationAPIProtocol) {
        self.api = api
    }
    
    func detectAndTranslate(textToTranslate: String, callback: @escaping (Bool, TranslationStruct?) -> Void) {
        
        var languagesCodeData: Data? {
            let bundle = Bundle(for: TranslationService.self)
            let url = bundle.url(forResource: "LanguagesCodesData", withExtension: "json")!
            return try! Data(contentsOf: url)
        }
        
        guard let languagesCodes = try? JSONDecoder().decode(LanguagesCodes.self, from: languagesCodeData!) else {
            return
        }

        var translationStruc = TranslationStruct(textToTranslate: textToTranslate)
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        self.api.getSourceLanguage(textToTranslate: textToTranslate) { (success, detectedLanguageCode)  in
            
            
            if let detectedLanguage = detectedLanguageCode, success {
                translationStruc.sourceLanguage = languagesCodes[detectedLanguage]?.name
            } else if detectedLanguageCode == "und"{
                self.serviceError = ServiceError.undefined
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            if self.serviceError != nil {
                callback(false, nil)
                return
            }
        
            self.api.getTranslation(textToTranslate: textToTranslate) { (requestResponse) in
                
                switch requestResponse {
                case .failure(let serviceError):
                    self.serviceError = serviceError
                    callback(false, nil)
                case .success(let translation):
                    if self.api.sourceLanguage == "en"{
                        translationStruc.translatedText = textToTranslate
                        callback(true,translationStruc)
                    }
                    translationStruc.translatedText = translation.data.translations.first?.translatedText
                    callback(true,translationStruc)
                }
                
            }
        }
    }
}


struct TranslationStruct {
    var textToTranslate: String
    var sourceLanguage: String?
    var translatedText: String?
    var translationErrorMessage: String?
    var detectionError: ServiceError?
    
    init(textToTranslate: String) {
        self.textToTranslate = textToTranslate
    }
}


