//
//  Following.swift
//  positiveVibes
//
//  Created by Beau Enslow on 4/1/24.
//

import UIKit

struct Following {
    var isFollowing: Bool
    var followers: Int
    var following: Int
    
    init(isFollowing: Bool, followers: Int, following: Int) {
        self.isFollowing = isFollowing
        self.followers = followers
        self.following = following
    }
}
