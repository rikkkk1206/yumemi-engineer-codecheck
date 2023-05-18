//
//  SearchRepositoryPresenter.swift
//  iOSEngineerCodeCheck
//
//  Created by RIKU on 2023/05/18.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

protocol SearchRepositoryPresenterInput {
    var numberOfRepositories: Int { get }
    func repository(forRow row: Int) -> Repository?
    func didSelectRow(at indexPath: IndexPath)
    func didClickSearchButton(text: String?)
    func didChangeInputText()
}

// PresenterがViewに描画指示をするためのインターフェイス
protocol SearchRepositoryPresenterOutput: AnyObject {
    func updateRepositories(_ repositories: [Repository])
    func transitionRepositoryDetail(_ repository: Repository)
}

final class SearchRepositoryPresenter: SearchRepositoryPresenterInput {
    
    private(set) var repositories: [Repository] = []
    
    private weak var view: SearchRepositoryPresenterOutput!
    private var model: SearchRepositoryModelInput
    
    init(view: SearchRepositoryPresenterOutput, model: SearchRepositoryModelInput) {
        self.view = view
        self.model = model
    }
    
    // MARK: SearchRepositoryPresenterInput
    
    var numberOfRepositories: Int {
        return repositories.count
    }
    
    func repository(forRow row: Int) -> Repository? {
        guard row < numberOfRepositories else { return nil }
        return repositories[row]
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        guard let repository = repository(forRow: indexPath.row) else { return }
        view.transitionRepositoryDetail(repository)
    }
    
    func didClickSearchButton(text: String?) {
        guard let inputText = text,
              !inputText.isEmpty else { return }
        
        model.fetchRepository(inputText: inputText) { [weak self] repositories in
            self?.repositories = repositories
            
            DispatchQueue.main.async {
                self?.view.updateRepositories(repositories)
            }
        }
    }
    
    func didChangeInputText() {
        model.searchingSessionCancel()
    }
}
