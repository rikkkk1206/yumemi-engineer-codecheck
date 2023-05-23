//
//  RepositoryDetailPresenter.swift
//  iOSEngineerCodeCheck
//
//  Created by RIKU on 2023/05/19.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import UIKit

protocol RepositoryDetailPresenterInput {
    var repositoryInfo: RepositoryInfomation { get set }
    func viewDidLoad()
    func didTapFavoriteButton()
}

protocol RepositoryDetailPresenterOutput: AnyObject {
    func updateProperties()
}

final class RepositoryDetailPresenter: RepositoryDetailPresenterInput {
    
    private weak var view: RepositoryDetailPresenterOutput!
    private var model: RepositoryDetailModelInput
    init(repositoryInfo: RepositoryInfomation, view: RepositoryDetailPresenterOutput, model: RepositoryDetailModelInput) {
        self.repositoryInfo = repositoryInfo
        self.view = view
        self.model = model
    }
    
    // MARK: RepositoryDetailPresenterInput
    
    var repositoryInfo: RepositoryInfomation
    
    func viewDidLoad() {
        view.updateProperties()
    }
    
    func didTapFavoriteButton() {
        repositoryInfo = repositoryInfo.getSwitchedFavorite()
        view.updateProperties()
    }
}
