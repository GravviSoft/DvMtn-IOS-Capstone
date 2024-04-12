//
//  ActionSheetViewModel.swift
//  positiveVibes
//
//  Created by Beau Enslow on 4/4/24.
//

import UIKit

struct ActionSheetViewModel {
    //MARK: - Properties
    let user: User
    let isFollowing: Bool
    
    var options: [ActionSheetOptions] {
        var result = [ActionSheetOptions]()
        if user.isCurrentUser{
            result.append(.delete)
        } else {
            print("isFollowing = \(isFollowing)")
            let follow: ActionSheetOptions = isFollowing ? .unfollow(user) : .follow(user)
            result.append(follow)
        }
        result.append(.report)
        return result
    }
    
    //MARK: - Lifecycle
    init(user: User, isFollowing: Bool) {
        self.user = user
        self.isFollowing = isFollowing
    }
}


enum ActionSheetOptions {
    case follow(User)
    case unfollow(User)
    case report
    case delete
    
    var description: NSMutableAttributedString {
        switch self {
        case .follow(let user): 
            let label = NSMutableAttributedString(string: "Follow", attributes: [.font: UIFont.systemFont(ofSize: 18.0)])
            label.append(NSAttributedString(string: " @\(user.userName)", attributes: [.font : UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor.twitterBlue.cgColor]))
            return label
        case .unfollow(let user):
            let label = NSMutableAttributedString(string: "Unfollow", attributes: [.font: UIFont.systemFont(ofSize: 18.0)])
            label.append(NSAttributedString(string: " @\(user.userName)", attributes: [.font : UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor.twitterBlue.cgColor]))
            return label
        case .report: 
            let label = NSMutableAttributedString(string: "Report", attributes: [.font: UIFont.systemFont(ofSize: 18.0)])
            return label
        case .delete: 
            let label = NSMutableAttributedString(string: "Delete", attributes: [.font: UIFont.systemFont(ofSize: 18.0)])
            return label
        }
    }
}
