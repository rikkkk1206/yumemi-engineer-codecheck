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
        
        let model = SearchRepositoryModel()
        let presenter = SearchRepositoryPresenter(view: self, model: model)
        inject(presenter: presenter)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == RepositoryDetailViewController.segueIdentifier,
           let repository = sender as? Repository {
            // 選択したリポジトリの詳細画面へ値渡し
            guard let view = segue.destination as? RepositoryDetailViewController else {
                print("failed make RepositoryDetailViewController")
                return
            }
            let model = RepositoryDetailModel()
            let presenter = RepositoryDetailPresenter(
                repository: repository,
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
        performSegue(withIdentifier: RepositoryDetailViewController.segueIdentifier, sender: repository)
    }
}
