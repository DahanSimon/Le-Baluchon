//
//  URLSessionFake.swift
//  Le BaluchonTests
//
//  Created by Simon Dahan on 27/10/2020.
//

import Foundation
import Le_Baluchon

class URLSessionFake: URLSession {
    var parisData: Data?
    var newYorkData: Data?
    var response: URLResponse?
    var error: Data?
    
    init(originData: Data?, destinationData: Data?, response: URLResponse?, error: Data?) {
        self.parisData = originData
        self.newYorkData = destinationData
        self.response = response
        self.error = error
    }
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSessionDataTaskFake()
        task.completionHandler = completionHandler
        if let requestUrl = request.url  {
            if requestUrl.absoluteString == "https://api.openweathermap.org/data/2.5/weather?q=Paris&appid=be119e6e4c0a0f05303ec9a30132499e&units=metric&lang=fr" {
                task.data = parisData
            } else if requestUrl.absoluteString == "https://api.openweathermap.org/data/2.5/weather?q=New%20York&appid=be119e6e4c0a0f05303ec9a30132499e&units=metric&lang=fr" {
                task.data = newYorkData
            }
            else {
                task.data = error
            }
        }
        task.urlResponse = response
        return task
    }
}

class URLSessionDataTaskFake: URLSessionDataTask {
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    var data: Data?
    var urlResponse: URLResponse?
    var responseError: Error?
    
    override func resume() {
        completionHandler?(data, urlResponse, responseError)
    }
    
    override func cancel() {}
}
