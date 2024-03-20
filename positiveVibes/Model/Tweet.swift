//
//  Tweet.swift
//  positiveVibes
//
//  Created by Beau Enslow on 3/14/24.
//

import UIKit

struct Tweet {
    
    let tweetID: String
    let tweet: String
    let uid: String
    let likes: Int
    let retweetCount: Int
    var timestamp: Date!
    let user: User
     
    init(user: User, tweetID: String, tweetDict: [String: Any]) {
        self.tweet = tweetDict["tweet"] as? String ?? ""
        self.uid = tweetDict["uid"] as? String ?? ""
        self.likes = tweetDict["likes"] as? Int ?? 0
        self.retweetCount =  tweetDict["retweetCount"] as? Int ?? 0
        if let timestamp = tweetDict["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        self.tweetID = tweetID
        self.user = user
    }
}
