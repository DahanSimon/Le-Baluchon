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
    private var translationURL: URL? {
        var url: URL?
        if let text = self.textToTranslate{
            url = URL(string: "https://translation.googleapis.com/language/translate/v2?key=AIzaSyA5IE8fEVAPl0J1jYH_drQZVOi_FTThdng&q=" + text + "&source=fr&target=en&format=text" )!
        }
        return url
    }
    
    var translationResponse: TranslationResponse?
    var textToTranslate: String? = "Bonjour"
    
    func getTranslation(callback: @escaping (Bool, TranslationResponse?) -> Void) {
        guard let request = createTranslationRequest() else {
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
    
    private func createTranslationRequest() -> URLRequest? {
        guard let translationURL = self.translationURL else {
            return nil
        }
        
        var request = URLRequest(url: translationURL)
        request.httpMethod = "POST"
        
        let body = ""
        request.httpBody = body.data(using: .utf8)
        return request
    }
}
