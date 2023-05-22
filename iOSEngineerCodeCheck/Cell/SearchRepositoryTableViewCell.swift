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
    
    func configure(_ info: RepositoryInfomation?) {
        iconImageView.image = info?.image
        ownerNameLabel.text = info?.repository.owner.login
        repositoryNameLabel.text = info?.repository.name
        languageLabel.text = info?.repository.language
        descriptionLabel.text = info?.repository.description
    }
}
