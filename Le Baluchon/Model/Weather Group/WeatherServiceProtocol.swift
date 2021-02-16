//
//  WeatherServiceProtocol.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 17/10/2020.
//

import Foundation

protocol WeatherServiceProtocol {
    func getWeather(for city: String, callback: @escaping (WeatherResponseError?, CityWeatherResponse?) -> Void)
}
