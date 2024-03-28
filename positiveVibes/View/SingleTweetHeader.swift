//
//  SingleTweetHeader.swift
//  positiveVibes
//
//  Created by Beau Enslow on 3/27/24.
//

import UIKit
import SDWebImage



class SingleTweetHeader: UICollectionReusableView {
    //MARK: - Properties
    
    
    var tweet: Tweet?{
        didSet{
            print("Tweet info for this cell: \(tweet)")
            configTweet()
        }
    }
    
    private lazy var profileImg: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .twitterBlue
        iv.setDimensions(width: 50, height: 50)
        iv.layer.cornerRadius = 50 / 2
        iv.layer.masksToBounds = true
        return iv
    }()
    
    private let fullName: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .iconBadgeTheme
        label.text = "Beau Enslow"
        return label
    }()
    
    private let userName: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.text = "@bobby"
        return label
    }()
    
    private let tweetMsg: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
//        label.preferredMaxLayoutWidth = view.frame.width // max width
        label.text = "This is a sample text.\nWith a second line!" // the text to display in the label

//        let height = label.intrinsicContentSize.height
//        print("THis is the height \(height)")
        
        return label
    }()
    
    private let infoLabel = UILabel()
    
    private let optionsBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "ellipsis", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 14.0))), for: .normal)
        button.tintColor = .iconBadgeTheme
        button.addTarget(self, action: #selector(optionBtnPressed), for: .touchUpInside)
        return button
    }()
    
    
    private let commentBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bubble"), for: .normal)
        button.tintColor = .systemGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(commentBtnPressed), for: .touchUpInside)
        return button
    }()
    
    private let retweetBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.counterclockwise"), for: .normal)
        button.tintColor = .systemGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(retweetBtnPressed), for: .touchUpInside)
        return button
    }()
    
    private let likeBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "suit.heart"), for: .normal)
        button.tintColor = .systemGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(likeBtnPressed), for: .touchUpInside)
        return button
    }()
    
    private let bookmarkBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.tintColor = .systemGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(bookmarkBtnPressed), for: .touchUpInside)
        return button
    }()
    
    private let shareBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.arrow.up.on.square"), for: .normal)
        button.tintColor = .systemGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(shareBtnPressed), for: .touchUpInside)
        return button
    }()
    
    
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .vibeTheme1
        
        
        addSubview(profileImg) //img
//        let getUrlFromUserImgString = URL(string: tweet.user.profileImgUrl)
//        profileImg.sd_setImage(with: getUrlFromUserImgString)
        profileImg.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, paddingTop: 20, paddingLeft: 10)


//        configInfoLabel() //label
        addSubview(fullName)
//        fullName.anchor(top: safeAreaLayoutGuide.topAnchor, left: profileImg.rightAnchor)

//        tweetMsg.text = tweet.tweet // Tweet msg


        let labelStack = UIStackView(arrangedSubviews: [fullName, optionsBtn])
        labelStack.axis = .horizontal
        labelStack.distribution = .equalSpacing
        
        let nameStack = UIStackView(arrangedSubviews: [labelStack, userName])
        nameStack.axis = .vertical
        nameStack.spacing = 2
        addSubview(nameStack)
        

//        addSubview(labelStack)
        nameStack.anchor(top: safeAreaLayoutGuide.topAnchor, left: profileImg.rightAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 12, paddingRight: 12)
        let iconStack = UIStackView(arrangedSubviews: [commentBtn, retweetBtn, likeBtn, bookmarkBtn, shareBtn])
        iconStack.axis = .horizontal
        iconStack.distribution = .equalSpacing
//
        let vertStack = UIStackView(arrangedSubviews: [tweetMsg, iconStack])
        vertStack.axis = .vertical
        vertStack.spacing = 10
//
        addSubview(vertStack)
        vertStack.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 45,  paddingLeft: 12, paddingRight: 10)
        
        widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width).isActive = true
//        heightAnchor.constraint(equalToConstant:  )
//        setNeedsLayout()
//        layoutIfNeeded()
//        systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

//        systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
//        systemLayoutSizeFitting(frame)
        
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
//        guard let tweet = tweet else { return }
//        self.delegate?.userProfImgPressSegue(tweet: tweet)
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
    
    @objc func infoLabelPressed(){
        print("infoLabelPressed")
//        guard let tweet = tweet else { return }
//        delegate?.infoLabelPressedSegue(tweet: tweet)
//
    }
    
    
    //MARK: - Helpers
    func configTweet(){
        guard let tweet = tweet else { return }
        let image = URL(string: tweet.user.profileImgUrl)
        profileImg.sd_setImage(with: image)
        
        
        let vm = SingleTweetViewModel(tweet: tweet)
        fullName.attributedText = vm.fullNameLabel
        userName.text = "@\(tweet.user.userName)"
        tweetMsg.text = tweet.tweet

    }
    
}
