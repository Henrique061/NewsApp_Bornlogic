//
//  ArticleView.swift
//  NewsApp_Bornlogic
//
//  Created by Henrique Assis on 13/05/24.
//

import Foundation
import UIKit

class ArticleView: UIViewController {
    let article: Article
    
    //MARK: - UI COMPONENTS
    private let articleImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleToFill
        
        return image
    }()
    
    private let articleTitle: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        
        return label
    }()
    
    private let articleDate: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textAlignment = .center
        
        return label
    }()
    
    private let articleContent: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        
        return label
    }()
    
    private let accessLink: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        label.text = "Acesse: "
        
        return label
    }()
    
    private let articleLink: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        label.textColor = .blue
        
        let underlineAttribute = NSAttributedString(
            string: "attriString",
            attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        )
        label.attributedText = underlineAttribute
        
        return label
    }()
    
    private let linkHStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        
        return stack
    }()
    
    //MARK: - INIT
    init(article: Article) {
        self.article = article
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.configureArticle()
        self.setupUi()
    }
    
    //MARK: - FUNCS
    private func configureArticle() {
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
        
        // titulo
        self.articleTitle.text = self.article.title
        
        // data
        let isoDateFormatter = ISO8601DateFormatter()
        if let date = isoDateFormatter.date(from: self.article.publishedAt) {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "pt-BR")
            formatter.dateStyle = .long
            let formattedDate = formatter.string(from: date)
            self.articleDate.text = formattedDate
        } else {
            self.articleDate.text = "Data Desconhecida"
        }
        
        // conteudo
        self.articleContent.text = self.article.content
        
        //link
        self.articleLink.text = self.article.url
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onClickLabel(sender:)))
        self.articleLink.isUserInteractionEnabled = true
        self.articleLink.addGestureRecognizer(tap)
    }
    
    // acessar link
    @objc func onClickLabel(sender: UITapGestureRecognizer) {
        let articleUrl = URL(string: self.article.url)
        if let url = articleUrl {
            UIApplication.shared.open(url)
        }
    }
    
    //MARK: - SETUP UI
    private func setupUi() {
        self.view.addSubview(self.articleImage)
        self.view.addSubview(self.articleTitle)
        self.view.addSubview(self.articleDate)
        self.view.addSubview(self.articleContent)
        self.view.addSubview(self.linkHStack)
        self.linkHStack.addArrangedSubview(self.accessLink)
        self.linkHStack.addArrangedSubview(self.articleLink)
        
        self.articleImage.translatesAutoresizingMaskIntoConstraints = false
        self.articleTitle.translatesAutoresizingMaskIntoConstraints = false
        self.articleDate.translatesAutoresizingMaskIntoConstraints = false
        self.articleContent.translatesAutoresizingMaskIntoConstraints = false
        self.linkHStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // imagem
            self.articleImage.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: -45),
            self.articleImage.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1),
            self.articleImage.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.4),
            
            // titulo
            self.articleTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.articleTitle.topAnchor.constraint(equalTo: self.articleImage.bottomAnchor, constant: 15),
            self.articleTitle.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9),
            
            // data
            self.articleDate.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.articleDate.topAnchor.constraint(equalTo: self.articleTitle.bottomAnchor, constant: 15),
            self.articleDate.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),
            
            // conteudo
            self.articleContent.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.articleContent.topAnchor.constraint(equalTo: self.articleDate.bottomAnchor, constant: 15),
            self.articleContent.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            
            // hstack do link
            self.linkHStack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.linkHStack.topAnchor.constraint(equalTo: self.articleContent.bottomAnchor, constant: 15),
            self.linkHStack.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
        ])
    }
}
