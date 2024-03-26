//
//  ProfileHeaderViewModel.swift
//  positiveVibes
//
//  Created by Beau Enslow on 3/26/24.
//

import UIKit

enum ProfileFilterOptions: Int, CaseIterable {
    case tweets
    case replies
    case likes
    case media
    
    var description: String {
        switch self {
        case .tweets: return "Tweets"
        case .replies: return "Replies"
        case .likes: return "Likes"
        case .media: return "Media"
        }
    }
}


struct ProfileHeaderViewModel {
    let user: User
    
    init(user: User) {
        self.user = user
    }
    
    var followingLabel: NSAttributedString  {
        let title = NSMutableAttributedString(string: "0", attributes: [.font : UIFont.boldSystemFont(ofSize: 14), .foregroundColor: UIColor.iconBadgeTheme.cgColor])
        title.append(NSAttributedString(string: " Following", attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return title
    }
    var followersLabel: NSAttributedString  {
        let title = NSMutableAttributedString(string: "2", attributes: [.font : UIFont.boldSystemFont(ofSize: 14), .foregroundColor: UIColor.iconBadgeTheme.cgColor])
        title.append(NSAttributedString(string: " Followers", attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return title
    }
    
}
