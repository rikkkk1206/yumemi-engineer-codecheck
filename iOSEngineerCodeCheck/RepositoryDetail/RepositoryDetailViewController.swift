//
//  RepositoryDetailViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class RepositoryDetailViewController: UIViewController {
    
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
        if let language = presenter.repository.language {
            languageLabel.text = "Written in \(language)"
        } else {
            languageLabel.text = ""
            print("repository.language is nil")
        }
        starsLabel.text = "\(presenter.repository.stargazersCount) stars"
        watchersLabel.text = "\(presenter.repository.watchersCount) watchers"
        forksLabel.text = "\(presenter.repository.forksCount) forks"
        openIssuesLabel.text = "\(presenter.repository.openIssuesCount) open issues"
    }
    
    func setAvatarImage(image: UIImage) {
        imageView.image = image
    }
}
