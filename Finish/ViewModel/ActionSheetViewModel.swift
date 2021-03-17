//
//  ActionSheetViewModel.swift
//  Finish
//
//  Created by 志村　啓太 on 2021/03/17.
//

import Foundation

struct ActionSheetViewModel {
    
    private let user: User
    
    var options: [ActionSheetOptions] {
        var results = [ActionSheetOptions]()
        
        if user.isCurrentUser {
            results.append(.delete)
        } else {
            let followOption: ActionSheetOptions = user.isFollowed ? .unfollow(user) : .follow(user)
            results.append(followOption)
            
            let blockOption: ActionSheetOptions = user.isBlocked ? .unblock(user) : .block(user)
            results.append(blockOption)
            
            results.append(.report)
        }
        
        return results
    }
    
    init(user: User) {
        self.user = user
    }
}

enum ActionSheetOptions {
    case follow(User)
    case unfollow(User)
    case report
    case block(User)
    case unblock(User)
    case delete

    
    var description: String {
        switch self {
        case .follow(let user): return "@\(user.username)さんをフォロー"
        case .unfollow(let user): return "@\(user.username)さんのフォローを解除"
        case .report: return "投稿を報告する"
        case .block(let user): return "@\(user.username)さんをブロック"
        case .unblock(let user): return "@\(user.username)さんのブロックを解除"
        case .delete: return "投稿を削除"
        }
    }
}
