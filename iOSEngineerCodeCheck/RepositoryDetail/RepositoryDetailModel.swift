//
//  RepositoryDetailModel.swift
//  iOSEngineerCodeCheck
//
//  Created by RIKU on 2023/05/19.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import UIKit

protocol RepositoryDetailModelInput {
    func fetchAvatarImage(with urlString: String,
                          completion: @escaping (UIImage) -> ())
}

final class RepositoryDetailModel: RepositoryDetailModelInput {
    
    func fetchAvatarImage(with urlString: String, completion: @escaping (UIImage) -> ()) {
        guard let url = URL(string: urlString) else {
            print("urlString(\(urlString)) is invalid")
            return
        }
        
        URLSessionUtility.makeUrlSessionDataTask(with: url) { (data, error) in
            if let error = error {
                print("failed makeUrlSessionDataTask(\(urlString): ", error)
                return
            }
            
            if let data = data,
               let image = UIImage(data: data) {
                completion(image)
            }
        }.resume()
    }
}
