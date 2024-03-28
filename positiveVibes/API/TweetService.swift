//
//  TweetService.swift
//  positiveVibes
//
//  Created by Beau Enslow on 3/13/24.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class TweetService {
    
    static let shared = TweetService()
    
    func saveTweet(withText text: String, andUID uid: String, completion: @escaping (Result<String, Error>) -> Void){
        let info = ["tweet": text, "uid": uid, "timestamp": Int(NSDate().timeIntervalSince1970), "likes": 0, "retweet": 0] as [String : Any]
        Database.database().reference().child("tweets").childByAutoId().updateChildValues(info) { (error, result) in
            if let error = error {
                completion(.failure(error))
                
            }
            guard let tweetID = result.key else { return }
            Database.database().reference().child("user-tweets").child(uid).updateChildValues([tweetID: 1] as [String : Any]) { (error, result) in
                if let error = error {
                    completion(.failure(error))
                }
            completion(.success("Nice work, you saved the tweet"))
            }
        }
    }
    
    func fetchTweet(completion: @escaping ([Tweet]) -> Void){
        var tweets = [Tweet]()
        Database.database().reference().child("tweets").observe(.childAdded) { snapshot in
            //.childAdded monitors your database for anytime a new child is added. IE - a new tweet is added
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            //get user data
            guard let uid = dictionary["uid"] as? String else { return }
            Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { userSnap in
                guard let userDict = userSnap.value as? [String: Any] else { return }
                let user = User(uid: uid, user: userDict)
                
                let tweetID = snapshot.key
//                print(tweetID)
                let tweet = Tweet(user: user,tweetID: tweetID, tweetDict: dictionary)
                tweets.append(tweet)
                completion(tweets)

            }
        }
    }
}
