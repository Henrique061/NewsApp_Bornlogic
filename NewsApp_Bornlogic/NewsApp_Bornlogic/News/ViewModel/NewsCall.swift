//
//  NewsCall.swift
//  NewsApp_Bornlogic
//
//  Created by Henrique Assis on 11/05/24.
//

import Foundation

class NewsCall {
    let apiClient: NetworkNews
    
    init(apiClient: NetworkNews = .shared) {
        self.apiClient = apiClient
    }
    
    //MARK: PUBLIC FUNCS
    /**Faz a chamada da API e retorna o resultado numa completion**/
    public func getNews(completion: @escaping (News) -> Void) {
        apiClient.fetchData() { news in
            completion(news)
        }
    }
    
    
}
