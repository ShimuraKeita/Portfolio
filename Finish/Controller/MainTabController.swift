//
//  MainTabController.swift
//  Finish
//
//  Created by 志村　啓太 on 2021/03/16.
//

import UIKit

class MainTabController: UITabBarController {
    
    //MARK: - Properties
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewControllers()
    }
    
    //MARK: - Helpers
    
    func configureViewControllers() {
        
        let conversations = ConversationsController()
        let nav4 = templateNavigationController(image: UIImage(named: "message"), rootViewController: conversations)
        
        let feed = FeedController()
        let nav1 = templateNavigationController(image: UIImage(named: "clock"), rootViewController: feed)
        
        let explore = SearchController()
        let nav2 = templateNavigationController(image: UIImage(named: "magnifyingglass"), rootViewController: explore)
        
        let notifications = NotificationsController()
        let nav3 = templateNavigationController(image: UIImage(named: "bell"), rootViewController: notifications)

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
