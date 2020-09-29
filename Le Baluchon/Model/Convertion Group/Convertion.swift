//
//  Exchange.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 25/09/2020.
//

import Foundation

class Convertion {
    
    static var shared = Convertion()
    
    private init() {}
    
    private let currencyToConvertFrom = "EUR"
    var currencyToConvertTo = "USD"
    var amountToConvertString = ""
    
    var amountToConvert: Double? {
        if let amount = Double(Convertion.shared.amountToConvertString) {
            return amount
        } else {
            return nil
        }
    }
    
    var rate: Double?
    var result: Double? {
        guard let rate = Convertion.shared.rate else {
            return nil
        }
        
        guard let amount = Convertion.shared.amountToConvert else {
            return nil
        }
        return amount * rate
    }
}
