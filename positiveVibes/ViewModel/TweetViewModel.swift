//
//  TweetViewModel.swift
//  positiveVibes
//
//  Created by Beau Enslow on 3/19/24.
//


import UIKit

struct TweetViewModel {
    let tweet: Tweet
    let user: User
    
    var timestamp: String{
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: tweet.timestamp, to: now) ?? "2m"
    }
    
    var userInfoText: NSAttributedString {
        let title = NSMutableAttributedString(string: user.fullName, attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        title.append(NSAttributedString(string: " @\(user.userName)", attributes: [.font : UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.lightGray]))
        title.append(NSAttributedString(string: " ·\(timestamp)", attributes: [.font : UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.lightGray]))
        return title
    }
    
    init(tweet: Tweet) {
        self.tweet = tweet
        self.user = tweet.user
    }
}
