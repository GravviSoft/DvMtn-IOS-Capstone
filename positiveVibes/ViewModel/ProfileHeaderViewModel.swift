//
//  ProfileHeaderViewModel.swift
//  positiveVibes
//
//  Created by Beau Enslow on 3/26/24.
//

import UIKit
import FirebaseAuth

enum ProfileFilterOptions: Int, CaseIterable {
    case tweets
    case replies
    case likes
    case retweets
    
    var description: String {
        switch self {
        case .tweets: return "Tweets"
        case .replies: return "Replies"
        case .likes: return "Likes"
        case .retweets: return "Retweets"
        }
    }
}


struct ProfileHeaderViewModel {
    let user: User
    
    var isFollowing: Bool
        
    init(user: User, isFollowing: Bool) {
        self.user = user
        self.isFollowing = isFollowing
    }
    
    var editOrFollowBtn: String {
        var title = String()
        title = user.isCurrentUser ? "Edit Profile" : ( isFollowing ? "Following" : "Follow")
        return title
    }
    
    var check: UIImage {
        let iv = UIImage(systemName: "checkmark.seal.fill", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 14)))?.withTintColor(.twitterBlue, renderingMode: .alwaysOriginal)
        return iv ?? UIImage()
    }
    
    var userNameLabel: NSAttributedString {
        let label = NSMutableAttributedString(string: "@\(user.userName) ", attributes: [.font: UIFont.systemFont(ofSize: 14.0)])
        let checkImg = NSTextAttachment()
        checkImg.image = check
        let checkMark = NSAttributedString(attachment: checkImg)
        label.append(checkMark)
        return label
    }

    var followingLabel: NSAttributedString  {
        let title = NSMutableAttributedString(string: "\(user.followers)", attributes: [.font : UIFont.boldSystemFont(ofSize: 14), .foregroundColor: UIColor.iconBadgeTheme.cgColor])
        title.append(NSAttributedString(string: " Following", attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return title
    }
    var followersLabel: NSAttributedString  {
        let title = NSMutableAttributedString(string: "\(user.following)", attributes: [.font : UIFont.boldSystemFont(ofSize: 14), .foregroundColor: UIColor.iconBadgeTheme.cgColor])
        title.append(NSAttributedString(string: " Followers", attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return title
    }
    
}
