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
    init(api: TranslationAPIProtocol) {
        self.api = api
    }
    
    func detectAndTranslate(textToTranslate: String, callback: @escaping (Bool, TranslationStruct?) -> Void) {
        var translationStruc = TranslationStruct()
        translationStruc.textToTransalte = textToTranslate
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        self.api.getSourceLanguage(textToTranslate: textToTranslate) { (success, detectionResponse) in
            if let detection = detectionResponse {
                translationStruc.sourceLanguage = detection.data.detections[0][0].language
                dispatchGroup.enter()
                self.api.getTranslation(textToTranslate: textToTranslate) { (success, response) in
                    if let translation = response {
                        translationStruc.translatedText = translation.data.translations[0].translatedText
                    }
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            callback(true,translationStruc)
        }
    }
}


struct TranslationStruct {
    var textToTransalte: String?
    var sourceLanguage: String?
    var translatedText: String?
}
