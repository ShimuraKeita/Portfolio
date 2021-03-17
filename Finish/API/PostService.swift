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
                
        REF_POSTS.childByAutoId().updateChildValues(values) { (err, ref) in
            guard let postID = ref.key else { return }
            REF_USER_POSTS.child(uid).updateChildValues([postID: 1], withCompletionBlock: completion)
        }
    }
    
    func fetchPosts(completion: @escaping([Post]) -> Void) {
        var posts = [Post]()

        REF_POSTS.observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let postID = snapshot.key
            
            UserService.shared.fetchUser(uid: uid) { (user) in
                let post = Post(user: user, postID: postID, dictionary: dictionary)
                posts.append(post)
                completion(posts)
            }
        }
    }
    
    func fetchPosts(forUser user: User, completion: @escaping([Post]) -> Void) {
        var posts = [Post]()
        REF_USER_POSTS.child(user.uid).observe(.childAdded) { (snapshot) in
            let postID = snapshot.key
            
            REF_POSTS.child(postID).observeSingleEvent(of: .value) { (snapshot) in
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                guard let uid = dictionary["uid"] as? String else { return }
                
                UserService.shared.fetchUser(uid: uid) { (user) in
                    let post = Post(user: user, postID: postID, dictionary: dictionary)
                    posts.append(post)
                    completion(posts)
                }
            }
        }
    }
}
