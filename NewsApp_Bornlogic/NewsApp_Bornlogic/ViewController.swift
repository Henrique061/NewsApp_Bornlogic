//
//  ViewController.swift
//  NewsApp_Bornlogic
//
//  Created by Henrique Assis on 11/05/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        NewsCall().getNews { news in
            dump(news)
        }
    }
}

