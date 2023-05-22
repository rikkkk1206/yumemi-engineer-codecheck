//
//  SearchRepositoryPresenter.swift
//  iOSEngineerCodeCheck
//
//  Created by RIKU on 2023/05/18.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import UIKit

protocol SearchRepositoryPresenterInput {
    var numberOfRepositories: Int { get }
    var enableEditingSearchBar: Bool { get }
    func repositoryInfomation(forRow row: Int) -> RepositoryInfomation?
    func didSelectRow(at indexPath: IndexPath)
    func didClickSearchButton(text: String?)
}

// PresenterがViewに描画指示をするためのインターフェイス
protocol SearchRepositoryPresenterOutput: AnyObject {
    func updateRepositories()
    func transitionRepositoryDetail(_ repositoryInfo: RepositoryInfomation)
}

final class SearchRepositoryPresenter: SearchRepositoryPresenterInput {
    
    private(set) var repositoryInfos: [RepositoryInfomation] = []
    
    private weak var view: SearchRepositoryPresenterOutput!
    private var model: SearchRepositoryModelInput
    
    init(view: SearchRepositoryPresenterOutput, model: SearchRepositoryModelInput) {
        self.view = view
        self.model = model
    }
    
    // MARK: SearchRepositoryPresenterInput
    
    var enableEditingSearchBar: Bool {
        return !model.runningUrlSessionTask
    }
    
    var numberOfRepositories: Int {
        return repositoryInfos.count
    }
    
    func repositoryInfomation(forRow row: Int) -> RepositoryInfomation? {
        guard row < numberOfRepositories else { return nil }
        return repositoryInfos[row]
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        guard let repository = repositoryInfomation(forRow: indexPath.row) else { return }
        view.transitionRepositoryDetail(repository)
    }
    
    func didClickSearchButton(text: String?) {
        guard let inputText = text,
              !inputText.isEmpty else { return }
        
        Task { [weak self] in
            guard let repositoryInfos = await self?.model.fetchRepositoryInfomation(inputText: inputText) else {
                return
            }
            self?.repositoryInfos = repositoryInfos
            
            DispatchQueue.main.async { [weak self] in
                self?.view.updateRepositories()
            }
        }
    }
}
