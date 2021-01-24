//
//  MockApiConvertion.swift
//  Le BaluchonTests
//
//  Created by Simon Dahan on 24/01/2021.
//

import Foundation
@testable import Le_Baluchon

class MockApiConvertion: ConvertionProtocol {
    var euroBasedConvertionData: Data?
    var usdBasedConvertionData: Data?
    var baseCurrency: String?
    init(baseCurrency: String) {
        if baseCurrency == "EUR" {
            self.baseCurrency = baseCurrency
            self.euroBasedConvertionData = FakeConvertionData.euroBasedConvertionData
            self.usdBasedConvertionData = nil
        } else if baseCurrency == "USD" {
            self.baseCurrency = baseCurrency
            self.euroBasedConvertionData = nil
            self.usdBasedConvertionData = FakeConvertionData.usdBasedConvertionData
        } else {
            self.baseCurrency = nil
            self.euroBasedConvertionData = nil
            self.usdBasedConvertionData = nil
        }
    }
    
    func getConvertion(baseCurrency: String, callback: @escaping (Bool, ConvertionResponse?) -> Void) {
        
        
        if baseCurrency == "EUR" {
            guard let euroBasedConvertionData = self.euroBasedConvertionData else {
                callback(false,nil)
                return
            }
            if let responseJSON = try? JSONDecoder().decode(ConvertionResponse.self, from: euroBasedConvertionData){
                callback(true,responseJSON)
            } else {
                callback(false,nil)
            }
        } else if baseCurrency == "USD" {
            guard let usdBasedConvertionData = self.usdBasedConvertionData else {
                callback(false,nil)
                return
            }
            if let responseJSON = try? JSONDecoder().decode(ConvertionResponse.self, from: usdBasedConvertionData){
                callback(true,responseJSON)
            } else {
                callback(false,nil)
            }
            
        }
    }
}
