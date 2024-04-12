//
//  TweetViewModel.swift
//  positiveVibes
//
//  Created by Beau Enslow on 3/19/24.
//


import UIKit
import SDWebImage


struct TweetViewModel {
    let tweet: Tweet
    let user: User
    
    let delegate: MainFeedControllerCellDelegate?
    let tweetCell: TweetCell
    
    
    var timestamp: String{
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: tweet.timestamp, to: now) ?? "2m"
        
    }
    
    
    var delete: UIAction{
        UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { (_) in
            delegate?.handleDeleteTweet(tweetCell)
         }
    }
    
    var follow: UIAction{
        UIAction(title: "Follow", image: UIImage(systemName: "person.fill.checkmark")) { (_) in
            delegate?.handleFollow(tweetCell)
        }
    }
    
    var unfollow: UIAction{
        UIAction(title: "Unfollow", image: UIImage(systemName: "person.fill.xmark")) { (_) in
            delegate?.handleUnfollow(tweetCell)
         }
    }
    
    var report: UIAction{
        UIAction(title: "Report", image: UIImage(systemName: "flag"), attributes: .destructive) { (_) in
            delegate?.handleReport(tweetCell)
        }
    }
    var firstItem: UIAction {
        user.isCurrentUser ? delete : (tweet.followInfo?.isFollowing ?? false ? unfollow : follow)
    }
    
    var menu: UIMenu{
        UIMenu(title: "", children: [firstItem, report])
    }
    
    var check: UIImage {
        let iv = UIImage(systemName: "checkmark.seal.fill", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 12.0)))?.withTintColor(.twitterBlue, renderingMode: .alwaysOriginal)
        return iv ?? UIImage()
    }
    
    var likButtonTint: UIColor {
        return tweet.followInfo?.didLike ?? false ? .red : .lightGray
    }
    
    var likeBtnImage: UIImage {
        let iv = UIImage(systemName: tweet.followInfo?.didLike ?? false ? "heart.fill" : "heart")
        return iv!
    }

    
    var retweetColor: UIColor {
        return tweet.followInfo?.didRetweet ?? false ? .green : .lightGray
    }
    
    var retweetImg: UIImage {
        let iv = UIImage(systemName: tweet.followInfo?.didRetweet ?? false ? "gobackward" : "gobackward")
        return iv!
    }
    
    
    var bookmarkColor: UIColor {
        return tweet.followInfo?.didBookmark ?? false ? .twitterBlue : .lightGray
    }
    
    var bookmarkImg: UIImage {
        let iv = UIImage(systemName: tweet.followInfo?.didBookmark ?? false ? "bookmark.fill" : "bookmark")
        return iv!
    }
    
    
    
    var userInfoText: NSAttributedString {
        let title = NSMutableAttributedString(string: "\(user.fullName) ", attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
       
        let checkImg = NSTextAttachment()
        checkImg.image = check
        let checkMark = NSAttributedString(attachment: checkImg)
        title.append(checkMark)
        
        title.append(NSAttributedString(string: " @\(user.userName)", attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
        title.append(NSAttributedString(string: " · \(timestamp)", attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return title
    }
    
    init(tweet: Tweet, delegate: MainFeedControllerCellDelegate?, tweetCell: TweetCell) {
        self.tweet = tweet
        self.user = tweet.user
        self.delegate = delegate
        self.tweetCell = tweetCell
    }
    
//    func cellAutoSize(forWidth width: CGFloat) -> CGSize{
//        let measureLabel = UILabel(frame: CGRect(x: 0, y: CGFloat.greatestFiniteMagnitude, width: width, height: CGFloat.greatestFiniteMagnitude))
//        measureLabel.text = tweet.tweet
//        measureLabel.numberOfLines = 0
//        measureLabel.lineBreakMode = .byWordWrapping
//        measureLabel.translatesAutoresizingMaskIntoConstraints  = false
//        measureLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
//        return measureLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
//    }
    
    
}
