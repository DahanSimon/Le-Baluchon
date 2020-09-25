//
//  Exchange.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 25/09/2020.
//

import Foundation

class Exchange {
    
    var currencyToConvertFrom: String
    var currencyToConvertTo: String
    var amount: Double
    var rate: Double
    var result: Double
    
    
    init(convert amount: Double, from currencyToConvertFrom: String, to currencyToConvertTo: String, rate: Double, result: Double) {
        self.amount = amount
        self.currencyToConvertFrom = currencyToConvertFrom
        self.currencyToConvertTo = currencyToConvertTo
        self.rate = rate
        self.result = result
    }
}
