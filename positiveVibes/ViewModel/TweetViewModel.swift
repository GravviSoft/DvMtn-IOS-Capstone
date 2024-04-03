//
//  TweetViewModel.swift
//  positiveVibes
//
//  Created by Beau Enslow on 3/19/24.
//


import UIKit

struct TweetViewModel {
    let tweet: Tweet
    let user: User
    
    
    var timestamp: String{
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: tweet.timestamp, to: now) ?? "2m"
    }
    
    var check: UIImage {
        let iv = UIImage(systemName: "checkmark.seal.fill", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 12.0)))?.withTintColor(.twitterBlue, renderingMode: .alwaysOriginal)
        return iv ?? UIImage()
    }

    
    var userInfoText: NSAttributedString {
        let title = NSMutableAttributedString(string: "\(user.fullName) ", attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
       
        let checkImg = NSTextAttachment()
        checkImg.image = check
        let checkMark = NSAttributedString(attachment: checkImg)
        title.append(checkMark)
        
        title.append(NSAttributedString(string: " @\(user.userName)", attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
        title.append(NSAttributedString(string: " · \(timestamp)", attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return title
    }
    
    init(tweet: Tweet) {
        self.tweet = tweet
        self.user = tweet.user
        
    }
    
    func cellAutoSize(forWidth width: CGFloat) -> CGSize{
        let measureLabel = UILabel()
        measureLabel.text = tweet.tweet
        measureLabel.numberOfLines = 0
        measureLabel.lineBreakMode = .byWordWrapping
        measureLabel.translatesAutoresizingMaskIntoConstraints  = false
        measureLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        return measureLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
    func headerAutoSize(withText text: String, forWidth width: CGFloat) -> CGSize{
        let measureLabel = UILabel()
        measureLabel.text = text
        measureLabel.numberOfLines = 0
        measureLabel.lineBreakMode = .byWordWrapping
        measureLabel.translatesAutoresizingMaskIntoConstraints  = false
        measureLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        return measureLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

    }
    
}
