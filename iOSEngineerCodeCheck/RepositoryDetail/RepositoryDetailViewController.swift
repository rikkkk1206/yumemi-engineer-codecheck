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
    
    func inject(presenter: RepositoryDetailPresenterInput, parentPresenter: SearchRepositoryPresenterInput) {
        self.presenter = presenter
        self.parentPresenter = parentPresenter
    }
    
    // MARK: @IBOutlet
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var lastUpdateLabel: UILabel!
    @IBOutlet private weak var starsLabel: UILabel!
    @IBOutlet private weak var watchersLabel: UILabel!
    @IBOutlet private weak var forksLabel: UILabel!
    @IBOutlet private weak var openIssuesLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    // MARK: Private Variables
    
    private var presenter: RepositoryDetailPresenterInput!
    
    private weak var parentPresenter: SearchRepositoryPresenterInput!
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFavoriteButton()
        // 遷移後すぐに表示内容をセットする
        presenter.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func setupFavoriteButton() {
        favoriteButton.setImage(UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration.preferringMulticolor()), for: .normal)
        favoriteButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration.preferringMulticolor()), for: .selected)
    }
    
    @IBAction func tappedFavoriteButton(_ sender: Any) {
        presenter.didTapFavoriteButton()
        // 検索画面にも反映させる
        parentPresenter.didTapFavoriteButton(at: parentPresenter.selectedRow)
    }
}

extension RepositoryDetailViewController: RepositoryDetailPresenterOutput {
    
    func updateProperties() {
        let info = presenter.repositoryInfo
        let repository = info.repository
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
        
        imageView.image = info.image
        
        favoriteButton.isSelected = info.isFavorite
    }
}
