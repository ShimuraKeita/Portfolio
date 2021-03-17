//
//  ProfileHeader.swift
//  Finish
//
//  Created by 志村　啓太 on 2021/03/17.
//

import UIKit

protocol ProfileHeaderDelegate: class {
    func handleEditProfileFollow(_ header: ProfileHeader)
}

class ProfileHeader: UICollectionReusableView {
    
    //MARK: - Properties
    
    var user: User? {
        didSet { configure() }
    }
    
    weak var delegate: ProfileHeaderDelegate?
    private let filterBar = ProfileFilterView()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: 80, height: 80)
        iv.layer.cornerRadius = 80 / 2
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.tintColor = UIColor(named: "labelTextColor")
        return label
    }()
    
    private let sickLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.tintColor = UIColor(named: "labelTextColor")
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.systemPink.cgColor
        button.layer.borderWidth = 0.5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleEditProfileFollow), for: .touchUpInside)
        return button
    }()
    
    private let postsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(handleFollowersTapped))
//        label.isUserInteractionEnabled = true
//        label.addGestureRecognizer(tap)
        
        return label
    }()
    
    private lazy var followingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(handleFollowingTapped))
//        label.isUserInteractionEnabled = true
//        label.addGestureRecognizer(tap)
        
        return label
    }()
    
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPink
        return view
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        filterBar.delegate = self
        
        backgroundColor = UIColor(named: "backgroundColor")
        
        let labelStack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 4
        
        let imageLabelStack = UIStackView(arrangedSubviews: [profileImageView, labelStack])
        imageLabelStack.axis = .horizontal
        imageLabelStack.spacing = 12
        
        addSubview(imageLabelStack)
        imageLabelStack.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 12)
        
        let dataLabel = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
        dataLabel.spacing = 50
        
        addSubview(dataLabel)
        dataLabel.centerX(inView: self)
        dataLabel.anchor(top: imageLabelStack.bottomAnchor, paddingTop: 16)
        
        let bioButtonStack = UIStackView(arrangedSubviews: [sickLabel, bioLabel,
                                                            editProfileFollowButton])
        bioButtonStack.axis = .vertical
        bioButtonStack.spacing = 4
        
        addSubview(bioButtonStack)
        bioButtonStack.anchor(top: dataLabel.bottomAnchor, left: leftAnchor,
                                       right: rightAnchor, paddingTop: 16,
                                       paddingLeft: 24, paddingRight: 24)
        
        addSubview(filterBar)
        filterBar.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 50)
        
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor, width: frame.width / 3, height: 2)
        
        let underlineView = UIView()
        underlineView.backgroundColor = .lightGray
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor,
                             right: rightAnchor, height: 0.3)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func handleEditProfileFollow() {
        delegate?.handleEditProfileFollow(self)
    }

    //MARK: - Helpers
    
    func configure() {
        guard let user = user else { return }
                
        let viewModel = ProfileHeaderViewModel(user: user)
        
        profileImageView.sd_setImage(with: user.profileImageUrl)
        
        editProfileFollowButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        editProfileFollowButton.setTitleColor(viewModel.actionButtonTextColor, for: .normal)
        editProfileFollowButton.backgroundColor = viewModel.actionButtonBackgroundColor
        
        postsLabel.attributedText = viewModel.postsString(valueColor: UIColor(named: "buttonColor") ?? .black, textColor: .lightGray)
        followingLabel.attributedText = viewModel.followingString(valueColor: UIColor(named: "buttonColor") ?? .black, textColor: .lightGray)
        followersLabel.attributedText = viewModel.followersString(valueColor: UIColor(named: "buttonColor") ?? .black, textColor: .lightGray)
        
        sickLabel.text = user.sick
        bioLabel.text = user.bio
        
        fullnameLabel.text = user.fullname
        usernameLabel.text = viewModel.usernameText
    }

}

//MARK: - ProfileFilterViewDelegate

extension ProfileHeader: ProfileFilterViewDelegate {
    func filterView(_ view: ProfileFilterView, didSelect indexPath: IndexPath) {
        guard let cell = view.collectionView.cellForItem(at: indexPath) else { return }
        
        let xPosition = cell.frame.origin.x
        UIView.animate(withDuration: 0.3) {
            self.underlineView.frame.origin.x = xPosition
        }
    }
}
