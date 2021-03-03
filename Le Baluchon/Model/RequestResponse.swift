//
//  RequestResponse.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 16/02/2021.
//

import Foundation

enum RequestResponse <Value> {
    case failure(ServiceError)
    case success(Value)
}
