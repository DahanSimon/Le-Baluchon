//
//  ExchaneResponse.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 27/09/2020.
//

import Foundation


// MARK: - CorrectResponse
struct ConvertionResponse: Codable {
    let success: Bool
    let timestamp: Int
    let base, date: String
    let rates: [String: Double]
}

// MARK: - IncorrectResponse
struct IncorrectResponse: Codable {
    let success: Bool
    let error: Error
}

// MARK: - Error
struct Error: Codable {
    let code: Int
    let type, info: String
}

