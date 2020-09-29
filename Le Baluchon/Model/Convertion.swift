//
//  Exchange.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 25/09/2020.
//

import Foundation

class Convertion {
    
    private let currencyToConvertFrom = "EUR"
    var currencyToConvertTo = "USD"
    var amount: Double
    static var rate: Double?
    var result: Double? {
        guard let rate = Convertion.rate else {
            return nil
        }
        return amount * rate
    }
    
    
    
    init(convert amount: Double) {
        self.amount = amount
    }
}
