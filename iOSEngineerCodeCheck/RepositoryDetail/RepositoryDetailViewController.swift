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
    @IBOutlet private weak var lastUpdateLabel: UILabel!
    @IBOutlet private weak var starsLabel: UILabel!
    @IBOutlet private weak var watchersLabel: UILabel!
    @IBOutlet private weak var forksLabel: UILabel!
    @IBOutlet private weak var openIssuesLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
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
        languageLabel.text = repository.language
        if let updatedDate = repository.getUpdateDateString() {
            lastUpdateLabel.text = "Updated \(updatedDate)"
        }
        starsLabel.text = String(repository.stargazersCount)
        watchersLabel.text = String(repository.watchersCount)
        forksLabel.text = String(repository.forksCount)
        openIssuesLabel.text = String(repository.openIssuesCount)
        descriptionLabel.text = repository.description
    }
    
    func setAvatarImage(image: UIImage) {
        imageView.image = image
    }
}
