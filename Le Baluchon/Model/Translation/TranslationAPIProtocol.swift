//
//  TranslationAPIProtocol.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 25/01/2021.
//

import Foundation

protocol TranslationAPIProtocol {
    
    func getTranslation(callback: @escaping (Bool, TranslationResponse?) -> Void)
}
