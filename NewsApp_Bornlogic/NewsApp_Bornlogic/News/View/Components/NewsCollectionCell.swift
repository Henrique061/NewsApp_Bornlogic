//
//  NewsCollectionCell.swift
//  NewsApp_Bornlogic
//
//  Created by Henrique Assis on 15/05/24.
//

import Foundation
import UIKit

class NewsCollectionCell: UICollectionViewCell {
    static let identifier = "NewsCollectionCell"
    private(set) var article: Article?
    
    //MARK: - UI COMPONENTS
    private let backgroundFrame: UIView = {
        let bg = UIView(frame: .zero)
        bg.layer.cornerRadius = 10
        bg.backgroundColor = .white
        
        return bg
    }()
    
    private let articleImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        image.contentMode = .scaleToFill
        
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
    
    //MARK: - FUNCS
    override func prepareForReuse() {
        super.prepareForReuse()
        self.articleImage.image = nil
    }
    
    public func configureArticle(with article: Article) {
        self.article = article
        
        // pegando a imagem pela url
        let imageUrl = URL(string: article.urlToImage ?? "")
        if let url = imageUrl {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {return}
                
                DispatchQueue.main.async {
                    self.articleImage.image = UIImage(data: data)
                }
            }.resume()
        } else {
            self.articleImage.image = UIImage(named: "Sem_imagem")
        }
        
        self.articleTitle.text = self.article?.title
        self.articleAuthor.text = "Por: \(self.article?.author ?? "Anônimo")"
        self.articleDescription.text = self.article?.description
    }
    
    //MARK: - SETUP UI
    public func setupUi() {
        self.addSubview(self.backgroundFrame)
        self.backgroundFrame.addSubview(self.articleImage)
        self.backgroundFrame.addSubview(self.articleTitle)
        self.backgroundFrame.addSubview(self.articleAuthor)
        self.backgroundFrame.addSubview(self.articleDescription)
        
        self.backgroundFrame.translatesAutoresizingMaskIntoConstraints = false
        self.articleImage.translatesAutoresizingMaskIntoConstraints = false
        self.articleTitle.translatesAutoresizingMaskIntoConstraints = false
        self.articleAuthor.translatesAutoresizingMaskIntoConstraints = false
        self.articleDescription.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            //bg
            self.backgroundFrame.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.backgroundFrame.widthAnchor.constraint(equalTo: self.widthAnchor),
            self.backgroundFrame.heightAnchor.constraint(equalTo: self.heightAnchor),
            
            // imagem
            self.articleImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.articleImage.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            self.articleImage.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            self.articleImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            
            // titulo
            self.articleTitle.topAnchor.constraint(equalTo: self.articleImage.bottomAnchor, constant: 15),
            self.articleTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            self.articleTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            
            // autor
            self.articleAuthor.topAnchor.constraint(equalTo: self.articleTitle.bottomAnchor, constant: 5),
            self.articleAuthor.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            self.articleAuthor.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            
            // descricao
            self.articleDescription.topAnchor.constraint(equalTo: self.articleAuthor.bottomAnchor, constant: 5),
            self.articleDescription.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            self.articleDescription.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
        ])
    }
}
