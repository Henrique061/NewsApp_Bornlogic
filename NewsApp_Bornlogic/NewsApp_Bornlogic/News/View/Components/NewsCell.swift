//
//  NewsCell.swift
//  NewsApp_Bornlogic
//
//  Created by Henrique Assis on 13/05/24.
//

import Foundation
import UIKit

class NewsCell: UITableViewCell {
    static let identifier = "NewsCell"
    private(set) var article: Article?
    public var imageToSend = UIImage()
    
    //MARK: - UI COMPONENTS
    private let articleImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        
        return image
    }()
    
    private let articleTitle: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = false
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        
        return label
    }()
    
    private let articleAuthor: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = false
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        
        return label
    }()
    
    private let articleDescription: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 3
        
        return label
    }()
    
    //MARK: - INIT
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUi()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - FUNCS
    public func configureArticle(with article: Article) {
        self.article = article
        
        // pegando a imagem pela url
        let imageUrl = URL(string: article.urlToImage ?? "")
        if let url = imageUrl {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {return}
                
                DispatchQueue.main.async {
                    self.articleImage.image = UIImage(data: data)
                    self.imageToSend = self.articleImage.image ?? UIImage()
                }
            }.resume()
        }
        
        self.articleTitle.text = self.article?.title
        self.articleAuthor.text = "Por: \(self.article?.author ?? "Anônimo")"
        self.articleDescription.text = self.article?.description
    }
    
    //MARK: - SETUP UI
    private func setupUi() {
        self.addSubview(self.articleTitle)
        self.addSubview(self.articleImage)
        self.addSubview(self.articleAuthor)
        self.addSubview(self.articleDescription)
        
        self.articleTitle.translatesAutoresizingMaskIntoConstraints = false
        self.articleImage.translatesAutoresizingMaskIntoConstraints = false
        self.articleAuthor.translatesAutoresizingMaskIntoConstraints = false
        self.articleDescription.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // imagem
            self.articleImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.articleImage.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            self.articleImage.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25),
            self.articleImage.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.75),
            
            // titulo
            self.articleTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            self.articleTitle.leadingAnchor.constraint(equalTo: self.articleImage.trailingAnchor, constant: 16),
            self.articleTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            // autor
            self.articleAuthor.topAnchor.constraint(equalTo: self.articleTitle.bottomAnchor, constant: 5),
            self.articleAuthor.leadingAnchor.constraint(equalTo: self.articleImage.trailingAnchor, constant: 16),
            self.articleAuthor.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            // descricao
            self.articleDescription.topAnchor.constraint(equalTo: self.articleAuthor.bottomAnchor, constant: 5),
            self.articleDescription.leadingAnchor.constraint(equalTo: self.articleImage.trailingAnchor, constant: 16),
            self.articleDescription.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
        ])
    }
}
