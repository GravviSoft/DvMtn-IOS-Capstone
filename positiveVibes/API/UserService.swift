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
        print(uid)
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { snapshot in
            print(snapshot)
            guard let dictionary = snapshot.value as? [String: Any] else { return }
//            print(dictionary)
            let user = User(uid: uid, user: dictionary)
            completion(user)
//            print(user)
//            print(user.email)
        }
    }
}
