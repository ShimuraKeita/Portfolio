//
//  UploadPostController.swift
//  Finish
//
//  Created by 志村　啓太 on 2021/03/16.
//

import UIKit

class UploadPostController: UIViewController {
    
    //MARK: - Properties
    
    private let user: User
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemPink
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32 / 2
        
        button.addTarget(self, action: #selector(handleUploadPost), for: .touchUpInside)
        
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48 / 2
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let captionTextView = InputTextView()
    
    //MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureNavigationBar()
    }

    //MARK: - Selectors
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleUploadPost() {
        guard let captin = captionTextView.text else { return }
        PostService.shared.uploadPost(caption: captin) { (error, ref) in
            if let error = error {
                print("DEBUG: Failed to upload post with error \(error.localizedDescription)")
                return
            }

            self.dismiss(animated: true, completion: nil)
        }
    }

    //MARK: - API

    //MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = UIColor(named: "backgroundColor")
        
        let imageCaptionStack = UIStackView(arrangedSubviews: [profileImageView, captionTextView])
        imageCaptionStack.axis = .horizontal
        imageCaptionStack.spacing = 12
        imageCaptionStack.alignment = .leading

        view.addSubview(imageCaptionStack)
        imageCaptionStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                                 right: view.rightAnchor, paddingTop: 16, paddingLeft: 16,
                                 paddingRight: 16)
        
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "buttonTitleColor")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }
}
