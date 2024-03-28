//
//  SingleTweetViewModel.swift
//  positiveVibes
//
//  Created by Beau Enslow on 3/27/24.
//

import UIKit

class SingleTweetViewModel {
    
    private let tweet: Tweet
    
    init(tweet: Tweet) {
        self.tweet = tweet
    }
    
    var check: UIImage {
        let iv = UIImage(systemName: "checkmark.seal.fill", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 14)))?.withTintColor(.twitterBlue, renderingMode: .alwaysOriginal)
        return iv ?? UIImage()
    }
    
    var fullNameLabel: NSAttributedString {
        let title = NSMutableAttributedString(string: "\(tweet.user.fullName) ", attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        let checkImg = NSTextAttachment()
        checkImg.image = check
        let checkMark = NSAttributedString(attachment: checkImg)
        title.append(checkMark)
        return title
    }
    
}
