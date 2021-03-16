//
//  Post.swift
//  Finish
//
//  Created by 志村　啓太 on 2021/03/16.
//

import Foundation

struct Post {
    let caption: String
    let postID: String
    var likes: Int
    var timestamp: Date!
    var user: User
    var didLike = false
    var replyingTo: String?
    
    var isReply: Bool { return replyingTo != nil }
    
    init(user: User, postID: String, dictionary: [String: Any]) {
        self.postID = postID
        self.user = user
        
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0

        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        
        if let replyingTo = dictionary["replyingTo"] as? String {
            self.replyingTo = replyingTo
        }
    }
}

