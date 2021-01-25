//
//  TranslationService.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 25/01/2021.
//

import Foundation

class TranslationService {
    let api: TranslationAPIProtocol
    
    init(api: TranslationAPIProtocol) {
        self.api = api
    }
    
    func translate(callback: @escaping (Bool, TranslationResponse?) -> Void) {
        api.getTranslation { (success, response) in
            if let translation = response {
                print(translation.data.translations)
                callback(true, translation)
            }
        }
    }
    
}
