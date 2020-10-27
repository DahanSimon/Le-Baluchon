//
//  MockWeatherService.swift
//  Le BaluchonTests
//
//  Created by Simon Dahan on 17/10/2020.
//

import Foundation
@testable import Le_Baluchon

class MockWeatherService {
    let bundle = Bundle(for: WeatherServiceTests.self)
    let invalidUrl: URL
    let validUrl: URL
    let validData: Data
    let invalidData: Data
    var validWeatherResponse: CityWeatherResponse?
    var invalidWeatherResponse: WeatherResponseError?
    var isValid: Bool
    
    init(isValid: Bool) {
        invalidUrl = bundle.url(forResource: "WeatherDataError", withExtension: "json")!
        invalidData = try! Data(contentsOf: invalidUrl)
        validUrl = bundle.url(forResource: "ValidWeatherData", withExtension: "json")!
        validData = try! Data(contentsOf: validUrl)
        
        self.isValid = isValid
        
        guard let validResponseJSON = try? JSONDecoder().decode(CityWeatherResponse.self, from: validData) else {
            validWeatherResponse = nil
            return
        }
        
        guard let invalidResponseJSON = try? JSONDecoder().decode(WeatherResponseError.self, from: invalidData) else {
            invalidWeatherResponse = nil
            return
        }
        
        if isValid {
            validWeatherResponse = validResponseJSON
            invalidWeatherResponse = nil
        } else {
            validWeatherResponse = nil
            invalidWeatherResponse = invalidResponseJSON
        }
    }
}

extension MockWeatherService: WeatherServiceProtocol {
    func getWeather(for city: String, callback: @escaping (WeatherResponseError?, CityWeatherResponse?) -> Void) {
        if isValid {
            callback(nil, validWeatherResponse)
        } else {
            callback(invalidWeatherResponse, nil)
        }
    }
}
