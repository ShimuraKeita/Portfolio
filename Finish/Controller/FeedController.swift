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
    
    private var actionSheetLauncher: ActionSheetLauncher!
    
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
        checkIfUserIsFollowed(posts: posts)
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
    
    func checkIfUserIsFollowed(posts: [Post]) {
        guard !posts.isEmpty else { return }
        
        posts.forEach { post in
            let user = post.user
            
            UserService.shared.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
                if let index = self.posts.firstIndex(where: { $0.user.uid == post.user.uid }) {
                    self.posts[index].user.isFollowed = isFollowed
                }
            }
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
    
    fileprivate func showActionSheet(forUser user: User) {
        actionSheetLauncher = ActionSheetLauncher(user: user)
        actionSheetLauncher.delegate = self
        actionSheetLauncher.show()
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
    func handleProfileImageTapped(_ cell: PostCell) {
        guard let user = cell.post?.user else { return }
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }

    func handleReplyTapped(_ cell: PostCell) {
        guard let post = cell.post else { return }
        let controller = UploadPostController(user: post.user, config: .reply(post))
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func handleLikeTapped(_ cell: PostCell) {
        guard let post = cell.post else { return }
        
        PostService.shared.likePost(post: post) { (err, ref) in
            cell.post?.didLike.toggle()
            let likes = post.didLike ? post.likes - 1 : post.likes + 1
            cell.post?.likes = likes
            
            // only upload notification if tweet is being liked
            guard !post.didLike else { return }
        }
    }
    
    func showActionSheet(_ cell: PostCell) {
        guard let post = cell.post else { return }
        if post.user.isCurrentUser {
            showActionSheet(forUser: post.user)
        } else {
            UserService.shared.checkIfUserIsFollowed(uid: post.user.uid) { isFollowed in
                var user = post.user
                user.isFollowed = isFollowed
                self.showActionSheet(forUser: user)
            }
        }
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

//MARK: - ActionSheetLauncherDelegate

extension FeedController: ActionSheetLauncherDelegate {
    func didSelect(option: ActionSheetOptions) {
        switch option {
        case .follow(let user):
            UserService.shared.followUser(uid: user.uid) { (err, ref) in
                print("DEBUG: Did follow user \(user.username)")
            }
        case .unfollow(let user):
            UserService.shared.unfollowUser(uid: user.uid) { (err, ref) in
                print("DEBUG: Did unfollow user \(user.username)")
            }
        case .report:
            print("DEBUG: Report tweet")
        case .delete:
            print("DEBUG: Delete tweet..")
        case .block(_):
            print("DEBUG: Delete tweet..")
        case .unblock(_):
            print("DEBUG: Delete tweet..")
        }
    }
}
