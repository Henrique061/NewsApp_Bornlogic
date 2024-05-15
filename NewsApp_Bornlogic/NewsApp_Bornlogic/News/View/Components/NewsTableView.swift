//
//  NewsTableView.swift
//  NewsApp_Bornlogic
//
//  Created by Henrique Assis on 15/05/24.
//

import Foundation
import UIKit

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
