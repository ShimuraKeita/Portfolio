//
//  ConversationsController.swift
//  Finish
//
//  Created by 志村　啓太 on 2021/03/16.
//

import UIKit
import SDWebImage

class ConversationsController: UIViewController {
    
    //MARK: - Properties
    
    var user: User? {
        didSet { configureLeftBarButton() }
    }
    
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
    
    //MARK: - Selectors
    
    @objc func handleProfileImageTap() {

    }
    
    //MARK: - Helpers
    
    func configure() {
        view.backgroundColor = UIColor(named: "backgroundColor")
        navigationItem.title = "トーク"
    }
    
    func configureLeftBarButton() {
        guard let user = user else { return }
        
        let profileImageView = UIImageView()
        profileImageView.setDimensions(width: 32, height: 32)
        profileImageView.backgroundColor = .lightGray
        profileImageView.layer.cornerRadius = 32 / 2
        profileImageView.layer.masksToBounds = true
        profileImageView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTap))
        profileImageView.addGestureRecognizer(tap)
        
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
}
