//
//  TweetCell.swift
//  positiveVibes
//
//  Created by Beau Enslow on 3/14/24.
//

import UIKit
import SDWebImage

protocol MainFeedControllerCellDelegate: AnyObject {
    func infoLabelPressedSegue(_ tweet: Tweet)
    func userProfImgPressSegue(_ cell: TweetCell)
    func commentBtnPressedSegue(_ tweet: Tweet)
 }

class TweetCell: UICollectionViewCell {
    

    //MARK: - Properties    
    weak var delegate : MainFeedControllerCellDelegate?
    
    var tweet: Tweet? {
        didSet{ configTweet() }
    }
    
    
    private lazy var profileImg: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .twitterBlue
        iv.setDimensions(width: 38, height: 38)
        iv.layer.cornerRadius = 38 / 2
        iv.layer.masksToBounds = true
        //add lazy variable if your adding a tap gesture to a property
        let imgTap = UITapGestureRecognizer(target: self, action: #selector(profileImgPressed))
        iv.addGestureRecognizer(imgTap)
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private let tweetMsg: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
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
        
        //set a fixed width for the collection view cell
        widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width).isActive = true
                    
        addSubview(profileImg)
        profileImg.anchor(top: topAnchor, left: leftAnchor, paddingTop: 2, paddingLeft: 10)
                
        let labelStack = UIStackView(arrangedSubviews: [infoLabel, optionsBtn])
        labelStack.axis = .horizontal
        labelStack.distribution = .equalSpacing

        
        let iconStack = UIStackView(arrangedSubviews: [commentBtn, retweetBtn, likeBtn, bookmarkBtn, shareBtn])
        iconStack.axis = .horizontal
        iconStack.distribution = .equalSpacing
//        iconStack.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        let vertStack = UIStackView(arrangedSubviews: [labelStack, tweetMsg, iconStack])
        vertStack.axis = .vertical
        vertStack.spacing = 8
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
        delegate?.userProfImgPressSegue(self)
    }
    
    @objc func infoLabelPressed(){
        print("infoLabelPressed")
        guard let tweet = tweet else { return }
        delegate?.infoLabelPressedSegue(tweet)
    }
    
    @objc func commentBtnPressed(){
        print("commentBtnPressed")
        guard let tweet = tweet else { return }
        delegate?.commentBtnPressedSegue(tweet)

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

        tweetMsg.text = tweet.tweet // Tweet msg
        
        guard let getUrlFromUserImgString = URL(string: tweet.user.profileImgUrl) else { return } // Image
        profileImg.sd_setImage(with: getUrlFromUserImgString)

        
        let viewModel = TweetViewModel(tweet: tweet) //info label
        infoLabel.attributedText = viewModel.userInfoText
        infoLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(infoLabelPressed))
        infoLabel.addGestureRecognizer(tap)
        
        
    }
    
    
}
