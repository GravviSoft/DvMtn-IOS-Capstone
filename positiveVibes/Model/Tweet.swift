//
//  Tweet.swift
//  positiveVibes
//
//  Created by Beau Enslow on 3/14/24.
//

import UIKit

struct Tweet {
    
    let tweetID: String
    var tweet: String
    let uid: String
    var likes: Int
    var retweetCount: Int
    var replyCount: Int
    var timestamp: Date!
    var user: User
//    var didLike = false
//    var didRetweet = false
//    var didBookmark = false
    var followInfo: Following?
     
    init(user: User, tweetID: String, tweetDict: [String: Any]) {
        self.tweet = tweetDict["tweet"] as? String ?? ""
        self.uid = tweetDict["uid"] as? String ?? ""
        self.likes = tweetDict["likes"] as? Int ?? 0
        self.retweetCount = tweetDict["retweetCount"] as? Int ?? 0
        self.replyCount = tweetDict["replyCount"] as? Int ?? 0
        if let timestamp = tweetDict["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        self.tweetID = tweetID
        self.user = user
    }
}
