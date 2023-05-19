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
    
    func fetchRepository(
        inputText: String,
        completion: @escaping ([Repository]) -> ()) {
            guard let encodedInputText = inputText.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
                print("failed encode \(inputText) for URL")
                return
            }
            let urlString = "https://api.github.com/search/repositories?q=\(encodedInputText)"
            guard let url = URL(string: urlString) else {
                print("urlString(\(urlString)) is invalid")
                return
            }
            searchingSessionTask = URLSession.shared.dataTask(with: url) { (data, res, err) in
                if let data = data {
                    do {
                        let response = try JSONDecoder().decode(SearchRepositoryResponse.self, from: data)
                        completion(response.items)
                    } catch {
                        print(error)
                    }
                }
                if let err = err {
                    print(err)
                }
            }
            // APIへの問い合わせを実行
            searchingSessionTask?.resume()
        }
    
    func searchingSessionCancel() {
        searchingSessionTask?.cancel()
    }
}
