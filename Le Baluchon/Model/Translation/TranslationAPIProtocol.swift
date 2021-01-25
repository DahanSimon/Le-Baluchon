//
//  TranslationAPIProtocol.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 25/01/2021.
//

import Foundation

protocol TranslationAPIProtocol {
    func getTranslation(textToTranslate: String, callback: @escaping (Bool, TranslationResponse?) -> Void)
}
