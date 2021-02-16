//
//  ConvertionErrors.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 30/09/2020.
//

import Foundation

enum ConvertionError {
    case noDataReceived
    case responseCodeIsNot200
    case incorrectRequest(errorDescription: String)
}


