//
//  FakeWeatherData.swift
//  Le BaluchonTests
//
//  Created by Simon Dahan on 27/10/2020.
//

import Foundation


class FakeWeatherData {
    // MARK: - Data
    static var parisWeatherData: Data? {
        let bundle = Bundle(for: FakeWeatherData.self)
        let url = bundle.url(forResource: "ParisWeatherData", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
    
    static var newYorkWeatherData: Data? {
        let bundle = Bundle(for: FakeWeatherData.self)
        let url = bundle.url(forResource: "NewYorkWeatherData", withExtension: "json")!
        return try! Data(contentsOf: url)
    }

    static var weatherIncorrectData: Data? {
        let bundle = Bundle(for: FakeWeatherData.self)
        let url = bundle.url(forResource: "WeatherDataError", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
    
    // MARK: - Response
    static let responseOK = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 200, httpVersion: nil, headerFields: nil)!

    static let responseKO = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 404, httpVersion: nil, headerFields: nil)!
}
