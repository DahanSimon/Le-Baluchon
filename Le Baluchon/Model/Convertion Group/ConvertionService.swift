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
    //    private init() {}
    
    var convertionResponse: ConvertionResponse?
    var baseCurrency = "EUR"
    
    var currentTimestamp: Int {
        return getcurrentTimestamp()
    }
    var lastUpdatedRateDate: Int?
    var lastBaseRequested: String?
    
    
    //    init (exchangeSession: URLSession, baseCurrency: String) {
    //        self.convertionSession = exchangeSession
    //    }
    
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
    
    
    
    private func getcurrentTimestamp() -> Int {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT:0)
        let date = Date()
        let currentTimestamp = Int(date.timeIntervalSince1970)
        return currentTimestamp
    }
    
    deinit {
        print("Convertion has been deinited no retain cycle")
    }
}




