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
    
    var time:  String{
        let date = DateFormatter()
        date.dateFormat = "h:mm a • MM/dd/yyyy"
        return date.string(from: tweet.timestamp)
    }
    
    var check: UIImage {
        let iv = UIImage(systemName: "checkmark.seal.fill", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 14)))?.withTintColor(.twitterBlue, renderingMode: .alwaysOriginal)
        return iv ?? UIImage()
    }
//    var commentLbl: String {
//        return "\(tweet.retweetCount)"
//    }
    
    var fullNameLabel: NSAttributedString {
        let title = NSMutableAttributedString(string: "\(tweet.user.fullName) ", attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        let checkImg = NSTextAttachment()
        checkImg.image = check
        let checkMark = NSAttributedString(attachment: checkImg)
        title.append(checkMark)
        return title
    }
    
    var followInfoLabel: NSAttributedString  {
        let title = NSMutableAttributedString(string: "\(tweet.user.followers)", attributes: [.font : UIFont.boldSystemFont(ofSize: 12), .foregroundColor: UIColor.iconBadgeTheme.cgColor])
        title.append(NSAttributedString(string: " Following ", attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        let following = NSMutableAttributedString(string: "\(tweet.user.following)", attributes: [.font : UIFont.boldSystemFont(ofSize: 12), .foregroundColor: UIColor.iconBadgeTheme.cgColor])
        following.append(NSAttributedString(string: " Followers", attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        title.append(following)
        return title
    }

    
    var likButtonTint: UIColor {
        return tweet.followInfo?.didLike ?? false ? .red : .lightGray
    }
    
    var likeBtnImage: UIImage {
        let iv = UIImage(systemName: tweet.followInfo?.didLike ?? false ? "heart.fill" : "heart")
        return iv!
    }

    
    var retweetColor: UIColor {
        return tweet.followInfo?.didRetweet ?? false ? .green : .lightGray
    }
    
    var retweetImg: UIImage {
        let iv = UIImage(systemName: tweet.followInfo?.didRetweet ?? false ? "gobackward" : "gobackward")
        return iv!
    }
    
    
    var bookmarkColor: UIColor {
        return tweet.followInfo?.didBookmark ?? false ? .twitterBlue : .lightGray
    }
    
    var bookmarkImg: UIImage {
        let iv = UIImage(systemName: tweet.followInfo?.didBookmark ?? false ? "bookmark.fill" : "bookmark")
        return iv!
    }
    
    
    
    func headerAutoSize(forWidth width: CGFloat) -> CGSize{
        let measureLabel = UILabel()
        measureLabel.text = tweet.tweet
        let numLines = tweet.tweet.lines(font: UIFont.systemFont(ofSize: 14), width: width)
        print("NUMBER OF LINES \(numLines)")
        measureLabel.numberOfLines = numLines
//        measureLabel.numberOfLines = 0

        measureLabel.lineBreakMode = .byWordWrapping
        measureLabel.translatesAutoresizingMaskIntoConstraints  = false
//        measureLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
//        measureLabel.sizeToFit()
//        return measureLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return measureLabel.systemLayoutSizeFitting(CGSize(width: width, height: UIView.layoutFittingExpandedSize.height),
                                              withHorizontalFittingPriority: .required, // Width is fixed
                                                    verticalFittingPriority: .fittingSizeLevel)

    }
    
}

extension String {
    func lines(font : UIFont, width : CGFloat) -> Int {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude);
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil);
        return Int(boundingBox.height/font.lineHeight);
    }
}


