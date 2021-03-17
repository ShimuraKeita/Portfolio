//
//  PostController.swift
//  Finish
//
//  Created by 志村　啓太 on 2021/03/17.
//

import UIKit

private let reuseIdentifier = "PostCell"
private let headerIdentifier = "PostHeader"

class PostController: UICollectionViewController {
    
    //MARK: - Properties
    
    private let post: Post
    
    //MARK: - Lifecycle
    
    init(post: Post) {
        self.post = post
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
    }

    //MARK: - Selectors
    
    func configureCollectionView() {
        collectionView.backgroundColor = UIColor(named: "backgroundColor")
        
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(PostHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }

    //MARK: - Helpers
}

//MARK: - UICollectionViewDataSource

extension PostController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PostCell
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension PostController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! PostHeader
        header.post = post
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}


//MARK: - UICollectionViewDelegateFlowLayout

extension PostController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let viewModel = PostViewModel(post: post)
        let height = viewModel.size(forWidth: view.frame.width).height
        
        return CGSize(width: view.frame.width, height: height + 260)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
}
