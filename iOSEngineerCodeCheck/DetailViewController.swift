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
        
        languageLabel.text = "Written in \(repository["language"] as? String ?? "")"
        starsLabel.text = "\(repository["stargazers_count"] as? Int ?? 0) stars"
        watchersLabel.text = "\(repository["wachers_count"] as? Int ?? 0) watchers"
        forksLabel.text = "\(repository["forks_count"] as? Int ?? 0) forks"
        openIssuesLabel.text = "\(repository["open_issues_count"] as? Int ?? 0) open issues"
        getAvatarImage() { image in
            DispatchQueue.main.async {
                // UI更新はメインスレッドで行う必要がある
                self.imageView.image = image
            }
        }
    }
    
    // MARK: Private Functions
    
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
