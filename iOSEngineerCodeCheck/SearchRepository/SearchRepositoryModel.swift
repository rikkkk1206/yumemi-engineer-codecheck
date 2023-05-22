//
//  SearchRepositoryModel.swift
//  iOSEngineerCodeCheck
//
//  Created by RIKU on 2023/05/18.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import UIKit

protocol SearchRepositoryModelInput {
    var runningUrlSessionTask: Bool { get set }
    func fetchRepositoryInfomation(inputText: String) async -> [RepositoryInfomation]?
}

final class SearchRepositoryModel: SearchRepositoryModelInput {
    
    var runningUrlSessionTask: Bool = false
    
    func fetchRepositoryInfomation(inputText: String) async -> [RepositoryInfomation]? {
        guard let repositories = await fetchRepository(inputText: inputText) else {
            return nil
        }
        var repositoryInfos: [RepositoryInfomation] = []
        for repository in repositories {
            var info = RepositoryInfomation(repository: repository, image: nil)
            let image = await fetchAvatarImage(with: repository.owner.avatarUrl)
            info.image = image
            repositoryInfos.append(info)
        }
        return repositoryInfos
    }
    
    private func fetchRepository(inputText: String) async -> [Repository]? {
        guard let encodedInputText = inputText.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            print("failed encode \(inputText) for URL")
            return nil
        }
        let urlString = "https://api.github.com/search/repositories?q=\(encodedInputText)"
        guard let url = URL(string: urlString) else {
            print("urlString(\(urlString)) is invalid")
            return nil
        }
        
        runningUrlSessionTask = true
        let result = await URLSessionUtility.urlSessionData(with: url, decodeType: SearchRepositoryResponse.self)
        runningUrlSessionTask = false
        switch result {
        case .success(let response):
            return response.items
        case .failure(let failure):
            print("failed makeUrlSessionDataTask(\(urlString)): ", failure)
            return nil
        }
    }
    
    private func fetchAvatarImage(with urlString: String) async -> UIImage? {
        guard let url = URL(string: urlString) else {
            print("urlString(\(urlString)) is invalid")
            return nil
        }
        
        runningUrlSessionTask = true
        let result = await URLSessionUtility.urlSessionData(with: url)
        runningUrlSessionTask = false
        switch result {
        case .success(let data):
            guard let image = UIImage(data: data) else {
                print("failed create UIImage by", data)
                return nil
            }
            return image
        case .failure(let failure):
            print("failed makeUrlSessionDataTask(\(urlString)): ", failure)
            return nil
        }
    }
}
