//
//  SearchController.swift
//  Finish
//
//  Created by 志村　啓太 on 2021/03/16.
//

import UIKit

private let reuseIdentifier = "UserCell"

class SearchController: UICollectionViewController {
    
    //MARK: - Properties
    
    private var users = [User]()
    
    //MARK: - Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - API
    
    func fetchUsers() {
        UserService.shared.fetchUsers { (users) in
            self.users = users
            self.collectionView.reloadData()
        }
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = UIColor(named: "backgroundColor")
        navigationItem.title = "ユーザー検索"
        
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
}

extension SearchController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        
        cell.user = users[indexPath.row]
        
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension SearchController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 300)
    }
}
