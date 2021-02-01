//
//  ApiConvertion.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 24/01/2021.
//

import Foundation

class ApiConvertion: ConvertionProtocol {
    
    private var task: URLSessionDataTask?
    private var convertionSession = URLSession(configuration: .default)
    var apiConvertionResponse: ConvertionResponse?
    var convertionError: ConvertionErrors? = nil
    var baseCurrency: String = "EUR"
    private var convertionUrl: URL {
        let url = URL(string: "http://data.fixer.io/api/latest" + "?access_key=07bb16458b377a95361d648e74daed7f&base=" + self.baseCurrency)!
        return url
    }
    
    func getConvertion(baseCurrency: String, callback: @escaping (Bool, ConvertionResponse?) -> Void) {
        self.baseCurrency = baseCurrency
        let request = createConvertionRequest()
        task?.cancel()
        task = convertionSession.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async { [self] in
                
                //                    guard let self = self else { return }
                
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
                    self.apiConvertionResponse = responseJSON
                    callback(true, self.apiConvertionResponse)
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
    }
    
    private func createConvertionRequest() -> URLRequest {
        var request = URLRequest(url: self.convertionUrl)
        request.httpMethod = "POST"
        
        let body = ""
        request.httpBody = body.data(using: .utf8)
        return request
    }
}
