//
//  URLSession+Extension.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 31.07.2021.
//

import Foundation

/*
 Simlify work with URLSession
 */

public extension URLSession {
    
    // MARK: Public Properties
    
    static var hostsWithPassword: [String] = ["http://somehost.com/", "https://otherhost.com/"]
    
    static var standart: URLSession {
        URLSession(configuration: .default)
    }
    
    // MARK: Public Functions
    
    func safeDataTask(with urlString: String, timeout: Double = 30, completionHandler: @escaping URLSessionCompletionHandler) -> URLSessionDataTask? {
        guard let url = URL(string: urlString) else {
            completionHandler(nil, nil, NSError(message: "Can't create url from \(urlString)"))
            return nil
        }
        return safeDataTask(with: url, timeout: timeout, completionHandler: completionHandler)
    }
    
    func safeDataTask(with url: URL, timeout: Double = 30, completionHandler: @escaping URLSessionCompletionHandler) -> URLSessionDataTask {
        var request = URLRequest.init(url: url)
        if url.absoluteString.hasOnePrefix(Self.hostsWithPassword) {
            request.enableTestServerAuth()
        }
        request.timeoutInterval = timeout
        let result = dataTask(with: request, completionHandler: completionHandler)
        return result
    }
    
    func runDefaultDataTask(with url: URL, timeout: Double = 99, completionHandler: @escaping URLSessionCompletionHandler) {
        DispatchQueue.background.async {
            let task: URLSessionDataTask = self.safeDataTask(with: url, timeout: timeout, completionHandler: completionHandler)
            task.resume()
        }
    }
    
    func runDefaultDataTask(with urlString: String, timeout: Double = 99, completionHandler: @escaping URLSessionCompletionHandler) {
        DispatchQueue.background.async {
            guard let task: URLSessionDataTask = self.safeDataTask(with: urlString, timeout: timeout, completionHandler: completionHandler) else {
                return
            }
            task.resume()
        }
    }
    
}

public typealias URLSessionCompletionHandler = (Data?, URLResponse?, Error?) -> Void

fileprivate extension URLRequest {
    
    mutating func enableTestServerAuth() {
        let authStr = "user:passwprd"
        guard let authData = authStr.data(using: .ascii) else {
            fatalMistake("can't serialize authStr (\(authStr))")
            return
        }
        let authValue = "Basic " + authData.base64EncodedString(options: .endLineWithCarriageReturn)
        setValue(authValue, forHTTPHeaderField: "Authorization")
    }
    
}
