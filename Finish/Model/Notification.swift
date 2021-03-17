//
//  Notification.swift
//  Finish
//
//  Created by 志村　啓太 on 2021/03/18.
//

import Foundation

enum NotificationType: Int {
    case follow
    case like
    case reply
    case mention
}

struct Notification {
    var postID: String?
    var timestamp: Date!
    var user: User
    var post: Post?
    var type: NotificationType!
    
    init(user: User, dictionary: [String: AnyObject]) {
        self.user = user
                
        if let postID = dictionary["postID"] as? String {
            self.postID = postID
        }
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        
        if let type = dictionary["type"] as? Int {
            self.type = NotificationType(rawValue: type)
        }
    }
}
