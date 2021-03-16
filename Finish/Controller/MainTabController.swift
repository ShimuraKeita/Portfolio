//
//  MainTabController.swift
//  Finish
//
//  Created by 志村　啓太 on 2021/03/16.
//

import UIKit
import Firebase

class MainTabController: UITabBarController {
    
    //MARK: - Properties
    
    var user: User? {
        didSet {
            guard let nav = viewControllers?[0] as? UINavigationController else { return }
            guard let conversations = nav.viewControllers.first as? ConversationsController else { return }
            
            conversations.user = user
        }
    }
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .systemPink
        button.setImage(UIImage(named: "new_post"), for: .normal)
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = UIColor(named: "backgroundColor")
//        signOut()
        authenticateUserAndConfigureUI()
    }
    
    //MARK: - API
    
    func fetchUser() {
        UserService.shared.fetchUser { (user) in
            self.user = user
        }
    }
    
    func authenticateUserAndConfigureUI() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        } else {
            configureViewControllers()
            configureUI()
            fetchUser()
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    //MARK: - Selectors
    
    @objc func actionButtonTapped() {
        guard let user = user else { return }
        let controller = UploadPostController(user: user)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        view.addSubview(actionButton)
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                            paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
        actionButton.layer.cornerRadius = 56 / 2
    }
    
    func configureViewControllers() {
        
        let conversations = ConversationsController()
        let nav1 = templateNavigationController(image: UIImage(systemName: "message"), rootViewController: conversations)
        
        let feed = FeedController()
        let nav2 = templateNavigationController(image: UIImage(systemName: "clock"), rootViewController: feed)
        
        let explore = SearchController()
        let nav3 = templateNavigationController(image: UIImage(systemName: "magnifyingglass"), rootViewController: explore)
        
        let notifications = NotificationsController()
        let nav4 = templateNavigationController(image: UIImage(systemName: "bell"), rootViewController: notifications)

        viewControllers = [nav1, nav2, nav3, nav4]
    }
    
    func templateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = UIColor(named: "backgroundColor")
        UITabBar.appearance().tintColor = UIColor.systemPink
        return nav
    }
}
