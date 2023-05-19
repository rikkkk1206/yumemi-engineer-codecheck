//
//  RepositoryDetailPresenter.swift
//  iOSEngineerCodeCheck
//
//  Created by RIKU on 2023/05/19.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import UIKit

protocol RepositoryDetailPresenterInput {
    var repository: Repository { get set }
    func viewDidLoad()
}

protocol RepositoryDetailPresenterOutput: AnyObject {
    func setLabelText()
    func setAvatarImage(image: UIImage)
}

final class RepositoryDetailPresenter: RepositoryDetailPresenterInput {
    
    private weak var view: RepositoryDetailPresenterOutput!
    private var model: RepositoryDetailModelInput
    init(repository: Repository, view: RepositoryDetailPresenterOutput, model: RepositoryDetailModelInput) {
        self.repository = repository
        self.view = view
        self.model = model
    }
    
    // MARK: RepositoryDetailPresenterInput
    
    var repository: Repository
    
    func viewDidLoad() {
        view.setLabelText()
        // アイコンはurlしか保持していないため、urlから画像を取ってくる
        model.fetchAvatarImage(
            with: repository.owner.avatarUrl,
            completion: { [weak self] avatarImage in
                DispatchQueue.main.async {
                    // UI更新なのでメインスレッド
                    self?.view.setAvatarImage(image: avatarImage)                    
                }
            })
    }
}
