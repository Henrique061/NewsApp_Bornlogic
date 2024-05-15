//
//  NewsVM.swift
//  NewsApp_Bornlogic
//
//  Created by Henrique Assis on 15/05/24.
//

import Foundation
import UIKit

class NewsVM {
    public var news: News?
    private(set) var filteredArticles: [Article] = []
    
    //MARK: SEARCH
    public func isInSearchMode(_ searchController: UISearchController) -> Bool {
        let isActive = searchController.isActive
        let searchText = searchController.searchBar.text ?? String()
        
        return isActive && !searchText.isEmpty
    }
    
    public func updateSearchController(text searchBarText: String?, clickedSearch: Bool = true, completion: @escaping () -> Void) {
        // para evitar atualizacao da table ao clicar na search bar pela primeira vez
        // e de dar reload ao clicar quando a search estiver sem texto
        if !clickedSearch { return }
        if self.filteredArticles == news?.articles && searchBarText?.isEmpty ?? true { return }
        
        self.filteredArticles = news?.articles ?? []
        
        if let searchText = searchBarText?.lowercased() {
            guard !searchText.isEmpty else { completion(); return }
            
            self.filteredArticles = self.filteredArticles.filter({ article in
                article.title.lowercased().contains(searchText) ||
                article.author?.lowercased().contains(searchText) ?? false ||
                article.description.lowercased().contains(searchText)
            })
        }

        completion()
    }
}
