//
//  ConversationsController.swift
//  Finish
//
//  Created by 志村　啓太 on 2021/03/16.
//

import UIKit

class ConversationsController: UIViewController {
    
    //MARK: - Properties
    
    //MARK: - Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    //MARK: - Helpers
    
    func configure() {
        view.backgroundColor = UIColor(named: "backgroundColor")
        navigationItem.title = "トーク"
    }
}
