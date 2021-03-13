//
//  WeatherServiceTests.swift
//  Le BaluchonTests
//
//  Created by Simon Dahan on 17/10/2020.
//

import XCTest
@testable import Le_Baluchon

class WeatherServiceTests: XCTestCase {
    
    func testGetWeatherForParisShouldGetParisWeather() {
        // Given
        let weatherService = WeatherService(weatherSession: URLSessionFake(originData: FakeWeatherData.parisWeatherData, destinationData: FakeWeatherData.newYorkWeatherData, response: FakeWeatherData.responseOK, error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
    
        var parisWeather: CityWeatherResponse? = nil
        weatherService.getWeather(for: "Paris") { (error, response) in
            if let weatherResponse = response {
                parisWeather = weatherResponse
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
        //Then
        XCTAssertNotNil(parisWeather)
        XCTAssertEqual(parisWeather?.name, "Paris")
    }
    
    func testGetWeatherComparaisonBetweenParisAndNYShouldGetWeatherComparaison() {
        // Given
        let weatherService = WeatherService(weatherSession: URLSessionFake(originData: FakeWeatherData.parisWeatherData, destinationData: FakeWeatherData.newYorkWeatherData, response: FakeWeatherData.responseOK, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        var result: [CityType: Any?] = [:]
        weatherService.getWeatherComparaison(between: "Paris", and: "New York") { weatherComparaison in
            result = weatherComparaison
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
        //Then
        XCTAssertNotNil(result[.origin] as? CityWeatherResponse)
        XCTAssertNotNil(result[.destination] as? CityWeatherResponse)
        let originWeather = result[.origin] as? CityWeatherResponse
        let destinationWeather = result[.destination] as? CityWeatherResponse
        XCTAssertEqual(originWeather?.name, "Paris")
        XCTAssertEqual(destinationWeather?.name, "New York")
    }
    
    func testGetWeatherForUnknownCityShouldGetError() {
        // Given
        let weatherService = WeatherService(weatherSession: URLSessionFake(originData: FakeWeatherData.weatherIncorrectData, destinationData: FakeWeatherData.weatherIncorrectData, response: FakeWeatherData.responseKO, error: FakeWeatherData.weatherIncorrectData))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        var weatherError: WeatherResponseError?
        weatherService.getWeather(for: "gfdh") { (error, response) in
            weatherError = weatherService.weatherResponseError
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
        //Then
        XCTAssertNotNil(weatherError)
    }
    
    func testGetWeatherComparaisonForUnknownCitiesShouldGetError() {
        // Given
        let weatherService = WeatherService(weatherSession: URLSessionFake(originData: FakeWeatherData.weatherIncorrectData, destinationData: FakeWeatherData.weatherIncorrectData, response: FakeWeatherData.responseKO, error: FakeWeatherData.weatherIncorrectData))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        var result: [CityType: Any?] = [:]
        weatherService.getWeatherComparaison(between: "hgs.@/dfh", and: "hgdsh") { weatherComparaison in
            result = weatherComparaison
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
        //Then
        XCTAssertNotNil(result[.origin] as? WeatherResponseError)
        XCTAssertNotNil(result[.destination] as? WeatherResponseError)
    }
}
