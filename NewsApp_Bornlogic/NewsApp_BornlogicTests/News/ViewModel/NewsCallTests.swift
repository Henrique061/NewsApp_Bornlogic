//
//  NewsCallTests.swift
//  NewsApp_BornlogicTests
//
//  Created by Henrique Assis on 13/05/24.
//

import XCTest
@testable import NewsApp_Bornlogic

final class NewsCallTests: XCTestCase {
    //MARK: SETUP
    var newsCall: NewsCall!
    
    class MockNetworkNews: NetworkNews {
        override func fetchData(completion: @escaping (News) -> Void) {
            let mockNews = News(
                status: "ok",
                totalResults: 1,
                articles: [Article(
                    source: ArticleSource(id: "none", name: "News"),
                    title: "TestTitle",
                    description: "TestDescription",
                    url: "TestURL",
                    publishedAt: "2024-04-25",
                    content: "TestContent"
                )]
            )
            
            completion(mockNews)
        }
    }
    
    override func setUpWithError() throws {
        newsCall = NewsCall(apiClient: MockNetworkNews())
    }
    
    //MARK: TESTS
    func test_getNews() {
        let newsTest = News(
            status: "ok",
            totalResults: 1,
            articles: [Article(
                source: ArticleSource(id: "none", name: "News"),
                title: "TestTitle",
                description: "TestDescription",
                url: "TestURL",
                publishedAt: "2024-04-25",
                content: "TestContent"
            )]
        )
        
        let expectation = XCTestExpectation(description: "Dados buscados com sucesso")
        
        newsCall.getNews { news in
            XCTAssertEqual(news, newsTest)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}
