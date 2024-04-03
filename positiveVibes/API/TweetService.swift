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
                let tweet = Tweet(user: user,tweetID: tweetID, tweetDict: dictionary)
                tweets.append(tweet)
                completion(tweets)

            }
        }
    }
    
    func fetchUserTweets(for user: User, completion: @escaping ([Tweet]) -> ()){
        var tweets = [Tweet]()
        Database.database().reference().child("user-tweets").child(user.uid).observe(.childAdded) { snapshot in
            let tweetID = snapshot.key
            Database.database().reference().child("tweets").child(tweetID).observeSingleEvent(of: .value) { snapshot in
                guard let data = snapshot.value as? [String: Any] else { return }
                let tweet = Tweet(user: user, tweetID: tweetID, tweetDict: data)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    
    func saveReplyTweet(withText text: String, tweetUID: String, andUID uid: String, completion: @escaping (Result<String, Error>) -> Void){
        let info = ["tweet": text, "uid": uid, "timestamp": Int(NSDate().timeIntervalSince1970), "likes": 0, "retweet": 0] as [String : Any]
        Database.database().reference().child("tweet-replies").child(tweetUID).childByAutoId().updateChildValues(info) { (error, result) in
            if let error = error {
                completion(.failure(error))
            }
            guard let replieUID = result.key else { return }
            Database.database().reference().child("user-replies").child(uid).child(tweetUID).updateChildValues([replieUID: 1] as [String : Any]) { (error, result) in
                if let error = error {
                    completion(.failure(error))
                }
            completion(.success("Nice work, you saved the tweet"))
            }
        }
    }
    
    func fetchReplyTweets(tweetUID uid: String, completion: @escaping ([Tweet]) -> ()){
        var tweets = [Tweet]()
        Database.database().reference().child("tweet-replies").child(uid).observe(.childAdded) { snapshot in
            //.childAdded monitors your database for anytime a new child is added. IE - a new tweet is added
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            //get user data
            guard let uid = dictionary["uid"] as? String else { return }
            Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { userSnap in
                guard let userDict = userSnap.value as? [String: Any] else { return }
                let user = User(uid: uid, user: userDict)
                let tweetID = snapshot.key
                let tweet = Tweet(user: user,tweetID: tweetID, tweetDict: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func fetchUserReplies(withUser user: User, completion: @escaping ([Tweet])->()){
        var tweets = [Tweet]()
        Database.database().reference().child("user-replies").child(user.uid).observe(.childAdded) { tweetUID in
//            print(tweetUID)
            let tweetUID = tweetUID.key
//            print(tweetUID)
            Database.database().reference().child("user-replies").child(user.uid).child(tweetUID).observe(.childAdded) { replyUID in
                let replyUID = replyUID.key
//                print("FETCH USER REPLY SNAP: \(replyUID)")
                Database.database().reference().child("tweet-replies").child(tweetUID).child(replyUID).observeSingleEvent(of: .value) { snapshot in
//                    print("FETCH USER REPLY SNAP: \(snapshot)")
                    guard let tweetDict = snapshot.value as? [String: Any] else { return }
                    let snapUID = snapshot.key
                    let tweetModel = Tweet(user: user, tweetID: snapUID, tweetDict: tweetDict)
                    tweets.append(tweetModel)
                    completion(tweets)
                }
            }
        }
    }
}
