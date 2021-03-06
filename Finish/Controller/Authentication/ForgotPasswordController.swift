//
//  ForgotPasswordController.swift
//  Finish
//
//  Created by 志村　啓太 on 2021/03/16.
//

import UIKit
import Firebase
import ProgressHUD

protocol ForgotPasswordControllerDelegate: class {
    func controllerDidSendResetPasswordLink(_ controller: ForgotPasswordController)
}

class ForgotPasswordController: UIViewController {
    
    // MARK: Properties
    
    private var viewModel = ForgotPasswordViewModel()
    weak var delegate: ForgotPasswordControllerDelegate?
    var email: String?
    
    private let resetPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "パスワード再設定"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        return label
    }()
    
    private let emailTextField: UITextField = CustomTextField(placeholder: "メールアドレス")
    
    private let sendButton: CustomButton = {
        let button = CustomButton(title: "再設定メールを送信", type: .system)
        button.backgroundColor = .lightGray
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleEmailSend), for: .touchUpInside)
        return button
    }()
    
    private let showLoginButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "ログイン画面へ ", attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 16)])
        attributedTitle.append(NSAttributedString(string: "戻る", attributes: [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 16)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleshowLoginButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureNotificationObserver()
    }
    
    // MARK: Selector
    
    @objc func handleEmailSend() {
        guard let email = emailTextField.text else { return }
        
        showLoader(true)
        AuthService.shared.sendPasswordReset(withEmail: email) { error in
            if let error = error {
                self.showError(error.localizedDescription)
                self.showLoader(false)
                return
            }
            
            self.delegate?.controllerDidSendResetPasswordLink(self)
        }
    }

    @objc func handleshowLoginButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        guard sender == emailTextField else { return }
        viewModel.email = sender.text
        checkForStatus()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: Helpers
    
    func checkForStatus() {
        if viewModel.formIsValid {
            sendButton.isEnabled = true
            sendButton.backgroundColor = UIColor(named: "buttonBackgroundColor")
            sendButton.setTitleColor(UIColor(named: "buttonTitleColor"), for: .normal)
        } else {
            sendButton.isEnabled = false
            sendButton.backgroundColor = .lightGray
            sendButton.setTitleColor(.white, for: .normal)
        }
    }
    
    func configureUI() {
        
        emailTextField.text = email
        viewModel.email = email
        
        view.backgroundColor = UIColor(named: "loginBackgroundColor")
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(resetPasswordLabel)
        resetPasswordLabel.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor,
                              paddingTop: 60)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, sendButton])
        stack.axis = .vertical
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.anchor(top: resetPasswordLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                     paddingTop: 50, paddingLeft: 30, paddingRight: 30)
        
        view.addSubview(showLoginButton)
        showLoginButton.anchor(top: stack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                             paddingTop: 50, paddingLeft: 30, paddingRight: 30)
    }
    
    func configureNotificationObserver() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
}
