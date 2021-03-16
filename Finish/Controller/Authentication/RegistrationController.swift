//
//  RegistrationController.swift
//  Finish
//
//  Created by 志村　啓太 on 2021/03/16.
//

import UIKit

class RegistrationController: UIViewController {
    
    //MARK: - Properties
    
    private let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        return button
    }()
    
    private let emailTextField = CustomTextField(placeholder: "メールアドレス")
    
    private let passwordTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "パスワード（半角英数字/6文字以上）", isSecureField: true)
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    private let repeatPasswordTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "パスワード確認", isSecureField: true)
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    private let fullnameTextField = CustomTextField(placeholder: "名前")
    
    private let usernameTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "ユーザーネーム")
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    private let registrationButton: CustomButton = {
        let button = CustomButton(title: "新規作成", type: .system)
        button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        return button
    }()
    
    private let teamsOfServiceLabel: UILabel = {
        let label = UILabel()
        label.text = "アカウントを新規作成すると、"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    private let teamsOfServiceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("利用規約およびプライバシーポリシー", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleShowTeamsOfService), for: .touchUpInside)
        return button
    }()
    
    private let agreedLabel: UILabel = {
        let label = UILabel()
        label.text = "に同意したことになります。"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let goToLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "既にアカウントをお持ちの方は", secondPart: "こちら")
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    //MARK: - Selectors
    
    @objc func handleSelectPhoto() {
        
    }
    
    @objc func handleRegistration() {
        
    }
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleShowTeamsOfService() {
        
    }
    
    //MARK: - Helpers
    
    func configure() {
        view.backgroundColor = UIColor(named: "loginBackgroundColor")
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(selectPhotoButton)
        selectPhotoButton.setDimensions(width: 128, height: 128)
        selectPhotoButton.centerX(inView: view)
        selectPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 8)
        
        let teamsOfServiceStack = UIStackView(arrangedSubviews: [teamsOfServiceLabel, teamsOfServiceButton, agreedLabel])
        teamsOfServiceStack.axis = .vertical
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, repeatPasswordTextField, fullnameTextField, usernameTextField, teamsOfServiceStack, registrationButton])
        stack.axis = .vertical
        stack.spacing = 5
        
        view.addSubview(stack)
        stack.anchor(top: selectPhotoButton.bottomAnchor, left: view.leftAnchor,
                     right: view.rightAnchor, paddingTop: 16, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(goToLoginButton)
        goToLoginButton.anchor(left: view.leftAnchor,
                                      bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                      right: view.rightAnchor, paddingLeft: 32, paddingBottom: 16, paddingRight: 32)
    }
}
