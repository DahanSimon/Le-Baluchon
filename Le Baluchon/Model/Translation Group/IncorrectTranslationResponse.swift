//
//  IncorrectDetectionResponse.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 09/02/2021.
//

import Foundation

// MARK: - IncorrectTranslationResponse
struct IncorrectTranslationResponse: Codable {
    let error: IncorrectTranslationResponseError
}

// MARK: - IncorrectTranslationResponseError
struct IncorrectTranslationResponseError: Codable {
    let code: Int
    let message: String
    let errors: [ErrorElement]
}

// MARK: - ErrorElement
struct ErrorElement: Codable {
    let message, domain, reason: String
}

