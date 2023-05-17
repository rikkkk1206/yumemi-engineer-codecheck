//
//  DetailViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: @IBOutlet
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var watchersLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var openIssuesLabel: UILabel!
    
    // MARK: Public Variables
    
    var repository: [String: Any] = [:]
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRepositoryData()
    }
    
    // MARK: Private Functions
    
    private func setRepositoryData() {
        if let language = repository["language"] as? String {
            languageLabel.text = "Written in \(language)"
        } else {
            print("failed cast repository.language")
        }
        if let stargazersCount = repository["stargazers_count"] as? Int {
            starsLabel.text = "\(stargazersCount) stars"
        } else {
            print("failed cast repository.stargazers_count")
        }
        if let wachersCount = repository["wachers_count"] as? Int {
            watchersLabel.text = "\(wachersCount) watchers"
        } else {
            print("failed cast repository.wachers_count")
        }
        if let forksCount = repository["forks_count"] as? Int {
            forksLabel.text = "\(forksCount) forks"
        } else {
            print("failed cast repository.forks_count")
        }
        if let openIssuesCount = repository["open_issues_count"] as? Int {
            openIssuesLabel.text = "\(openIssuesCount) open issues"
        } else {
            print("failed cast repository.open_issues_count")
        }
        getAvatarImage() { image in
            DispatchQueue.main.async {
                // UI更新はメインスレッドで行う必要がある
                self.imageView.image = image
            }
        }
    }
    
    private func getAvatarImage(_ completion: @escaping (UIImage) -> Void) {
        titleLabel.text = repository["full_name"] as? String
        if let owner = repository["owner"] as? [String: Any],
           let avatarUrl = owner["avatar_url"] as? String {
            guard let url = URL(string: avatarUrl) else {
                print("currentUrlString is invalid")
                return
            }
            URLSession.shared.dataTask(with: url) { (data, res, err) in
                if let data = data,
                   let image = UIImage(data: data) {
                    completion(image)
                }
                if let err = err {
                    print(err)
                }
            }.resume()
        }
    }
}
