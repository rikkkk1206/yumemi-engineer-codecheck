//
//  SearchRepositoryModel.swift
//  iOSEngineerCodeCheck
//
//  Created by RIKU on 2023/05/18.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import UIKit

protocol SearchRepositoryModelInput {
    var runningFetchRepositoryTask: Bool { get set }
    func fetchRepositoryInfomation(inputText: String) async -> [RepositoryInfomation]?
}

final class SearchRepositoryModel: SearchRepositoryModelInput {
    
    static let didSetRunningFetchRepositoryTask = Notification.Name("didSetRunningFetchRepositoryTask")
    
    var runningFetchRepositoryTask: Bool = false {
        didSet {
            NotificationCenter.default.post(
                name: SearchRepositoryModel.didSetRunningFetchRepositoryTask,
                object: runningFetchRepositoryTask)
        }
    }
    
    func fetchRepositoryInfomation(inputText: String) async -> [RepositoryInfomation]? {
        // リポジトリ情報を取得
        runningFetchRepositoryTask = true
        guard let repositories = await fetchRepository(inputText: inputText) else {
            runningFetchRepositoryTask = false
            return nil
        }
        var repositoryInfos: [RepositoryInfomation] = []
        // 検索結果の全リポジトリについて、avatarUrlから画像情報を取得
        for repository in repositories {
            var info = RepositoryInfomation(repository: repository, image: nil)
            // 情報が全部揃ってから返却する
            let image = await fetchAvatarImage(with: repository.owner.avatarUrl)
            info.image = image
            repositoryInfos.append(info)
        }
        runningFetchRepositoryTask = false
        return repositoryInfos
    }
    
    private func fetchRepository(inputText: String) async -> [Repository]? {
        // 日本語等をurlに埋め込めるようにパーセントエンコード
        guard let encodedInputText = inputText.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            print("failed encode \(inputText) for URL")
            return nil
        }
        let urlString = "https://api.github.com/search/repositories?q=\(encodedInputText)"
        guard let url = URL(string: urlString) else {
            print("urlString(\(urlString)) is invalid")
            return nil
        }
        
        let result = await URLSessionUtility.urlSessionData(with: url, decodeType: SearchRepositoryResponse.self)
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
        
        let result = await URLSessionUtility.urlSessionData(with: url)
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
