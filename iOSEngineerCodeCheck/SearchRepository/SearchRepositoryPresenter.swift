//
//  SearchRepositoryPresenter.swift
//  iOSEngineerCodeCheck
//
//  Created by RIKU on 2023/05/18.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import UIKit

protocol SearchRepositoryPresenterInput: AnyObject {
    var numberOfRepositories: Int { get }
    var selectedRow: Int { get set }
    var enableEditingSearchBar: Bool { get }
    func repositoryInfomation(forRow row: Int) -> RepositoryInfomation?
    func didSelectRow(at indexPath: IndexPath)
    func didClickSearchButton(text: String?)
    func didTapFavoriteButton(at index: Int)
}

// PresenterがViewに描画指示をするためのインターフェイス
protocol SearchRepositoryPresenterOutput: AnyObject {
    func updateRepositories()
    func transitionRepositoryDetail(_ repositoryInfo: RepositoryInfomation)
    func toggleIndicator(_ isHidden: Bool)
}

final class SearchRepositoryPresenter: SearchRepositoryPresenterInput {
    
    private(set) var repositoryInfos: [RepositoryInfomation] = []
    
    private weak var view: SearchRepositoryPresenterOutput!
    private var model: SearchRepositoryModelInput
    
    init(view: SearchRepositoryPresenterOutput, model: SearchRepositoryModelInput) {
        self.view = view
        self.model = model
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didSetRunningFetchRepositoryTask),
            name: SearchRepositoryModel.didSetRunningFetchRepositoryTask,
            object: nil)
    }
    
    // MARK: SearchRepositoryPresenterInput
    
    var enableEditingSearchBar: Bool {
        return !model.runningFetchRepositoryTask
    }
    
    var numberOfRepositories: Int {
        return repositoryInfos.count
    }
    
    var selectedRow: Int = 0
    
    func repositoryInfomation(forRow row: Int) -> RepositoryInfomation? {
        guard row < numberOfRepositories else { return nil }
        return repositoryInfos[row]
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        selectedRow = indexPath.row
        guard let repository = repositoryInfomation(forRow: selectedRow) else { return }
        view.transitionRepositoryDetail(repository)
    }
    
    func didClickSearchButton(text: String?) {
        guard let inputText = text,
              !inputText.isEmpty else { return }
        
        // リポジトリ情報と画像情報が全て揃ってから検索結果に反映したいため、同期的に取得処理を行う
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
    
    func didTapFavoriteButton(at index: Int) {
        guard let repositoryInfo = repositoryInfomation(forRow: index) else { return }
        repositoryInfos[index] = repositoryInfo.getSwitchedFavorite()
        view.updateRepositories()
    }
    
    // MARK: Observer
    
    @objc private func didSetRunningFetchRepositoryTask(notification: Notification) {
        guard let isRunning = notification.object as? Bool else {
            print("failed downcast notification.object")
            return
        }
        DispatchQueue.main.async { [weak self] in
            self?.view.toggleIndicator(!isRunning)
        }
    }
}
