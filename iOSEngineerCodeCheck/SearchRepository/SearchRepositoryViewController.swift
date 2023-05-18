//
//  SearchRepositoryViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

final class SearchRepositoryViewController: UITableViewController {
    
    // MARK: @IBOutlet
    
    @IBOutlet private weak var searchBar: UISearchBar!
    
    // MARK: Private Variables
    
    private var presenter: SearchRepositoryPresenterInput!
    
    func inject(presenter: SearchRepositoryPresenterInput) {
        self.presenter = presenter
    }
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.text = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
        
        let model = SearchRepositoryModel()
        let presenter = SearchRepositoryPresenter(view: self, model: model)
        inject(presenter: presenter)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "Detail",
//           let vc = segue.destination as? RepositoryDetailViewController,
//           let repository = getSelectedRepository() {
//            // 選択したリポジトリの情報を遷移先に渡す
//            vc.repository = repository
//        }
//    }
    
    // MARK: UITableViewController
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRepositories
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Repository", for: indexPath)
        let repository = presenter.repository(forRow: indexPath.row)
        cell.textLabel?.text = repository?.fullName
        cell.detailTextLabel?.text = repository?.language
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
        searchBar.text = "" // 初期のテキストを削除
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.didChangeInputText()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.didClickSearchButton(text: searchBar.text)
    }
}

// MARK: - SearchRepositoryPresenterOutput

extension SearchRepositoryViewController: SearchRepositoryPresenterOutput {
    
    func updateRepositories(_ repositories: [Repository]) {
        tableView.reloadData()
    }
    
    func transitionRepositoryDetail(_ repository: Repository) {
        performSegue(withIdentifier: "Detail", sender: self)
    }
}
