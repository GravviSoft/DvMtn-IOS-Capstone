//
//  UserService.swift
//  positiveVibes
//
//  Created by Beau Enslow on 3/11/24.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class UserService {
    
    static let shared = UserService()
    
    func fetchUser(completion: @escaping (User) -> ()){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let user = User(uid: uid, user: dictionary)
            completion(user)
        }
    }
    
    func fetchAllUsers(completion: @escaping ([User]) -> Void){
        var users = [User]()
        Database.database().reference().child("users").observe(.childAdded) { snapshot in
            let userUID = snapshot.key
            Database.database().reference().child("users").child(userUID).observeSingleEvent(of: .value) { usersnap in
                guard let dict = usersnap.value as? [String: Any] else { return }
                let user = User(uid: userUID, user: dict)
                users.append(user)
                completion(users)
            }
        }
    }
    
    func followUser(uid: String, completion: @escaping (Result<String, Error>) -> () ) {
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        print("THis is current User ID \(currentUID)    THis is the uid from profile: \(uid)")
        Database.database().reference().child("user-followers").child(uid).updateChildValues([currentUID: 1])  { (error, ref)  in
            if let error = error {
                completion(.failure(error))
            }
        }
        Database.database().reference().child("user-following").child(currentUID).updateChildValues([uid: 1])  { (error, ref)  in
            if let error = error {
                completion(.failure(error))
            }
        }
        completion(.success("Successfully Followed User"))
        
    }
    
    func unfollowUser(uid: String, completion: @escaping (Result<String, Error>) -> ()) {
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        print("THis is current User ID \(currentUID)    THis is the uid from profile: \(uid)")
        Database.database().reference().child("user-followers").child(uid).child(currentUID).removeValue() { (error, ref)  in
            if let error = error {
                completion(.failure(error))
            }
        }
        Database.database().reference().child("user-following").child(currentUID).child(uid).removeValue() { (error, ref)  in
            if let error = error {
                completion(.failure(error))
            }
        }
        completion(.success("Successfully Unfollowed User"))

    }
    
    func checkFollowing(uid: String, completion: @escaping (Following) -> ()) {
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
//        Database.database().reference().child("user-following").child(uid).observeSingleEvent(of: .value) { snap in
//            print("\(snap.children.allObjects.count)")
//        }
        Database.database().reference().child("user-followers").child(uid).observe(.value) { followers  in
            Database.database().reference().child("user-following").child(uid).observe(.value) { following, text   in
                Database.database().reference().child("user-followers").child(uid).child(currentUID).observeSingleEvent(of: .value) { snapshot in
                    print("SNAPSHOt Exists: \(snapshot.exists())")
                    let isFollowing = snapshot.exists()
//                    guard let snapBool = snapshot.value else { return }
//                    let isFollowing = snapBool is NSNull ? false : true
                    let data = Following(isFollowing: isFollowing, followers: Int(following.childrenCount), following: Int(followers.childrenCount))
                    completion(data)
                }
            }
        }
    }
}
