//
//  ConvertionProtocol.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 24/01/2021.
//

import Foundation

protocol ConvertionProtocol {
    func getConvertion(baseCurrency: String, callback: @escaping (Bool, ConvertionResponse?) -> Void)
}
