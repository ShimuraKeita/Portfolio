//
//  SearchController.swift
//  Finish
//
//  Created by 志村　啓太 on 2021/03/16.
//

import UIKit

class SearchController: UIViewController {
    
    //MARK: - Properties
    
    //MARK: - Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - Helpers
    
    func configure() {
        view.backgroundColor = UIColor(named: "backgroundColor")
        navigationItem.title = "ユーザー検索"
    }
}
