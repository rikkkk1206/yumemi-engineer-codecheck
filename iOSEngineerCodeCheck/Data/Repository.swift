//
//  Repository.swift
//  iOSEngineerCodeCheck
//
//  Created by RIKU on 2023/05/18.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

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
    
    let fullName: String
    let language: String?   // languageはnullの場合があったためOptional
    let stargazersCount: Int
    let watchersCount: Int
    let forksCount: Int
    let openIssuesCount: Int
    let owner: Owner
    
    enum CodingKeys: String, CodingKey {
        
        case fullName = "full_name"
        case language
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
        case owner
    }
    
    struct Owner: Decodable {
        
        let avatarUrl: String
        
        enum CodingKeys: String, CodingKey {
            
            case avatarUrl = "avatar_url"
        }
    }
}
