//
//  URLSessionUtility.swift
//  iOSEngineerCodeCheck
//
//  Created by RIKU on 2023/05/22.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case transportError(Error)
    case serverError(statusCode: Int)
    case noData
    case decodingError(Error)
}

class URLSessionUtility {
    
    static func makeUrlSessionDataTask(with url: URL,
                                       completionHandler: @escaping (Data?, NetworkError?) -> ()) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completionHandler(nil, .transportError(error))
                return
            }
            
            if let response = response as? HTTPURLResponse,
               !(200...299).contains(response.statusCode) {
                completionHandler(nil, .serverError(statusCode: response.statusCode))
                return
            }
            
            guard let data = data else {
                completionHandler(nil, .noData)
                return
            }
            
            completionHandler(data, nil)
        }
    }
    
    static func makeUrlSessionDataTask<T: Decodable>(with url: URL,
                                                     decodeType: T.Type,
                                                     resultHandler: @escaping (Result<T, NetworkError>) -> ()) -> URLSessionDataTask {
        return makeUrlSessionDataTask(with: url) { data, error in
            if let error = error {
                resultHandler(.failure(error))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(decodeType, from: data!)
                resultHandler(.success(response))
            } catch {
                resultHandler(.failure(.decodingError(error)))
            }
        }
    }
}
