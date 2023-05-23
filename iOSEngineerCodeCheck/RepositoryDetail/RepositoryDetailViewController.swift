//
//  RepositoryDetailViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class RepositoryDetailViewController: UIViewController {
    
    // MARK: Static
    
    static let segueIdentifier = "Detail"
    
    // MARK: Public Functions
    
    func inject(presenter: RepositoryDetailPresenterInput) {
        self.presenter = presenter
    }
    
    // MARK: @IBOutlet
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var starsLabel: UILabel!
    @IBOutlet private weak var watchersLabel: UILabel!
    @IBOutlet private weak var forksLabel: UILabel!
    @IBOutlet private weak var openIssuesLabel: UILabel!
    
    // MARK: Private Variables
    
    private var presenter: RepositoryDetailPresenterInput!
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 遷移後すぐに表示内容をセットする
        presenter.viewDidLoad()
    }
}

extension RepositoryDetailViewController: RepositoryDetailPresenterOutput {
    
    func setLabelText() {
        let repository = presenter.repositoryInfo.repository
        titleLabel.text = repository.fullName
        if let language = repository.language {
            languageLabel.text = "Written in \(language)"
        } else {
            languageLabel.text = ""
            print("repository.language is nil")
        }
        starsLabel.text = "\(repository.stargazersCount) stars"
        watchersLabel.text = "\(repository.watchersCount) watchers"
        forksLabel.text = "\(repository.forksCount) forks"
        openIssuesLabel.text = "\(repository.openIssuesCount) open issues"
    }
    
    func setAvatarImage(image: UIImage) {
        imageView.image = image
    }
}
