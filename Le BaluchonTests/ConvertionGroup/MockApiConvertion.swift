//
//  MockApiConvertion.swift
//  Le BaluchonTests
//
//  Created by Simon Dahan on 24/01/2021.
//

import Foundation
@testable import Le_Baluchon

class MockApiConvertion: ConvertionProtocol {
    var expectedResult: Double?
    var baseCurrency: String
    var convertToCurrency: String
    var amountToConvert: Double
    var convertionResponse: ConvertionResponse?
    var apiCallCounter = 0
    init(expectedResult: Double?, baseCurrency: String, convertToCurrency: String, amountToConvert: Double, rate: Double, timestamp: TimeInterval) {
        self.expectedResult = expectedResult
        self.baseCurrency = baseCurrency
        self.amountToConvert = amountToConvert
        self.convertToCurrency = convertToCurrency
        self.convertionResponse = ConvertionResponse(success: true, timestamp: timestamp, base: baseCurrency, date: "01/01/2021", rates: [convertToCurrency: rate])
    }
    
    
    func getConvertion(baseCurrency: String, callback: @escaping (RequestResponse<ConvertionResponse>) -> Void) {
        self.apiCallCounter += 1
        guard let convertionResponse = self.convertionResponse, self.expectedResult != nil else {
            callback(RequestResponse.failure(ServiceError.convertionError))
            return
        }
        callback(RequestResponse.success(convertionResponse))
    }
}
