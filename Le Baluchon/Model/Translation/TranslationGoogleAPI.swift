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
    
    func getTranslation(textToTranslate: String, callback: @escaping (Bool, TranslationResponse?) -> Void) {
        
        guard let textToTranslateUrlFriendly = textToTranslate.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        
        var translationURL: URL? {
            guard let sourceLanguage = self.sourceLanguage else {
                return nil
            }
            var url: URL?
            url = URL(string: "https://translation.googleapis.com/language/translate/v2?key=AIzaSyA5IE8fEVAPl0J1jYH_drQZVOi_FTThdng&q=" + textToTranslateUrlFriendly + "&source=" +  sourceLanguage +  "&target=en&format=text")!
            return url
        }
        
        guard let request = createTranslationRequest(url: translationURL) else {
            return
        }
        
        task?.cancel()
        task = translationSession.dataTask(with: request) { (data, response, error) in
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
                
                if let responseJSON = try? JSONDecoder().decode(TranslationResponse.self, from: data) {
                    self.translationResponse = responseJSON
                    callback(true, self.translationResponse)
                } else {
                    if let incorrectResponseJSON = try? JSONDecoder().decode(IncorrectResponse.self, from: data) {
                        callback(false, nil)
                    } else {
                        callback(false, nil)
                    }
                }
            }
        }
        task?.resume()
    }
    
    private func createTranslationRequest(url: URL?) -> URLRequest? {
        guard let translationURL = url else {
            return nil
        }
        
        var request = URLRequest(url: translationURL)
        request.httpMethod = "POST"
        
        let body = ""
        request.httpBody = body.data(using: .utf8)
        return request
    }
    
    private func createDetectLanguageRequest(url: URL?) -> URLRequest? {
        guard let translationURL = url else {
            return nil
        }
        
        var request = URLRequest(url: translationURL)
        request.httpMethod = "POST"
        
        let body = ""
        request.httpBody = body.data(using: .utf8)
        return request
    }
    
    func getSourceLanguage(textToTranslate: String, callback: @escaping (Bool, DetectionResponse?) -> Void)  {
        let detectionSession = URLSession(configuration: .default)
        var detectionTask: URLSessionDataTask?
        guard let textToTranslateUrlFriendly = textToTranslate.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        
        var detectionURL: URL? {
            var url: URL?
            url = URL(string: "https://translation.googleapis.com/language/translate/v2/detect?key=AIzaSyA5IE8fEVAPl0J1jYH_drQZVOi_FTThdng&q=" + textToTranslateUrlFriendly)!
            return url
        }
        
        guard let detectionRequest = createTranslationRequest(url: detectionURL) else {
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
                    self.sourceLanguage = responseJSON.data.detections[0][0].language
                    callback(true, responseJSON)
                } else {
                    if let incorrectResponseJSON = try? JSONDecoder().decode(IncorrectResponse.self, from: data) {
                        callback(false, nil)
                    } else {
                        callback(false, nil)
                    }
                }
            }
        }
        detectionTask?.resume()
    }
}


