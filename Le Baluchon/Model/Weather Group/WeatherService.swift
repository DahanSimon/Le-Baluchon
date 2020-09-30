//
//  WeatherService.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 30/09/2020.
//

import Foundation

class WeatherService {
    
    //static var shared = WeatherService()
    //private init() {}
    
    var weatherResponse: CityWeatherResponse?
    
    private var weatherSession = URLSession(configuration: .default)
        
    private var task: URLSessionDataTask?
    
    
    init (exchangeSession: URLSession) {
        self.weatherSession = exchangeSession
    }
    
    func getWeather(for city: String, callback: @escaping (Bool, CityWeatherResponse?) -> Void) {
        let weatherUrl = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=be119e6e4c0a0f05303ec9a30132499e&units=metric")!
        let request = createConvertionRequest(url: weatherUrl)
        task?.cancel()
        
        task = weatherSession.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }
                
                if let responseJSON = try? JSONDecoder().decode(CityWeatherResponse.self, from: data) {
                    self.weatherResponse = responseJSON
                    callback(true, self.weatherResponse)
                }
            }
        }
        
        task?.resume()
        
    }
    
    private func createConvertionRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let body = ""
        request.httpBody = body.data(using: .utf8)
        return request
    }
    
}
