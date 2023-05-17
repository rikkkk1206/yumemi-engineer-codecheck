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
    fileprivate var inputText: String!
    fileprivate var currentUrlString: String!
    
    // MARK: Public Variables
    
    var repositories: [[String: Any]] = []
    var selectedIndex: Int!
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.text = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail" {
            let vc = segue.destination as! DetailViewController
            vc.homeViewController = self
        }
    }
    
    // MARK: UITableViewController
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let repository = repositories[indexPath.row]
        cell.textLabel?.text = repository["full_name"] as? String ?? ""
        cell.detailTextLabel?.text = repository["language"] as? String ?? ""
        cell.tag = indexPath.row
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // リポジトリを選択したときに呼ばれる
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
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
        inputText = searchBar.text!
        if inputText.count != 0 {
            currentUrlString = "https://api.github.com/search/repositories?q=\(inputText!)"
            searchRepositories = URLSession.shared.dataTask(with: URL(string: currentUrlString)!) { (data, res, err) in
                if let obj = try! JSONSerialization.jsonObject(with: data!) as? [String: Any],
                   let items = obj["items"] as? [[String: Any]] {
                    self.repositories = items
                    DispatchQueue.main.async {
                        // tableViewの更新はメインスレッドで行う必要がある
                        self.tableView.reloadData()
                    }
                }
            }
            // APIへの問い合わせを実行
            searchRepositories?.resume()
        }
    }
}
