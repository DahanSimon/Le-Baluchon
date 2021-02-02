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
    
    
    func convert(callback: @escaping (Bool, ConvertionResponse?) -> Void) {
        
        // Checks if we need to call the API
        if lastUpdatedRateDate ?? 0 <= currentTimestamp - 3600 || lastBaseRequested != baseCurrency {
            api.getConvertion(baseCurrency: self.baseCurrency) { (responseError, convertionResponse) in
                self.convertionResponse = convertionResponse
                self.lastUpdatedRateDate = self.convertionResponse!.timestamp
                self.lastBaseRequested = self.baseCurrency
                if let convertionResponse = convertionResponse {
                    callback(true, convertionResponse)
                } else {
                    callback(false, nil)
                }
            }
            
        } else {
            if let convertionResponse = convertionResponse {
                callback(true, convertionResponse)
            } else {
                callback(false, nil)
            }
        }
    }
    
    
    
    private func getcurrentTimestamp() -> TimeInterval {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT:0)
        let date = Date()
        let currentTimestamp = date.timeIntervalSince1970
        return currentTimestamp
    }
    
    deinit {
        print("Convertion has been deinited no retain cycle")
    }
}




