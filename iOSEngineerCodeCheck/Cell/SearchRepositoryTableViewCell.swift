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
        if let updatedDate = getUpdateDate(info.repository.updatedAt) {
            lastUpdateLabel.text = "Updated \(updatedDate)"
        }
    }
    
    private func getUpdateDate(_ updateAt: String) -> String? {
        guard let dateString = updateAt.split(separator: "T").first else {
            print("failed split \(updateAt)")
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        guard let date = dateFormatter.date(from: String(dateString)) else {
            print("failed date format \(String(dateString))")
            return nil
        }
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        return dateFormatter.string(from: date)
    }
}
