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
    
    var editOrFollowBtn: String {
        var title = String()
        let currentUser = Auth.auth().currentUser?.uid ?? ""
        title = currentUser == user.uid ? "Edit Profile" : "Follow"
        print("Button text is \(title): Since users uid \(currentUser) = \(user.uid)")
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
