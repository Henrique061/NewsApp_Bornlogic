//
//  NewsCollectionView.swift
//  NewsApp_Bornlogic
//
//  Created by Henrique Assis on 15/05/24.
//

import Foundation
import UIKit

extension NewsView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let inSearchMode = self.newsVm.isInSearchMode(self.searchController)
        return inSearchMode ? self.newsVm.filteredArticles.count : self.newsVm.news?.articles.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionCell.identifier, for: indexPath) as? NewsCollectionCell else {
            fatalError("Não foi possível realizar o dequeue da NewsCell na NewsView")
        }
        let standardArticle = Article(source: ArticleSource(id: "", name: ""), title: "", description: "", url: "", publishedAt: "", content: "")
        
        let inSearchMode = self.newsVm.isInSearchMode(self.searchController)
        
         let article = inSearchMode ? self.newsVm.filteredArticles[indexPath.item] : self.newsVm.news?.articles[indexPath.item]
        
        cell.configureArticle(with: article ?? standardArticle)
        cell.setupUi()
        
        return cell
    }
    
    // navigation
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let standardArticle = Article(source: ArticleSource(id: "", name: ""), title: "", description: "", url: "", publishedAt: "", content: "")
        let inSearchMode = self.newsVm.isInSearchMode(self.searchController)
        
        let articleView = inSearchMode ?
        ArticleView(article: self.newsVm.filteredArticles[indexPath.item]) :
        ArticleView(article: self.newsVm.news?.articles[indexPath.item] ?? standardArticle)
        
        self.navigationController?.pushViewController(articleView, animated: true)
        self.collectionView.deselectItem(at: indexPath, animated: false)
    }
}

extension NewsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let wSize = self.view.frame.width / 2.35
        let hSize = self.view.frame.height / 3.25
        
        return .init(width: wSize, height: hSize)
    }
    
    // vertical spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    // horizontal spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 20, left: 20, bottom: 20, right: 20)
    }
}
