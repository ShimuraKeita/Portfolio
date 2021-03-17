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
        
    private var users = [User]() {
        didSet { collectionView.reloadData() }
    }
    
    private var filteredUsers = [User]() {
        didSet { collectionView.reloadData() }
    }
    
    private var inSearchMode: Bool {
        return searchController.isActive &&
            !searchController.searchBar.text!.isEmpty
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: - Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchUsers()
        configureSearchController()
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
    
    func checkIfUserIsFollowed() {
        
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = UIColor(named: "backgroundColor")
        navigationItem.title = "ユーザー検索"
        
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "ユーザー検索"
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
}

//MARK: - UICollectionViewDelegate/DataSource

extension SearchController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inSearchMode ? filteredUsers.count : users.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        cell.delegate = self
        cell.user = user
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension SearchController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 300)
    }
}

//MARK: - UISearchResultsUpdating

extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        
        filteredUsers = users.filter({ user -> Bool in
            return user.fullname.contains(searchText) || user.username.contains(searchText)
                || user.sick.contains(searchText) || user.bio.contains(searchText)
        })
    }
}

//MARK: - UserCellDelegate

extension SearchController: UserCellDelegate {
    func didTapFollow(_ cell: UserCell) {
        guard let user = cell.user else { return }
                
        if user.isFollowed {
            UserService.shared.unfollowUser(uid: user.uid) { (err, ref) in
                cell.user?.isFollowed = false
            }
        } else {
            UserService.shared.followUser(uid: user.uid) { (err, ref) in
                cell.user?.isFollowed = true
            }
        }
    }
    
    func showActionSheet(_ cell: UserCell) {
        
    }
}
