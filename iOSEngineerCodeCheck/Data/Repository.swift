//
//  Repository.swift
//  iOSEngineerCodeCheck
//
//  Created by RIKU on 2023/05/18.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import UIKit

struct SearchRepositoryResponse: Decodable {
    
    let totalCount: Int
    let incompleteResults: Bool
    let items: [Repository]
    
    enum CodingKeys: String, CodingKey {
        
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

struct Repository: Decodable {
    let name: String
    let fullName: String
    let language: String?   // languageはnullの場合があったためOptional
    let stargazersCount: Int
    let watchersCount: Int
    let forksCount: Int
    let openIssuesCount: Int
    let owner: Owner
    let description: String?    // descriptionはnullの場合があったためOptional
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case fullName = "full_name"
        case language
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
        case owner
        case description
        case updatedAt = "updated_at"
    }
    
    struct Owner: Decodable {
        let login: String
        let avatarUrl: String
        
        enum CodingKeys: String, CodingKey {
            case login
            case avatarUrl = "avatar_url"
        }
    }
    
    func getUpdateDateString() -> String? {
        // GitHubAPIの更新日文字列は"yyyy-MM-ddThh~"のように'T'で日付と時刻を区切るようにフォーマットされている
        guard let dateString = self.updatedAt.split(separator: "T").first else {
            print("failed split \(self.updatedAt)")
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        // 一度Dateに変換
        guard let date = dateFormatter.date(from: String(dateString)) else {
            print("failed date format \(String(dateString))")
            return nil
        }
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        return dateFormatter.string(from: date)
    }
}

// Repositoryでは画像のURLしか保持していないため、画像自体も一緒に管理するための構造を用意
struct RepositoryInfomation {
    let repository: Repository
    var image: UIImage?
    var isFavorite: Bool
    
    init(repository: Repository, image: UIImage?, isFavorite: Bool = false) {
        self.repository = repository
        self.image = image
        self.isFavorite = isFavorite
    }
    
    func getSwitchedFavorite() -> Self {
        let new = RepositoryInfomation(repository: repository, image: image, isFavorite: !isFavorite)
        return new
    }
}
