//
//  SearchRepositoryViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

final class SearchRepositoryViewController: UITableViewController {
    
    // MARK: Public Functions
    
    func inject(presenter: SearchRepositoryPresenterInput) {
        self.presenter = presenter
    }
    
    // MARK: @IBOutlet
    
    @IBOutlet private weak var searchBar: UISearchBar!
    
    // MARK: Private Variables
    
    private var presenter: SearchRepositoryPresenterInput!
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // カスタムセルをtableViewに登録
        tableView.register(UINib(nibName: SearchRepositoryTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: SearchRepositoryTableViewCell.identifier)
        
        let model = SearchRepositoryModel()
        let presenter = SearchRepositoryPresenter(view: self, model: model)
        inject(presenter: presenter)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == RepositoryDetailViewController.segueIdentifier,
           let repositoryInfo = sender as? RepositoryInfomation {
            // 選択したリポジトリの詳細画面へ値渡し
            guard let view = segue.destination as? RepositoryDetailViewController else {
                print("failed make RepositoryDetailViewController")
                return
            }
            let model = RepositoryDetailModel()
            let presenter = RepositoryDetailPresenter(
                repositoryInfo: repositoryInfo,
                view: view,
                model: model)
            view.inject(presenter: presenter)
        }
    }
    
    // MARK: UITableViewController
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRepositories
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchRepositoryTableViewCell.identifier, for: indexPath) as? SearchRepositoryTableViewCell else {
            fatalError("The dequeued cell is not an instance of SearchRepositoryTableViewCell")
        }
        cell.configure(presenter.repositoryInfomation(forRow: indexPath.row))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // リポジトリを選択したときに呼ばれる
        presenter.didSelectRow(at: indexPath)
    }
}

// MARK: - UISearchBarDelegate

extension SearchRepositoryViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // 検索バーの文字を編集可能かどうか
        return presenter.enableEditingSearchBar
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 検索開始
        presenter.didClickSearchButton(text: searchBar.text)
    }
}

// MARK: - SearchRepositoryPresenterOutput

extension SearchRepositoryViewController: SearchRepositoryPresenterOutput {
    
    func updateRepositories() {
        tableView.reloadData()
    }
    
    func transitionRepositoryDetail(_ repository: RepositoryInfomation) {
        performSegue(withIdentifier: RepositoryDetailViewController.segueIdentifier, sender: repository)
    }
}
