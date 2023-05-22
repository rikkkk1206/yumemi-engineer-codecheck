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
    
    static func filterResponseData(data: Data?, response: URLResponse?, error: Error?) -> Result<Data, NetworkError> {
        if let error = error {
            return .failure(.transportError(error))
        }
        
        if let response = response as? HTTPURLResponse,
           !(200...299).contains(response.statusCode) {
            return .failure(.serverError(statusCode: response.statusCode))
        }
        
        guard let data = data else {
            return .failure(.noData)
        }
        
        return .success(data)
    }
    
    static func makeUrlSessionDataTask(with url: URL,
                                       completionHandler: @escaping (Data?, NetworkError?) -> ()) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: url) { data, response, error in
            let result = filterResponseData(data: data, response: response, error: error)
            switch result {
            case .success(let data):
                completionHandler(data, nil)
            case .failure(let failure):
                completionHandler(nil, failure)
            }
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
    
    static func urlSessionData(with url: URL) async -> Result<Data, NetworkError> {
        do {
            let (data, response) = try await URLSession.shared.data(for: .init(url: url))
            return filterResponseData(data: data, response: response, error: nil)
        } catch {
            return .failure(.transportError(error))
        }
    }
    
    static func urlSessionData<T: Decodable>(with url: URL, decodeType: T.Type) async -> Result<T, NetworkError> {
        let result = await urlSessionData(with: url)
        switch result {
        case .success(let data):
            do {
                let response = try JSONDecoder().decode(decodeType, from: data)
                return .success(response)
            } catch {
                return .failure(.decodingError(error))
            }
        case .failure(let failure):
            return .failure(failure)
        }
    }
}
