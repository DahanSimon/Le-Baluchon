//
//  ExchangeService.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 25/09/2020.
//

import Foundation

class ConvertionService {
    static var shared = ConvertionService()
    private var convertionSession = URLSession(configuration: .default)
    var lastUpdatedRateDate: String?
    private init() {}
    
    var currentDate: String {
        print("\(getCurrentDate())")
        return getCurrentDate()
    }
    
    var amountToConvertString = ""
    
    var amountToConvert: Double? {
        if let amount = Double(amountToConvertString) {
            return amount
        } else {
            return nil
        }
    }
    
    private var convertionUrl: URL {
        let url = URL(string: "https://data.fixer.io/api/" + self.currentDate + "?access_key=07bb16458b377a95361d648e74daed7f&base=EUR&symbols=usd")!
        return url
    }
    private var task: URLSessionDataTask?
    
    init (exchangeSession: URLSession) {
        self.convertionSession = exchangeSession
    }
    
    func getConvertion(callback: @escaping (Bool, Convertion?) -> Void) {
        let request = createConvertionRequest()
        task?.cancel()
        
        guard let amount = amountToConvert else {
            callback(false, nil)
            return
        }
        
        if self.lastUpdatedRateDate != getCurrentDate() {
            task = convertionSession.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    guard let data = data, error == nil else {
                        callback(false, nil)
                        return
                    }
                    
                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        callback(false, nil)
                        return
                    }
                    
                    if let responseJSON = try? JSONDecoder().decode(ConvertionResponse.self, from: data) {
                        if responseJSON.success {
                            Convertion.rate = responseJSON.rates.usd
                            
                            let convert = Convertion(convert: amount)
                            self.lastUpdatedRateDate = self.currentDate
                            callback(true, convert)
                            
                        } else {
                            callback(false, nil)
                        }
                    } else {
//                        if let incorrectResponseJSON = try? JSONDecoder().decode(IncorrectResponse.self, from: data) {
//                            if !incorrectResponseJSON.success {
//                                let error = incorrectResponseJSON.error.code
//                                callback(false, nil)
//                            } else {
//                                callback(false, nil)
//                            }
//                        }
//                        callback(false, nil)
                    }
                }
            }
            
            task?.resume()
        } else {
            let convert = Convertion(convert: amount)
            callback(true, convert)
        }
    }
    
    
    
    private func createConvertionRequest() -> URLRequest {
        var request = URLRequest(url: ConvertionService.shared.convertionUrl)
        request.httpMethod = "POST"
        
        let body = ""
        request.httpBody = body.data(using: .utf8)
        return request
    }
    
    private func getCurrentDate() -> String {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}




