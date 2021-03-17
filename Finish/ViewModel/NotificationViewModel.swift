//
//  NotificationViewModel.swift
//  Finish
//
//  Created by 志村　啓太 on 2021/03/18.
//

import UIKit

struct NotificationViewModel {
    
    private let notification: Notification
    private let type: NotificationType
    private let user: User
    
    var timestampString: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: notification.timestamp, to: now) ?? ""
    }
    
    var notificationMessage: String {
        switch type {
        case .follow: return "さんがあなたをフォローしました。"
        case .like: return "さんがあなたの投稿をいいねしました。"
        case .reply: return "さんがあなたの投稿へ返信しました。"
        case .mention: return "さんがあなたをメンションしました。"
        }
    }
    
    var notificationText: NSAttributedString? {
        guard let timestamp = timestampString else { return nil }
        let attributedText = NSMutableAttributedString(string: "@\(user.username)",
                                                       attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)])
        attributedText.append(NSAttributedString(string: notificationMessage,
                                                 attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]))
        attributedText.append(NSAttributedString(string: " \(timestamp)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        
        return attributedText
    }
    
    var profileImageUrl: URL? {
        return user.profileImageUrl
    }
    
    var shouldHideFollowButton: Bool {
        return type != .follow
    }
    
    var followButtonText: String {
        return user.isFollowed ? "フォロー中" : "フォローする"
    }
    
    var followButtonBackgroundColor: UIColor {
        return user.isFollowed ? .systemPink : UIColor(named: "backgroundColor")!
    }
    
    var followButtonTextColor: UIColor {
        return user.isFollowed ? .white : .systemPink
    }
    
    init(notification: Notification) {
        self.notification = notification
        self.type = notification.type
        self.user = notification.user
    }
}
