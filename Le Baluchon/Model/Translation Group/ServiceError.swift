//
//  ServiceError.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 10/02/2021.
//

import Foundation

enum ServiceError: Swift.Error {
    case undefined
    case translationError
    case noDataReceived
    case sourceLanguageIsEnglish
    var localizedDescription: String {
        switch self {
        case .undefined:
            return "Source language has not been detected"
        case .translationError:
            return "An error occured please try again"
        case .noDataReceived:
            return "An error occured please try again"
        case .sourceLanguageIsEnglish:
            return ""
        }
    }
}

enum RequestResponse {
    case failure(ServiceError)
    case success(TranslationResponse)
}

