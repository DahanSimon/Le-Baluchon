//
//  FakeTranslationData.swift
//  Le BaluchonTests
//
//  Created by Simon Dahan on 25/01/2021.
//

import Foundation

class FakeTranslationData {
    
    // MARK: - Data
    static var helloTranslationData: Data? {
        let bundle = Bundle(for: FakeTranslationData.self)
        let url = bundle.url(forResource: "HelloTranslationData", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
}
