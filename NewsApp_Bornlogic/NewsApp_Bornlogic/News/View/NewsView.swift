//
//  NewsView.swift
//  NewsApp_Bornlogic
//
//  Created by Henrique Assis on 13/05/24.
//

import Foundation
import UIKit

class NewsView: UIViewController {
    //MARK: - VARIABLES
    var newsVm = NewsVM()
    private var clickedSearch = false

    
    //MARK: - UI
    let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        
        tv.register(NewsCell.self, forCellReuseIdentifier: NewsCell.identifier)
        
        return tv
    }()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: - VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "News"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle"), style: .plain, target: self, action: #selector(onTapOrder))

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchController.searchBar.delegate = self
        
        self.setupSearchController()
        
        NewsCall().getNews { news in
            self.newsVm.news = news
            self.configureTable()
        }
    }
    
    //MARK: - FUNCS
    private func configureTable() {
        view.addSubview(self.tableView)
        
        self.tableView.frame = self.view.bounds
        self.tableView.reloadData()
    }
    
    private func setupSearchController() {
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.placeholder = "Procurar Notícias"
        
        self.navigationItem.searchController = self.searchController
        self.definesPresentationContext = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    @objc private func onTapOrder() {
        
    }
}

//MARK: - SEARCH FUNCS
extension NewsView: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        self.newsVm.updateSearchController(text: searchController.searchBar.text, clickedSearch: self.clickedSearch, completion: {
            self.tableView.reloadData()
        })
        
        if self.clickedSearch == false { self.clickedSearch = true }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.newsVm.updateSearchController(text: String(), completion: {
            self.tableView.reloadData()
        })
    }
}

extension NewsView {
    
}

//MARK: - TABLE VIEW
extension NewsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let inSearchMode = self.newsVm.isInSearchMode(self.searchController)
        return inSearchMode ? self.newsVm.filteredArticles.count : self.newsVm.news?.articles.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.identifier, for: indexPath) as? NewsCell else {
            fatalError("Não foi possível realizar o dequeue da NewsCell na NewsView")
        }
        let standardArticle = Article(source: ArticleSource(id: "", name: ""), title: "", description: "", url: "", publishedAt: "", content: "")
        
        let inSearchMode = self.newsVm.isInSearchMode(self.searchController)
        
        let article = inSearchMode ? self.newsVm.filteredArticles[indexPath.section] : self.newsVm.news?.articles[indexPath.section]
        
        cell.configureArticle(with: article ?? standardArticle)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    //MARK: NAVIGATE SCREEN
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let standardArticle = Article(source: ArticleSource(id: "", name: ""), title: "", description: "", url: "", publishedAt: "", content: "")
        let inSearchMode = self.newsVm.isInSearchMode(self.searchController)
        
        let articleView = inSearchMode ? 
        ArticleView(article: self.newsVm.filteredArticles[indexPath.section]) :
        ArticleView(article: self.newsVm.news?.articles[indexPath.section] ?? standardArticle)
        
        self.navigationController?.pushViewController(articleView, animated: true)
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
}
