//
//  HomeViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {
    
    // MARK: @IBOutlet
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: Fileprivate Variables
    
    fileprivate var searchRepositories: URLSessionTask?
    fileprivate var inputText: String = ""
    fileprivate var repositories: [[String: Any]] = []
    fileprivate var selectedIndex: Int? = nil
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.text = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail",
           let vc = segue.destination as? DetailViewController,
           let repository = getSelectedRepository() {
            // 選択したリポジトリの情報を遷移先に渡す
            vc.repository = repository
        }
    }
    
    // MARK: UITableViewController
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let repository = repositories[indexPath.row]
        if let fullName = repository["full_name"] as? String {
            cell.textLabel?.text = fullName
        } else {
            print("failed cast repository.full_name")
        }
        if let language = repository["language"] as? String {
            cell.detailTextLabel?.text = language
        } else {
            print("failed cast repository.language")
        }
        cell.tag = indexPath.row
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // リポジトリを選択したときに呼ばれる
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
    }
    
    // MARK: Private Functions
    
    private func getSelectedRepository() -> [String: Any]? {
        guard let selectedIndex = selectedIndex else {
            print("selectedIndex is nil")
            return nil
        }
        guard repositories.indices.contains(selectedIndex) else {
            print("selectedIndex is out of repositories range")
            return nil
        }
        return repositories[selectedIndex]
    }
}

// MARK: - UISearchBarDelegate

extension HomeViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.text = "" // 初期のテキストを削除
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchRepositories?.cancel()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let inputText = searchBar.text else {
            print("searchBar.text is nil")
            return
        }
        if !inputText.isEmpty {
            let urlString = "https://api.github.com/search/repositories?q=\(inputText)"
            guard let url = URL(string: urlString) else {
                print("urlString is invalid")
                return
            }
            searchRepositories = URLSession.shared.dataTask(with: url) { (data, res, err) in
                if let data = data {
                    do {
                        if let obj = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                           let items = obj["items"] as? [[String: Any]] {
                            self.repositories = items
                            DispatchQueue.main.async {
                                // tableViewの更新はメインスレッドで行う必要がある
                                self.tableView.reloadData()
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
                if let err = err {
                    print(err)
                }
            }
            // APIへの問い合わせを実行
            searchRepositories?.resume()
        }
    }
}
