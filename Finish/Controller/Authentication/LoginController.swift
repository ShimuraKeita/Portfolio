//
//  LoginController.swift
//  Finish
//
//  Created by 志村　啓太 on 2021/03/16.
//

import UIKit

class LoginController: UIViewController {
    
    //MARK: - Properties
    
    private var viewModel = LoginViewModel()
    
    private let iconImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "bubble.right")
        iv.tintColor = .white
        return iv
    }()
    
    private let emailTextField = CustomTextField(placeholder: "メールアドレス")
    private let passwordTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "パスワード（半角英数字/6文字以上）", isSecureField: true)
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    private let loginButton: CustomButton = {
        let button = CustomButton(title: "ログイン", type: .system)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("パスワードをお忘れですか？", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleShowLoginForgotPassword), for: .touchUpInside)
        return button
    }()

    private let goToRegistrationButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "新規アカウント作成は", secondPart: "こちら")
        button.addTarget(self, action: #selector(handleShowRegistration), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        configureTextFieldObservers()
    }
    
    //MARK: - Selectors
    
    @objc func handleLogin() {
        
    }
    
    @objc func handleShowLoginForgotPassword() {
        let controller = ForgotPasswordController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleShowRegistration() {
        let controller = RegistrationController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        
        checkForStatus()
    }
    
    @objc func keybordWillShow() {
        if view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 50
        }
    }
    
    @objc func keybordWillHide() {
        if view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: - Helpers
    
    func checkForStatus() {
        if viewModel.formIsValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor(named: "buttonBackgroundColor")
            loginButton.setTitleColor(UIColor(named: "buttonTextColor"), for: .normal)
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = .lightGray
            loginButton.setTitleColor(.white, for: .normal)
        }
    }
    
    func configure() {
        view.backgroundColor = UIColor(named: "loginBackgroundColor")
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        iconImage.setDimensions(width: 120, height: 120)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField,
                                                   loginButton, forgotPasswordButton])
        stack.axis = .vertical
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor,
                     right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(goToRegistrationButton)
        goToRegistrationButton.anchor(left: view.leftAnchor,
                                      bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                      right: view.rightAnchor, paddingLeft: 32, paddingBottom: 16, paddingRight: 32)
    }
    
    func configureTextFieldObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keybordWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keybordWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
}
