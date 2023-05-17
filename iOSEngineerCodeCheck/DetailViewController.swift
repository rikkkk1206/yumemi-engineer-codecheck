//
//  DetailViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var watchersLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var openIssuesLabel: UILabel!
    
    var homeViewController: HomeViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let repository = homeViewController.repositories[homeViewController.selectedIndex]
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
    
    func getAvatarImage(_ completion: @escaping (UIImage) -> Void) {
        let repository = homeViewController.repositories[homeViewController.selectedIndex]
        titleLabel.text = repository["full_name"] as? String
        if let owner = repository["owner"] as? [String: Any],
           let avatarUrl = owner["avatar_url"] as? String {
            URLSession.shared.dataTask(with: URL(string: avatarUrl)!) { (data, res, err) in
                let image = UIImage(data: data!)!
                completion(image)
            }.resume()
        }
    }
}
