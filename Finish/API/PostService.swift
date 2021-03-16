//
//  PostService.swift
//  Finish
//
//  Created by 志村　啓太 on 2021/03/16.
//

import Firebase

struct PostService {
    static let shared = PostService()
    
    func uploadPost(caption: String, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let values = [KEY_CAPTION: caption,
                      KEY_TIMESTAMP: Int(NSDate().timeIntervalSince1970),
                      KEY_LIKES: 0,
                      KEY_UID: uid] as [String : Any]
                
        REF_POSTS.childByAutoId().updateChildValues(values, withCompletionBlock: completion)
    }
    
    func fetchPosts(completion: @escaping([Post]) -> Void) {
        var posts = [Post]()

        REF_POSTS.observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let postID = snapshot.key
            let post = Post(postID: postID, dictionary: dictionary)
            posts.append(post)
            completion(posts)
        }
    }
}
