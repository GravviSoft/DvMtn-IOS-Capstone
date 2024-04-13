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
        let info = ["tweet": text, "uid": uid, "timestamp": Int(NSDate().timeIntervalSince1970), "likes": 0, "retweetCount": 0, "replyCount": 0] as [String : Any]
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
        guard let userID = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("tweets").observe(.childAdded) { snapshot, err in
            //.childAdded monitors your database for anytime a new child is added. IE - a new tweet is added
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            //get user data
            guard let uid = dictionary["uid"] as? String else { return }
            Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { userSnap, err  in
                guard let userDict = userSnap.value as? [String: Any] else { return }
                let user = User(uid: uid, user: userDict)
                let tweetID = snapshot.key
                var tweet = Tweet(user: user,tweetID: tweetID, tweetDict: dictionary)
//                tweets.append(tweet)
                var data = Following(isFollowing: false, followers: 0, following: 0)

                Database.database().reference().child("user-likes").child(userID).child(tweetID).observeSingleEvent(of: .value) { didLike in
                    let didLike = didLike.exists()
                    data.didLike = didLike
                    Database.database().reference().child("user-retweets").child(userID).child(tweetID).observeSingleEvent(of: .value) { didRetweet, err  in
                        let didRetweet = didRetweet.exists()
                        data.didRetweet = didRetweet
                        Database.database().reference().child("user-bookmark").child(userID).child(tweetID).observeSingleEvent(of: .value) { didBookmark, err  in
                            let didBookmark = didBookmark.exists()
                            data.didBookmark = didBookmark
//                            Database.database().reference().child("tweet-replies").child(tweetID).observe(.value) { replyCnt  in
//                                print("REPLY COUNT \(replyCnt.childrenCount)")
//                                tweet.replyCount = Int(replyCnt.childrenCount)
                                Database.database().reference().child("user-followers").child(uid).child(userID).observeSingleEvent(of: .value) { isFollowing in
                                    data.isFollowing = isFollowing.exists()
                                    tweet.followInfo = data
                                    tweets.append(tweet)
                                    completion(tweets)
//                                    print(tweets)
//                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func fetchTweetFollowing(completion: @escaping ([Following]) -> Void){
        var followList = [Following]()
        guard let userID = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("tweets").observe(.childAdded) { snapshot, err  in
            //.childAdded monitors your database for anytime a new child is added. IE - a new tweet is added
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            //get user data
            let tweetID = snapshot.key
            
            var data = Following(isFollowing: false, followers: 0, following: 0)

            Database.database().reference().child("user-likes").child(userID).child(tweetID).observeSingleEvent(of: .value) { didLike in
                let didLike = didLike.exists()
                data.didLike = didLike
                Database.database().reference().child("user-retweets").child(userID).child(tweetID).observeSingleEvent(of: .value) { didRetweet, err  in
                    let didRetweet = didRetweet.exists()
                    data.didRetweet = didRetweet
                    Database.database().reference().child("user-bookmark").child(userID).child(tweetID).observeSingleEvent(of: .value) { didBookmark, err  in
                        let didBookmark = didBookmark.exists()
                        data.didBookmark = didBookmark
                        print(data)
                        followList.append(data)
                        completion(followList)
                        
                    }
                }
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
        let info = ["tweet": text, "uid": uid, "timestamp": Int(NSDate().timeIntervalSince1970), "likes": 0, "retweetCount": 0, "replyCount": 0] as [String : Any]
        Database.database().reference().child("tweet-replies").child(tweetUID).childByAutoId().updateChildValues(info) { (error, result) in
            if let error = error {
                completion(.failure(error))
            }
            guard let replieUID = result.key else { return }
            Database.database().reference().child("user-replies").child(uid).child(tweetUID).updateChildValues([replieUID: 1] as [String : Any]) { (error, result) in
                if let error = error {
                    completion(.failure(error))
                }
                Database.database().reference().child("tweet-replies").child(tweetUID).observe(.value) { replyCnt  in
                    let count = Int(replyCnt.childrenCount)
                    Database.database().reference().child("tweets").child(tweetUID).child("replyCount").setValue(count)
                    completion(.success("Nice work, you saved the tweet"))

                }
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
    
    func fetchUserLikes(withUser user: User, completion: @escaping ([Tweet])->()){
        var tweets = [Tweet]()
        Database.database().reference().child("user-likes").child(user.uid).observe(.childAdded) { tweetUID in
            let tweetID = tweetUID.key
            Database.database().reference().child("tweets").child(tweetID).observeSingleEvent(of: .value) { snapshot in
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                //get user data
                guard let uid = dictionary["uid"] as? String else { return }
                Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { userSnap, err  in
                    guard let userDict = userSnap.value as? [String: Any] else { return }
                    let user = User(uid: uid, user: userDict)
                    let tweetID = snapshot.key
                    var tweet = Tweet(user: user,tweetID: tweetID, tweetDict: dictionary)
                    print(tweet)
                    tweets.append(tweet)
                    completion(tweets)
                }
            }
        }
    }
    
    func fetchUserRetweets(withUser user: User, completion: @escaping ([Tweet])->()){
        var tweets = [Tweet]()
        Database.database().reference().child("user-retweets").child(user.uid).observe(.childAdded) { tweetUID in
            let tweetID = tweetUID.key
            Database.database().reference().child("tweets").child(tweetID).observeSingleEvent(of: .value) { snapshot in
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                guard let uid = dictionary["uid"] as? String else { return }  //get user data
                Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { userSnap, err  in
                    guard let userDict = userSnap.value as? [String: Any] else { return }
                    let user = User(uid: uid, user: userDict)
                    let tweetID = snapshot.key
                    var tweet = Tweet(user: user,tweetID: tweetID, tweetDict: dictionary)
                    print(tweet)
                    tweets.append(tweet)
                    completion(tweets)
                }
            }
        }
    }
    
    
    
    func likeTweet(tweet: Tweet, completion: @escaping (Int, Bool) -> Void){
        guard let userID = Auth.auth().currentUser?.uid else { return }
        print(tweet.followInfo!.didLike)
        print("tweet.likes \(tweet.likes)")
        let likes = !tweet.followInfo!.didLike ? tweet.likes + 1 : tweet.likes - 1
        print("\(tweet.likes) = \(likes)")
        Database.database().reference().child("tweets").child(tweet.tweetID).child("likes").setValue(likes)
        if !tweet.followInfo!.didLike {
            Database.database().reference().child("tweet-likes").child(tweet.tweetID).updateChildValues([userID : 1]) { (error, result) in
            }
            Database.database().reference().child("user-likes").child(userID).updateChildValues([tweet.tweetID : 1]) { (error, result) in
            }
        } else {
            Database.database().reference().child("tweet-likes").child(tweet.tweetID).child(userID).removeValue() { (error, ref)  in
            }
            Database.database().reference().child("user-likes").child(userID).child(tweet.tweetID).removeValue() { (error, ref)  in
            }
        }
        completion(likes, !tweet.followInfo!.didLike)
    }
    
    func reTweet(tweet: Tweet, completion: @escaping (Int, Bool) -> Void){
        guard let userID = Auth.auth().currentUser?.uid else { return }
        print(tweet.followInfo!.didRetweet)
        print("tweet.retweetCount \(tweet.retweetCount)")
        let retweetCount = !tweet.followInfo!.didRetweet ? tweet.retweetCount + 1 : tweet.retweetCount - 1
        print("\(tweet.retweetCount) = \(retweetCount)")
        Database.database().reference().child("tweets").child(tweet.tweetID).child("retweetCount").setValue(retweetCount)
        print(tweet)
        if !tweet.followInfo!.didRetweet {
            
            Database.database().reference().child("tweet-retweets").child(tweet.tweetID).updateChildValues([userID : 1]) { (error, result) in
            }
            Database.database().reference().child("user-retweets").child(userID).updateChildValues([tweet.tweetID : 1]) { (error, result) in
            }
        } else {
            Database.database().reference().child("tweet-retweets").child(tweet.tweetID).child(userID).removeValue() { (error, ref)  in
            }
            Database.database().reference().child("user-retweets").child(userID).child(tweet.tweetID).removeValue() { (error, ref)  in
            }
        }
        completion(retweetCount, !tweet.followInfo!.didRetweet)
    }
    
    func bookmarkTweet(tweet: Tweet, completion: @escaping (Bool) -> Void){
        guard let userID = Auth.auth().currentUser?.uid else { return }
        print(tweet.followInfo!.didBookmark)
        print(tweet)
        if !tweet.followInfo!.didBookmark {
            
            Database.database().reference().child("tweet-bookmark").child(tweet.tweetID).updateChildValues([userID : 1]) { (error, result) in
            }
            Database.database().reference().child("user-bookmark").child(userID).updateChildValues([tweet.tweetID : 1]) { (error, result) in
            }
        } else {
            Database.database().reference().child("tweet-bookmark").child(tweet.tweetID).child(userID).removeValue() { (error, ref)  in
            }
            Database.database().reference().child("user-bookmark").child(userID).child(tweet.tweetID).removeValue() { (error, ref)  in
            }
        }
        completion(!tweet.followInfo!.didBookmark)

    }
    
    func deleteTweet(tweet: Tweet, completion: @escaping (Result<String, Error>) -> ()){
        Database.database().reference().child("tweets").child(tweet.tweetID).removeValue() { (error, ref)  in
            if let error = error {
                completion(.failure(error))
            }
            completion(.success("Successfully Deleted Tweet"))
        }
    
    }
    
}
