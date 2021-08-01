//
//  URLSession+Extension.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 31.07.2021.
//

import Foundation

public typealias URLSessionCompletionHandler = (Data?, URLResponse?, Error?) -> Void

public extension URLSession {
    
    var hostsWithPassword: [String] {
        set {}
        get {
            return ["http://tourstart.info/", "https://tourstart.info/", "https://ng.tourstart.org/"]
        }
    }
    
    private static var standart: URLSession {
        URLSession(configuration: .default)
    }
    
    func safeDataTask(with urlString: String, timeout: Double = 30, completionHandler: @escaping URLSessionCompletionHandler) -> URLSessionDataTask? {
        guard let url = URL(string: urlString) else {
            completionHandler(nil, nil, NSError(message: "Can't create url from \(urlString)"))
            return nil
        }
        return safeDataTask(with: url, timeout: timeout, completionHandler: completionHandler)
    }
    
    func safeDataTask(with url: URL, timeout: Double = 30, completionHandler: @escaping URLSessionCompletionHandler) -> URLSessionDataTask {
        var request = URLRequest.init(url: url)
        if url.absoluteString.hasOnePrefix(hostsWithPassword) {
            request.enableTestServerAuth()
        }
        request.timeoutInterval = timeout
        let result = dataTask(with: request, completionHandler: completionHandler)
        return result
    }
    
    static func runDefaultDataTask(with url: URL, timeout: Double = 99, completionHandler: @escaping URLSessionCompletionHandler) {
        DispatchQueue.background.async {
            let task: URLSessionDataTask = standart.safeDataTask(with: url, timeout: timeout, completionHandler: completionHandler)
            task.resume()
        }
    }
    
    static func runDefaultDataTask(with urlString: String, timeout: Double = 99, completionHandler: @escaping URLSessionCompletionHandler) {
        DispatchQueue.background.async {
            guard let task: URLSessionDataTask = standart.safeDataTask(with: urlString, timeout: timeout, completionHandler: completionHandler) else {
                return
            }
            task.resume()
        }
    }
}

public extension URLRequest {
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
