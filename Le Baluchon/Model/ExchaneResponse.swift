//
//  ExchaneResponse.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 27/09/2020.
//

import Foundation


// MARK: - JSON Answer Architcture used quicktype.io to genrate it
struct ConvertionResponse: Codable {
    let success:    Bool
    let query:      Query
    let info:       Info
    let date:       String
    let result:     Double?
}

struct Info: Codable {
    let timestamp:  Int
    let rate:       Double
}

struct Query:       Codable {
    let from, to:   String
    let amount:     Double
}

//// MARK: - IncorrectResponse
//struct IncorrectResponse: Codable {
//    let success: Bool
//    let error: Error
//}
//
//// MARK: - Error
//struct Error: Codable {
//    let code: Int
//    let type, info: String
//}
