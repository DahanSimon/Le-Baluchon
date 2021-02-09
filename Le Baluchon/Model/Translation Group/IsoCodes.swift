//
//  IsoCodes.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 01/02/2021.
//

import Foundation

// MARK: - LanguagesCodesValue
struct LanguagesCodesValue: Codable {
    let the6391, the6392, family, name: String
    let nativeName: String
    let wikiURL: String
    let the6392B: String?

    enum CodingKeys: String, CodingKey {
        case the6391 = "639-1"
        case the6392 = "639-2"
        case family, name, nativeName
        case wikiURL = "wikiUrl"
        case the6392B = "639-2/B"
    }
}

typealias LanguagesCodes = [String: LanguagesCodesValue]


