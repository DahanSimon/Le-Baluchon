//
//  ExchangeService.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 25/09/2020.
//

import Foundation

class ConvertionService {
    
    static var shared = ConvertionService()
    private init() {}
    
    var convertionResponse: ConvertionResponse?
    
    private var convertionSession = URLSession(configuration: .default)
    
    var lastUpdatedRateDate: Int?
    var currentTimestamp: Int {
        return getcurrentTimestamp()
    }
    
    private var convertionUrl: URL {
        let url = URL(string: "https://data.fixer.io/api/latest" + "?access_key=07bb16458b377a95361d648e74daed7f&base=EUR&symbols=usd")!
        return url
    }
    
    private var task: URLSessionDataTask?
    
    var convertionError: ConvertionErrors? = nil
    
    init (exchangeSession: URLSession) {
        self.convertionSession = exchangeSession
    }
    
    func getConvertion(callback: @escaping (Bool, ConvertionResponse?) -> Void) {
        let request = createConvertionRequest()
        task?.cancel()
        
        // Checks if we need to call the API
        if lastUpdatedRateDate ?? 0 <= currentTimestamp - 3600 {
            task = convertionSession.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    guard let data = data, error == nil else {
                        callback(false, nil)
                        self.convertionError = .noDataReceived
                        return
                    }
                    
                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        callback(false, nil)
                        self.convertionError = .responseCodeIsNot200
                        return
                    }
                    
                    if let responseJSON = try? JSONDecoder().decode(ConvertionResponse.self, from: data) {
                        self.convertionResponse = responseJSON
                        self.lastUpdatedRateDate = self.convertionResponse!.timestamp
                        callback(true, self.convertionResponse)
                    } else {
                        if let incorrectResponseJSON = try? JSONDecoder().decode(IncorrectResponse.self, from: data) {
                            let incorrectResponse = incorrectResponseJSON
                            self.convertionError = .incorrectRequest(errorDescription: incorrectResponse.error.info)
                            callback(false, nil)
                        } else {
                            callback(false, nil)
                        }
                    }
                }
            }
            
            task?.resume()
        } else {
            if let convertionResponse = self.convertionResponse {
                callback(true, convertionResponse)
            } else {
                callback(false, nil)
            }
        }
    }
    
    private func createConvertionRequest() -> URLRequest {
        var request = URLRequest(url: ConvertionService.shared.convertionUrl)
        request.httpMethod = "POST"
        
        let body = ""
        request.httpBody = body.data(using: .utf8)
        return request
    }
    
    private func getcurrentTimestamp() -> Int {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT:0)
        let date = Date()
        let currentTimestamp = Int(date.timeIntervalSince1970)
        return currentTimestamp
    }
}




