//
//  ExchangeService.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 25/09/2020.
//

import Foundation



class ConvertionService {
    
    static var shared = ConvertionService(api: ApiConvertion())
    
    let api: ConvertionProtocol
    
    init(api: ConvertionProtocol) {
        self.api = api
    }
    
    var convertionResponse: ConvertionResponse?
    var baseCurrency = "EUR"
    
    var currentTimestamp: TimeInterval {
        return getcurrentTimestamp()
    }
    var lastUpdatedRateDate: TimeInterval?
    var lastBaseRequested: String?
    
    
    func convert(callback: @escaping (RequestResponse<ConvertionResponse>) -> Void) {
        
        // Checks if we need to call the API
        if lastUpdatedRateDate ?? 0 <= currentTimestamp - 3600 || lastBaseRequested != baseCurrency {
            api.getConvertion(baseCurrency: self.baseCurrency) { (requestResponse) in
                switch requestResponse {
                case .failure(_):
                    callback(requestResponse)
                case .success(let convertionResponse):
                    self.convertionResponse = convertionResponse
                    self.lastUpdatedRateDate = convertionResponse.timestamp
                    self.lastBaseRequested = self.baseCurrency
                    callback(requestResponse)
                }
            }
        } else {
            if let convertionResponse = self.convertionResponse {
                callback(RequestResponse.success(convertionResponse))
            }
        }
    }
    
    
    
    private func getcurrentTimestamp() -> TimeInterval {
        let date = Date()
        let currentTimestamp = date.timeIntervalSince1970
        return currentTimestamp
    }
    
    deinit {
        print("Convertion has been deinited no retain cycle")
    }
}
