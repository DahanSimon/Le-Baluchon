//
//  TranslationResponse.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 25/01/2021.
//

import Foundation

// MARK: - TranlationResponse
struct TranslationResponse: Codable {
    let data: TranslationDataClass
}

// MARK: - DataClass
struct TranslationDataClass: Codable {
    let translations: [Translation]
}

// MARK: - Translation
struct Translation: Codable {
    let translatedText: String
}

let a = TranslationResponse(data: TranslationDataClass(translations: [Translation(translatedText: "Hello")]))

