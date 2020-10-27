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
        let weatherService = MockWeatherService(isValid: true)

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        weatherService.getWeather(for: "Paris") { (success, weather) in
            // Then
            XCTAssertNil(success)
            XCTAssertNotNil(weather)
            XCTAssertNil(weatherService.invalidWeatherResponse)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetWeatherForRandomStringShouldPostFailedCallback() {
        // Given
        let weatherService = MockWeatherService(isValid: false)

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        weatherService.getWeather(for: "hvbdkvbsl") { (success, weather) in
            // Then
            XCTAssertNotNil(success)
            XCTAssertNil(weather)
            XCTAssertNotNil(weatherService.invalidWeatherResponse)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }
}
