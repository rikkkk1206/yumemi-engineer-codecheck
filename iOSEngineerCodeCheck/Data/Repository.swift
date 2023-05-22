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
    }
    
    struct Owner: Decodable {
        let login: String
        let avatarUrl: String
        
        enum CodingKeys: String, CodingKey {
            case login
            case avatarUrl = "avatar_url"
        }
    }
}

struct RepositoryInfomation {
    let repository: Repository
    var image: UIImage?
    
    init(repository: Repository, image: UIImage?) {
        self.repository = repository
        self.image = image
    }
}
