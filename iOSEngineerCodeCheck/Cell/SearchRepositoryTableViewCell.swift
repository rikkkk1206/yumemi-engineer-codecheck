//
//  SearchRepositoryTableViewCell.swift
//  iOSEngineerCodeCheck
//
//  Created by RIKU on 2023/05/22.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import UIKit

class SearchRepositoryTableViewCell: UITableViewCell {
    
    static let identifier = "SearchRepositoryTableViewCell"

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var repositoryNameLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var starsCountLabel: UILabel!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        favoriteButton.setImage(UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration.preferringMulticolor()), for: .normal)
        favoriteButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration.preferringMulticolor()), for: .selected)
    }
    
    func configure(_ info: RepositoryInfomation?) {
        guard let info = info else {
            print("RepositoryInfomation is nil in SearchRepositoryTableViewCell.configure")
            return
        }
        iconImageView.image = info.image
        ownerNameLabel.text = info.repository.owner.login
        repositoryNameLabel.text = info.repository.name
        languageLabel.text = info.repository.language
        descriptionLabel.text = info.repository.description
        starsCountLabel.text = String(info.repository.stargazersCount)
        if let updatedDate = info.repository.getUpdateDateString() {
            lastUpdateLabel.text = "Updated \(updatedDate)"
        }
        
        favoriteButton.isSelected = info.isFavorite
    }
    
    func addTargetFavoriteButton(_ target: Any?, _ selector: Selector, tag: Int) {
        favoriteButton.tag = tag
        favoriteButton.addTarget(target, action: selector, for: .touchUpInside)
    }
}
