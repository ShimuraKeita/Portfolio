//
//  UploadPostViewModel.swift
//  Finish
//
//  Created by 志村　啓太 on 2021/03/17.
//

import UIKit

enum UploadPostConfiguration {
    case post
    case reply(Post)
}

struct UploadPostViewModel {
    
    let actionButtonTitle: String
    let placeholderText: String
    var shouldShowReplyLabel: Bool
    var replyText: String?
    
    init(config: UploadPostConfiguration) {
        switch config {
        case .post:
            actionButtonTitle = "投稿"
            placeholderText = "いまどうしてる?"
            shouldShowReplyLabel = false
        case .reply(let tweet):
            actionButtonTitle = "返信"
            placeholderText = "返信を投稿"
            shouldShowReplyLabel = true
            replyText = "返信先: @\(tweet.user.username) さん"
        }
    }
}
