//
//  User.swift
//  positiveVibes
//
//  Created by Beau Enslow on 3/11/24.
//

import UIKit

struct User {
    let email: String
    let fullName: String
    let userName: String
    let profileImgUrl: String
    let uid: String
    
    init(uid: String, user: [String: Any]) {
        self.uid = uid
        self.email = user["email"] as? String ?? ""
        self.fullName = user["fullname"] as? String ?? ""
        self.userName = user["username"] as? String ?? ""
        self.profileImgUrl = user["profileImgUrl"] as? String ?? ""
    }
}
