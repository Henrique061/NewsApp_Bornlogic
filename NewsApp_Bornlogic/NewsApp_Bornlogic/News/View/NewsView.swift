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
    
    //MARK: - UI
    let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        
        tv.register(NewsCell.self, forCellReuseIdentifier: NewsCell.identifier)
        
        return tv
    }()
    
    //MARK: - VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        NewsCall().getNews { news in
            self.news = news
            self.configureTable()
        }
    }
    
    //MARK: - FUNCS
    func configureTable() {
        view.addSubview(self.tableView)
        
        self.tableView.frame = self.view.bounds
        self.tableView.reloadData()
    }
}

//MARK: - TABLE VIEW
extension NewsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.news?.articles.count ?? 1
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
        
        let article = self.news?.articles[indexPath.section]
        cell.configureArticle(with: article ?? Article(source: ArticleSource(id: "", name: ""), title: "", description: "", url: "", publishedAt: "", content: ""))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
