//
//  WeatherService.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 30/09/2020.
//

import Foundation

class WeatherService {
    
    var error: WeatherApiErrors?
    var weatherResponse: CityWeatherResponse?
    var weatherResponseError: WeatherResponseError?
    var weatherComparaison: [CityType: Any?] = [:]
    private var weatherSession = URLSession(configuration: .default)
        
    private var task: URLSessionDataTask?
        
    private func execute(request: URLRequest, callback: @escaping (WeatherResponseError?, CityWeatherResponse?) -> Void) {
        task = weatherSession.dataTask(with: request) { /*[weak self]*/ (data, response, error) in
            DispatchQueue.main.async {
                
//                guard let self = self else { return }
                
                guard let data = data, error == nil else {
                    callback(nil, nil)
                    return
                }

                guard let response = response as? HTTPURLResponse, response.statusCode == 200 || response.statusCode == 404 else {
                    callback(nil, nil)
                    return
                }
                
                if response.statusCode == 200 {
                    if let responseJSON = try? JSONDecoder().decode(CityWeatherResponse.self, from: data) {
                        self.weatherResponse = responseJSON
                        callback(nil, self.weatherResponse)
                    }
                } else {
                    if let responseJSON = try? JSONDecoder().decode(WeatherResponseError.self, from: data) {
                        self.error = WeatherApiErrors.apiError(weatherResponseError: responseJSON)
                        self.weatherResponseError = responseJSON
                        callback(self.weatherResponseError, nil)
                    }
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
    
    func getWeatherComparaison(between origin: String, and destination: String) {
        
        let dispatchGroup = DispatchGroup()
        
        DispatchQueue.main.async {
            dispatchGroup.enter()
            self.getWeather(for: origin) { [self] (responseError, response) in
                    if responseError == nil {
                        weatherComparaison[.origin] = response
                    } else {
                        weatherComparaison[.origin] = responseError
                    }
                    dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            self.getWeather(for: destination) { [self] (responseError, response) in
                    if response != nil {
                        weatherComparaison[.destination] = response
                        
                    } else {
                        weatherComparaison[.destination] = responseError
                    }
                    dispatchGroup.leave()
            }
            
            dispatchGroup.notify(queue: .main) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didReceiveData"), object: nil)
            }
        }
    }
    
}

extension WeatherService: WeatherServiceProtocol {
    
    func getWeather(for city: String, callback: @escaping (WeatherResponseError?, CityWeatherResponse?) -> Void) {
        guard let cityNameUrlFriendly = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            self.error = .notUrlFriendly(message: "Le nom de ville que vous avez entrer est incorrect")
            return
        }
        
        let weatherUrl = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityNameUrlFriendly)&appid=be119e6e4c0a0f05303ec9a30132499e&units=metric&lang=fr")!
        let request = createConvertionRequest(url: weatherUrl)
        
        execute(request: request, callback: callback)
    }
}

enum WeatherApiErrors {
    case apiError(weatherResponseError: WeatherResponseError)
    case notUrlFriendly(message: String)
}

enum CityType {
    case origin
    case destination
}
