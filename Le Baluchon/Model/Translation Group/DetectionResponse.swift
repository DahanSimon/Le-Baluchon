//
//  DetectionResponse.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 28/01/2021.
//

import Foundation


// MARK: - DetectionResponse
struct DetectionResponse: Codable {
    let data: DetectionDataClass
}

// MARK: - DataClass
struct DetectionDataClass: Codable {
    let detections: [[Detection]]
}

// MARK: - Detection
struct Detection: Codable {
    let isReliable: Bool
    let confidence: Double
    let language: String
}

let a = DetectionResponse(data: DetectionDataClass(detections: [[Detection(isReliable: true, confidence: 1, language: "fr")]]))
