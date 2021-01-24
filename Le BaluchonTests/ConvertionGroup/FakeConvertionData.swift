//
//  FakeConvertionData.swift
//  Le BaluchonTests
//
//  Created by Simon Dahan on 24/01/2021.
//

import Foundation

class FakeConvertionData {
    // MARK: - Data
    static var euroBasedConvertionData: Data? {
        let bundle = Bundle(for: FakeConvertionData.self)
        let url = bundle.url(forResource: "EuroBasedConvertionData", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
    
    static var usdBasedConvertionData: Data? {
        let bundle = Bundle(for: FakeConvertionData.self)
        let url = bundle.url(forResource: "UsdBasedConvertionData", withExtension: "json")!
        return try! Data(contentsOf: url)
    }

    
    // MARK: - Response
    static let responseOK = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 200, httpVersion: nil, headerFields: nil)!

    static let responseKO = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 201, httpVersion: nil, headerFields: nil)!
}
