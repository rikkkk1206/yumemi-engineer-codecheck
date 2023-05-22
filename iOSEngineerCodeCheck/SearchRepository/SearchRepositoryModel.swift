//
//  SearchRepositoryModel.swift
//  iOSEngineerCodeCheck
//
//  Created by RIKU on 2023/05/18.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

protocol SearchRepositoryModelInput {
    var searchingSessionTask: URLSessionTask? { get set }
    func fetchRepository(inputText: String,
                         completion: @escaping ([Repository]) -> ())
    func searchingSessionCancel()
}

final class SearchRepositoryModel: SearchRepositoryModelInput {
    
    var searchingSessionTask: URLSessionTask? = nil
    
    func fetchRepository(inputText: String, completion: @escaping ([Repository]) -> ()) {
        guard let encodedInputText = inputText.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            print("failed encode \(inputText) for URL")
            return
        }
        let urlString = "https://api.github.com/search/repositories?q=\(encodedInputText)"
        guard let url = URL(string: urlString) else {
            print("urlString(\(urlString)) is invalid")
            return
        }
        searchingSessionTask = URLSessionUtility.makeUrlSessionDataTask(with: url, decodeType: SearchRepositoryResponse.self) { result in
            switch result {
            case .success(let response):
                completion(response.items)
            case .failure(let failure):
                print("failed makeUrlSessionDataTask(\(urlString): ", failure)
            }
        }
        // APIへの問い合わせを実行
        searchingSessionTask?.resume()
    }
    
    func searchingSessionCancel() {
        searchingSessionTask?.cancel()
    }
}
