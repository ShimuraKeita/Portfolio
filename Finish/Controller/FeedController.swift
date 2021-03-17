//
//  FeedController.swift
//  Finish
//
//  Created by 志村　啓太 on 2021/03/16.
//

import UIKit

private let reuseIdentifier = "PostCell"

class FeedController: UICollectionViewController {
    
    //MARK: - Properties
    
    private var posts = [Post]() {
        didSet { collectionView.reloadData() }
    }
    
    private var filteredPosts = [Post]() {
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
        fetchPosts()
        configureSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - API
    
    func fetchPosts() {
        PostService.shared.fetchPosts { (posts) in
            self.posts = posts
        }
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        collectionView.backgroundColor = UIColor(named: "backgroundColor")
        navigationItem.title = "タイムライン"
        
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "投稿を検索"
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
}

//MARK: - UICollectionViewDelegate/DataSource

extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inSearchMode ? filteredPosts.count : posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PostCell
        
        cell.delegate = self
        let post = inSearchMode ? filteredPosts[indexPath.row] : posts[indexPath.row]
        cell.post = post
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let post = inSearchMode ? filteredPosts[indexPath.row] : posts[indexPath.row]
        let controller = PostController(post: post)
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = PostViewModel(post: posts[indexPath.row])
        let height = viewModel.size(forWidth: view.frame.width).height
        
        return CGSize(width: view.frame.width, height: height + 72)
    }
}

//MARK: - PostCellDelegate

extension FeedController: PostCellDelegate {
    func handleReplyTapped(_ cell: PostCell) {
        guard let post = cell.post else { return }
        let controller = UploadPostController(user: post.user, config: .reply(post))
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func handleProfileImageTapped(_ cell: PostCell) {
        guard let user = cell.post?.user else { return }
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - UISearchResultsUpdating

extension FeedController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        
        filteredPosts = posts.filter({ post -> Bool in
            return post.user.fullname.contains(searchText) || post.user.username.contains(searchText)
                || post.user.sick.contains(searchText) || post.caption.contains(searchText)
        })
    }
}
