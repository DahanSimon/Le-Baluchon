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
    
    private init() {}
    
    var amountToConvert = ""
    private var convertionUrl: URL {
        if let url = URL(string: "https://data.fixer.io/api/convert?access_key=07bb16458b377a95361d648e74daed7f&from=EUR&to=USD&amount=" + self.amountToConvert){
            return url
        } else {
            let wrongUrl = URL(string: "https://data.fixer.io/api/convert?access_key=07bb16458b377a95361d648e74daed7&from=EUR&to=USD&amount=0")!
            return wrongUrl
        }
    }
    private var task: URLSessionDataTask?
    
    init (exchangeSession: URLSession) {
        self.convertionSession = exchangeSession
    }
    
    func getConvertion(callback: @escaping (Bool, Convertion?) -> Void) {
        let request = createConvertionRequest()
        task?.cancel()
        
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
                        let convert = Convertion(convert: responseJSON.query.amount, from: responseJSON.query.from, to: responseJSON.query.to, rate: responseJSON.info.rate, result: responseJSON.result!)
                        callback(true, convert)
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
        var request = URLRequest(url: ConvertionService.shared.convertionUrl)
        request.httpMethod = "POST"
        
        let body = ""
        request.httpBody = body.data(using: .utf8)
        return request
    }
}




