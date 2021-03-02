//
//  TranslationAPIProtocol.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 25/01/2021.
//

import Foundation

protocol TranslationAPIProtocol {
    var sourceLanguage: String? { get }
    var incorrectTranslationResponse: IncorrectTranslationResponse? { get }
    func getTranslation(textToTranslate: String, callback: @escaping (RequestResponse<TranslationResponse>) -> Void)
    func getSourceLanguage(textToTranslate: String, callback: @escaping (Bool, String?) -> Void)
}
