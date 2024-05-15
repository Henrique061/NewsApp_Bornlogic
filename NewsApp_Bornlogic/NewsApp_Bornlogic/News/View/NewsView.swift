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
    var newsVm = NewsVM()
    private var clickedSearch = false
    private var orderedByRecent = true
    private var isInList = true
    
    //MARK: - UI
    // table
    let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        
        tv.register(NewsCell.self, forCellReuseIdentifier: NewsCell.identifier)
        
        return tv
    }()
    
    // collection
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemGray6
        cv.register(NewsCollectionCell.self, forCellWithReuseIdentifier: NewsCollectionCell.identifier)
        
        return cv
    }()
    
    // search bar
    let searchController = UISearchController(searchResultsController: nil)
    
    // segmented control
    var segmentedControl = UISegmentedControl()
    
    //MARK: - VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGray6
        self.title = "News"
        self.navigationController?.navigationBar.prefersLargeTitles = true

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.searchController.searchBar.delegate = self
        
        self.setupSearchController()
        self.setupSortMenu()
        self.setupSegmentedControl()
        
        NewsCall().getNews { news in
            self.newsVm.news = news
            self.newsVm.updateSort(menuTitle: "Mais recente")
            self.tableView.reloadData()
            self.collectionView.reloadData()
        }
        
        self.setupSegmentedUi()
        self.setupTableUi()
    }
    
    //MARK: - SEARCH
    private func setupSearchController() {
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.placeholder = "Procurar Notícias"
        
        self.navigationItem.searchController = self.searchController
        self.definesPresentationContext = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    //MARK: - SORT
    private func setupSortMenu() {
        let recentTitle = "Mais recente"
        let oldestTitle = "Mais antigo"
        
        let orderHandler: UIActionHandler = { action in
            if action.title == recentTitle && self.orderedByRecent { return }
            if action.title == oldestTitle && !self.orderedByRecent { return }
            
            self.orderedByRecent = !self.orderedByRecent
            self.newsVm.updateSort(menuTitle: action.title)
            
            if self.isInList {
                self.tableView.reloadData()
            } else {
                self.collectionView.reloadData()
            }
        }
        
        let orderMenu = UIMenu(
            title: String(),
            image: UIImage(systemName: "questionmark.circle.fill"),
            identifier: .none,
            options: .singleSelection,
            children: [
                UIAction(title: recentTitle, state: .on, handler: orderHandler),
                UIAction(title: oldestTitle, handler: orderHandler)
            ]
        )
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle"), style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem?.menu = orderMenu
    }
    
    //MARK: - SEGMENTED CONTROL
    private func setupSegmentedControl() {
        let segmentedItems: [UIImage] = [
            UIImage(systemName: "list.bullet") ?? UIImage(),
            UIImage(systemName: "square.grid.2x2") ?? UIImage()
        ]
        
        self.segmentedControl = UISegmentedControl(items: segmentedItems)
        self.segmentedControl.selectedSegmentIndex = 0
        self.segmentedControl.addTarget(self, action: #selector(disposeChange(_:)), for: .valueChanged)
    }
    
    @objc private func disposeChange(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
            case 0: selectedDispose() // alternou para lista
            default: selectedDispose(byList: false) // alternou para collection
        }
    }
    
    private func selectedDispose(byList: Bool = true) {
        if !byList {
            self.tableView.removeFromSuperview()
            self.collectionView.reloadData()
            self.setupCollectionUi()
        } else {
            self.collectionView.removeFromSuperview()
            self.tableView.reloadData()
            self.setupTableUi()
        }
        
        self.isInList = !self.isInList
    }
    
    //MARK: - SETUP UI
    private func setupSegmentedUi() {
        self.view.addSubview(self.segmentedControl)
        self.segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.segmentedControl.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            self.segmentedControl.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
        ])
    }
    
    private func setupTableUi() {
        self.view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.frame = CGRect(x: 0, y: view.bounds.height * 0.3, width: view.bounds.width, height: view.bounds.height)
    }
    
    private func setupCollectionUi() {
        self.view.addSubview(self.collectionView)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.segmentedControl.bottomAnchor, constant: 15),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.collectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        ])
    }
}

//MARK: - SEARCH FUNCS
extension NewsView: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        self.newsVm.updateSearchController(text: searchController.searchBar.text, clickedSearch: self.clickedSearch, completion: {
            if self.isInList {
                self.tableView.reloadData()
            } else {
                self.collectionView.reloadData()
            }
        })
        
        if self.clickedSearch == false { self.clickedSearch = true }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.newsVm.updateSearchController(text: String(), completion: {
            if self.isInList {
                self.tableView.reloadData()
            } else {
                self.collectionView.reloadData()
            }
        })
    }
}
