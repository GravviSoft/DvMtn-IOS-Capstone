//
//  UploadTweetViewModel.swift
//  positiveVibes
//
//  Created by Beau Enslow on 4/1/24.
//

import UIKit

struct UploadTweetViewModel {
    
    let actionBtnTitle: String
    let placeholderText: String
    var showReplyInfo: Bool
    var currentUserImg: String?
    var tweet: Tweet?
    var currentUserUID: String?
    
    init(_ config: UploadTweetConfiguration){
        switch config {
        case .tweet:
            actionBtnTitle = "Post"
            placeholderText = "What's Happening?"
            showReplyInfo = false
            
        case .reply(let tweet, let user):
            actionBtnTitle = "Reply"
            placeholderText = "Post your reply"
            showReplyInfo = true
            currentUserImg = user.profileImgUrl
            currentUserUID = user.uid
            self.tweet = tweet
        }
        
    }
}
//    var replyAttrLabel: NSAttributedString  {
//        let title = NSMutableAttributedString(string: "\(user.followers)", attributes: [.font : UIFont.boldSystemFont(ofSize: 14), .foregroundColor: UIColor.twitterBlue.cgColor])
//        title.append(NSAttributedString(string: " Following", attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
//        return title
//    }
    
//    var replyAttrLabel: UIButton {
//        let button = UIButton(type: .system)
//        let textTitle = NSMutableAttributedString(string: "Replying to ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
//        textTitle.append(NSAttributedString(string: "@\(tweet.user.userName)", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.twitterBlue]))
//        button.setAttributedTitle(textTitle, for: .normal)
////        button.addTarget(self, action: selector, for: .touchUpInside)
//        return button
//    }
    
//    func authRedirectBtn(text str: String, boldText boldStr: String, andSelector selector: Selector) -> UIButton {
//        let button = UIButton(type: .system)
//        let textTitle = NSMutableAttributedString(string: str, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.iconBadgeTheme])
//        textTitle.append(NSAttributedString(string: boldStr, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.iconBadgeTheme]))
//        button.setAttributedTitle(textTitle, for: .normal)
//        button.addTarget(self, action: selector, for: .touchUpInside)
//        return button
//    }


//struct ReplyLabel {
//    let tweet: Tweet
//    
//}
