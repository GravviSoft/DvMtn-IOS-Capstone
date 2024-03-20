//
//  TweetCell.swift
//  positiveVibes
//
//  Created by Beau Enslow on 3/14/24.
//

import UIKit
import SDWebImage

class TweetCell: UICollectionViewCell {
    

    //MARK: - Properties    
    var tweet: Tweet? {
        didSet{ configTweet() }
    }
    
//    var user: User?{
//        didSet{ configUser() }
//    }
    
    private let profileImg: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .twitterBlue
        iv.setDimensions(width: 38, height: 38)
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 38 / 2
        return iv
    }()
    
    private let tweetMsg: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        label.text = "ful lname https:// fireba sest orag e.googleapis .com:443/v0/ b/vibe-fd573.app spot.com/o/prof ile_images%2FE9282 F6A-748 3-4258- 80AA-4B 1D80 37E282? alt= med ia&t oken=db84c 094-10f3-4e f8-b7 28- f7d4 5d 3e1 106 ful lname https:// fireba sest orag e.googleapis \n 3/v0/ b/vibe-fd573.app spot.com/o/prof ile_images%2FE9282 F6A-748 3-4258- 80AA-4B 1D80 37E282? alt= med ia&t oken=db84c 094-10f3-4e f8-b7 28- f7d4 5d 3e1 106"

        return label
    }()
    
    private let infoLabel = UILabel()
    
    private let optionsBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .iconBadgeTheme
        button.addTarget(self, action: #selector(optionBtnPressed), for: .touchUpInside)
        return button
    }()
    
    
    private let commentBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bubble"), for: .normal)
        button.tintColor = .iconBadgeTheme
        button.addTarget(self, action: #selector(commentBtnPressed), for: .touchUpInside)
        return button
    }()
    
    private let retweetBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.2.squarepath"), for: .normal)
        button.tintColor = .iconBadgeTheme
        button.addTarget(self, action: #selector(retweetBtnPressed), for: .touchUpInside)
        return button
    }()
    
    private let likeBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "suit.heart"), for: .normal)
        button.tintColor = .iconBadgeTheme
        button.addTarget(self, action: #selector(likeBtnPressed), for: .touchUpInside)
        return button
    }()
    
    private let bookmarkBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.tintColor = .iconBadgeTheme
        button.addTarget(self, action: #selector(bookmarkBtnPressed), for: .touchUpInside)
        return button
    }()
    
    private let shareBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .iconBadgeTheme
        button.addTarget(self, action: #selector(shareBtnPressed), for: .touchUpInside)
        return button
    }()
    
    

    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        backgroundColor = .vibeTheme1
            
        addSubview(profileImg)
        profileImg.anchor(top: topAnchor, left: leftAnchor, paddingTop: 2, paddingLeft: 10)
                
        let labelStack = UIStackView(arrangedSubviews: [infoLabel, optionsBtn])
        labelStack.axis = .horizontal
        labelStack.distribution = .equalSpacing

        
        let iconStack = UIStackView(arrangedSubviews: [commentBtn, retweetBtn, likeBtn, bookmarkBtn, shareBtn])
        iconStack.axis = .horizontal
        iconStack.distribution = .equalSpacing
        
        let vertStack = UIStackView(arrangedSubviews: [labelStack, tweetMsg, iconStack])
        vertStack.axis = .vertical
        vertStack.spacing = 2
//        vertStack.distribution = .equalSpacing
        addSubview(vertStack)
        vertStack.anchor(top: topAnchor, left: profileImg.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4,  paddingLeft: 12, paddingBottom: 12, paddingRight: 10)
             
        configLine()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Selectors
    @objc func optionBtnPressed(){
        print("optionBtnPressed")
    }
    
    @objc func profileImgPressed(){
        print("Profile image pressed")
    }
    
    @objc func commentBtnPressed(){
        print("commentBtnPressed")
    }
    
    @objc func retweetBtnPressed(){
        print("retweetBtnPressed")
    }
    @objc func likeBtnPressed(){
        print("likeBtnPressed")
    }
    
    @objc func bookmarkBtnPressed(){
        print("bookmarkBtnPressed")
    }
    @objc func shareBtnPressed(){
        print("shareBtnPressed")
    }
    
    
    //MARK: - Helpers
    func configLine(){
        let line = UIView()
        line.backgroundColor = .systemGray
        addSubview(line)
        line.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 0.18)
    }
    
    
    func configTweet(){
        guard let tweet = tweet else { return }

        tweetMsg.text = tweet.tweet
        
        guard let getUrlFromUserImgString = URL(string: tweet.user.profileImgUrl) else { return }
        profileImg.sd_setImage(with: getUrlFromUserImgString)
        
        let viewModel = TweetViewModel(tweet: tweet)
        infoLabel.attributedText = viewModel.userInfoText
        
    }
    
    
}
