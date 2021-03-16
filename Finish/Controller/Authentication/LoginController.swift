//
//  LoginController.swift
//  Finish
//
//  Created by 志村　啓太 on 2021/03/16.
//

import UIKit

class LoginController: UIViewController {
    
    //MARK: - Properties
    
    private let iconImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "bubble.right")
        iv.tintColor = .white
        return iv
    }()
    
    //MARK: - Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    //MARK: - Selectors
    
    //MARK: - Helpers
    
    func configure() {
        view.backgroundColor = UIColor(named: "loginBackgroundColor")
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        iconImage.setDimensions(width: 120, height: 120)
    }
}
