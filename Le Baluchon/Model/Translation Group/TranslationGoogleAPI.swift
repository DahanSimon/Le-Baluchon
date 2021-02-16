//
//  TranslationGoogleAPI.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 25/01/2021.
//

import Foundation

class TranslationGoogleAPI: TranslationAPIProtocol {
    private var translationSession = URLSession(configuration: .default)
    private var task: URLSessionDataTask?
    var sourceLanguage: String?
    var translationResponse: TranslationResponse?
    var incorrectTranslationResponse: IncorrectTranslationResponse?
    
    func getTranslation(textToTranslate: String, callback: @escaping (RequestResponse) -> Void) {
        
        guard let textToTranslateUrlFriendly = textToTranslate.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        
        var translationURL: URL? {
            guard let sourceLanguage = self.sourceLanguage else {
                return nil
            }
            var url: URL?
            url = URL(string: "https://translation.googleapis.com/language/translate/v2?key=AIzaSyA5IE8fEVAPl0J1jYH_drQZVOi_FTThdng&q=" + textToTranslateUrlFriendly + "&source=" +  sourceLanguage +  "&target=en&format=text")
            return url
        }
        
        guard let request = createRequest(url: translationURL) else {
            return
        }
        
        task?.cancel()
        task = translationSession.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async { [self] in
                let englishTranslationresponse = TranslationResponse(data: TranslationDataClass(translations: [Translation(translatedText: textToTranslate)]))
                if self.sourceLanguage == "en" {
                    callback(RequestResponse.success(englishTranslationresponse))
                    return
                }
                                
                guard let data = data, error == nil else {
                    callback(RequestResponse.failure(ServiceError.noDataReceived))
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    if let incorrectResponseJSON = try? JSONDecoder().decode(IncorrectTranslationResponse.self, from: data) {
                        self.incorrectTranslationResponse = incorrectResponseJSON
                        
                    }
                    callback(RequestResponse.failure(ServiceError.translationError))
                    return
                }
                
                if let responseJSON = try? JSONDecoder().decode(TranslationResponse.self, from: data) {
                    self.translationResponse = responseJSON
                    callback(RequestResponse.success(responseJSON))
                }
            }
        }
        task?.resume()
    }
    
    private func createRequest(url: URL?) -> URLRequest? {
        guard let translationURL = url else {
            return nil
        }
        
        var request = URLRequest(url: translationURL)
        request.httpMethod = "POST"
        
        let body = ""
        request.httpBody = body.data(using: .utf8)
        return request
    }
    
    func getSourceLanguage(textToTranslate: String, callback: @escaping (Bool, String?) -> Void)  {
        let detectionSession = URLSession(configuration: .default)
        var detectionTask: URLSessionDataTask?
        guard let textToTranslateUrlFriendly = textToTranslate.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        
        var detectionURL: URL? {
            var url: URL?
            url = URL(string: "https://translation.googleapis.com/language/translate/v2/detect?key=AIzaSyA5IE8fEVAPl0J1jYH_drQZVOi_FTThdng&q=" + textToTranslateUrlFriendly)
            return url
        }
        
        guard let detectionRequest = createRequest(url: detectionURL) else {
            return
        }
        
        detectionTask?.cancel()
        detectionTask = detectionSession.dataTask(with: detectionRequest) { (data, response, error) in
            DispatchQueue.main.async { [self] in
                
                //                    guard let self = self else { return }
                
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }
                
                if let responseJSON = try? JSONDecoder().decode(DetectionResponse.self, from: data) {
                    self.sourceLanguage = responseJSON.data.detections.first?.first?.language
                    if self.sourceLanguage != "und" {
                        callback(true, responseJSON.data.detections.first?.first?.language)
                    } else {
                        callback(false,responseJSON.data.detections.first?.first?.language)
                    }
                    
                }
            }
        }
        detectionTask?.resume()
    }
}


