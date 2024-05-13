//
//  News.swift
//  NewsApp_Bornlogic
//
//  Created by Henrique Assis on 11/05/24.
//

import Foundation

struct News : Codable, Equatable {
    var status: String
    var totalResults: Int
    var articles: [Article]
}

struct Article : Codable, Equatable {
    var source: ArticleSource
    var author: String?
    var title: String
    var description: String
    var url: String
    var urlToImage: String?
    var publishedAt: String
    var content: String
}

struct ArticleSource : Codable, Equatable {
    var id: String?
    var name: String
}
