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
    var news: News?
    private var clickedSearch = false
    
    private(set) var filteredArticles: [Article] = []
    
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

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchController.searchBar.delegate = self
        
        self.setupSearchController()
        
        NewsCall().getNews { news in
            self.news = news
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
}

//MARK: - SEARCH FUNCS
extension NewsView: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        self.updateSearchController(text: searchController.searchBar.text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.updateSearchController(text: String())
    }
}

extension NewsView {
    public func isInSearchMode(_ searchController: UISearchController) -> Bool {
        let isActive = searchController.isActive
        let searchText = searchController.searchBar.text ?? String()
        
        return isActive && !searchText.isEmpty
    }
    
    public func updateSearchController(text searchBarText: String?) {
        // para evitar atualizacao da table ao clicar na search bar pela primeira vez
        // e de dar reload ao clicar quando a search estiver sem texto
        if !clickedSearch { clickedSearch = true; return }
        if self.filteredArticles == news?.articles && searchBarText?.isEmpty ?? true { return }
        
        self.filteredArticles = news?.articles ?? []
        
        if let searchText = searchBarText?.lowercased() {
            guard !searchText.isEmpty else { self.tableView.reloadData(); return }
            
            self.filteredArticles = self.filteredArticles.filter({ article in
                article.title.lowercased().contains(searchText) ||
                article.author?.lowercased().contains(searchText) ?? false ||
                article.description.lowercased().contains(searchText)
            })
        }

        self.tableView.reloadData()
    }
}

//MARK: - TABLE VIEW
extension NewsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let inSearchMode = self.isInSearchMode(self.searchController)
        return inSearchMode ? self.filteredArticles.count : self.news?.articles.count ?? 0
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
        
        let inSearchMode = self.isInSearchMode(self.searchController)
        
        let article = inSearchMode ? self.filteredArticles[indexPath.section] : self.news?.articles[indexPath.section]
        
        cell.configureArticle(with: article ?? standardArticle)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    //MARK: NAVIGATE SCREEN
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let standardArticle = Article(source: ArticleSource(id: "", name: ""), title: "", description: "", url: "", publishedAt: "", content: "")
        let inSearchMode = self.isInSearchMode(self.searchController)
        
        let articleView = inSearchMode ? 
            ArticleView(article: self.filteredArticles[indexPath.section]) :
            ArticleView(article: self.news?.articles[indexPath.section] ?? standardArticle)
        
        self.navigationController?.pushViewController(articleView, animated: true)
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
}
