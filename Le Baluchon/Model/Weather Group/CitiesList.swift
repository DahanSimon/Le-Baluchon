//
//  CityList.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 04/10/2020.
//

import Foundation

class CitiesList {
    
    static let shareCitiesList = CitiesList()
    
    private init() {}

    static var citiesListData: Data? {
        let bundle = Bundle(for: WeatherService.self)
        let url = bundle.url(forResource: "world-cities_json", withExtension: "json")!
        return try! Data(contentsOf: url)
    }

    let data = try! JSONDecoder().decode(CitiesListData.self, from: citiesListData!)
}

// MARK: - CitiesListElement
struct CitiesListElement: Codable {
    let country: String
    let geonameid: Int
    let name: String
    let subcountry: String?
}

typealias CitiesListData = [CitiesListElement]

