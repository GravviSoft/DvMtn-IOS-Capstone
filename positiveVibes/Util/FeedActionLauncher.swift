//
//  FeedActionLauncher.swift
//  positiveVibes
//
//  Created by Beau Enslow on 4/8/24.
//

import UIKit

class FeedActionLauncher: NSObject {
    //MARK: - Properties
    private let user: User
    
    //MARK: - Lifecycle
    init(user: User) {
        self.user = user
    }
    
    //MARK: - Helper
    func show(){
        print("Show account options")
        print(user)
    }
}


