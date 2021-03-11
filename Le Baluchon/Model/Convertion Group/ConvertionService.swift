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
        return getCurrentTimestamp()
    }
    var lastUpdatedRateDate: TimeInterval?
    var lastBaseRequested: String?
    
    // if the last rates have been received more than an hour before
    var needUpdate: Bool {
        if let lastUpdatedRate = lastUpdatedRateDate {
            return 3600 <= currentTimestamp - lastUpdatedRate 
        }
        return false
    }
    
    func getConvertion(amountToConvert: Double, convertToCurrencyCode: String, callback: @escaping (RequestResponse<ConvertionResponse>, Double?) -> Void) {
        
        // Checks if we need to update the rates
        if needUpdate || lastBaseRequested != baseCurrency {
            api.getConvertion(baseCurrency: self.baseCurrency) { (requestResponse) in
                switch requestResponse {
                case .failure(_):
                    callback(requestResponse, nil)
                case .success(let convertionResponse):
                    self.convertionResponse = convertionResponse
                    self.lastUpdatedRateDate = convertionResponse.timestamp
                    self.lastBaseRequested = self.baseCurrency
                    if let rate = convertionResponse.rates[convertToCurrencyCode] {
                        callback(requestResponse, self.convert(amountToConvert: amountToConvert, rate: rate))
                    }
                }
            }
        } else {
            if let convertionResponse = self.convertionResponse, let rate = convertionResponse.rates[convertToCurrencyCode] {
                callback(RequestResponse.success(convertionResponse), self.convert(amountToConvert: amountToConvert, rate: rate))
            }
        }
    }
    
    private func convert(amountToConvert: Double, rate: Double) -> Double {
        return amountToConvert * rate
    }
    
    private func getCurrentTimestamp() -> TimeInterval {
        let date = Date()
        let currentTimestamp = date.timeIntervalSince1970
        return currentTimestamp
    }
    
    deinit {
        print("Convertion has been deinited no retain cycle")
    }
}
