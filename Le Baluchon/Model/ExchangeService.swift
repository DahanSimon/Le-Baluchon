//
//  ExchangeService.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 25/09/2020.
//

import Foundation

class ExchangeService {
    static var shared = ExchangeService()
    private var exchangeSession = URLSession(configuration: .default)
    
    private init() {}
    
    var amountToExchange = ""
    private var exchangeUrl: URL {
        if let url = URL(string: "https://data.fixer.io/api/convert?access_key=07bb16458b377a95361d648e74daed7f&from=EUR&to=USD&amount=" + self.amountToExchange){
            return url
        } else {
            let wrongUrl = URL(string: "https://data.fixer.io/api/convert?access_key=07bb16458b377a95361d648e74daed7&from=EUR&to=USD&amount=0")!
            return wrongUrl
        }
    }
    private var task: URLSessionDataTask?
    
    init (exchangeSession: URLSession) {
        self.exchangeSession = exchangeSession
    }
    
    func getConvertion(callback: @escaping (Bool, Exchange?) -> Void) {
        let request = createConvertionRequest()
        task?.cancel()
        
        task = exchangeSession.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }
                
                if let responseJSON = try? JSONDecoder().decode(Response.self, from: data) {
                    if responseJSON.success {
                        let exchange = Exchange(convert: responseJSON.query.amount, from: responseJSON.query.from, to: responseJSON.query.to, rate: responseJSON.info.rate, result: responseJSON.result!)
                        callback(true, exchange)
                    } else {
                        callback(false, nil)
                    }
                } else {
                    //                    if let incorrectResponseJSON = try? JSONDecoder().decode(IncorrectResponse.self, from: data) {
                    //                        if !incorrectResponseJSON.success {
                    //                            let error = incorrectResponseJSON.error.code
                    //                            callback(false, nil)
                    //                        } else {
                    //                            callback(false, nil)
                    //                        }
                    //                    }
                    callback(false, nil)
                }
                
            }
        }
        task?.resume()
    }
    
    private func createConvertionRequest() -> URLRequest {
        var request = URLRequest(url: ExchangeService.shared.exchangeUrl)
        request.httpMethod = "POST"
        
        let body = ""
        request.httpBody = body.data(using: .utf8)
        return request
    }
}

struct Response: Codable {
    let success: Bool
    let query: Query
    let info: Info
    let date: String
    let result: Double?
}

struct Info: Codable {
    let timestamp: Int
    let rate: Double
}

struct Query: Codable {
    let from, to: String
    let amount: Double
}

//// MARK: - IncorrectResponse
//struct IncorrectResponse: Codable {
//    let success: Bool
//    let error: Error
//}
//
//// MARK: - Error
//struct Error: Codable {
//    let code: Int
//    let type, info: String
//}

