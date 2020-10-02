//
//  Currency.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 02/10/2020.
//

import Foundation

struct Currency {
    
    static let share = Currency()
    
    private init() {} 
    static var currenciesData: Data? {
        let bundle = Bundle(for: ConvertionService.self)
        let url = bundle.url(forResource: "CurrenciesData", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
    
    let data = try! JSONDecoder().decode(CurrenciesData.self, from: currenciesData!)
}


// MARK: - CurrenciesDataValue
struct CurrenciesDataValue: Codable {
    let symbol, name, symbolNative: String
    let decimalDigits: Int
    let rounding: Double
    let code, namePlural: String

    enum CodingKeys: String, CodingKey {
        case symbol, name
        case symbolNative = "symbol_native"
        case decimalDigits = "decimal_digits"
        case rounding, code
        case namePlural = "name_plural"
    }
}

typealias CurrenciesData = [String: CurrenciesDataValue]

