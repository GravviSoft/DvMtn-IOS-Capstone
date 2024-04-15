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
    func feedActionLauncher(_ tweet: Tweet)
    func handleLikeBtn(_ cell: TweetCell)
    func handleRetweetBtn(_ cell: TweetCell)
    func handleBookMarkBtn(_ cell: TweetCell)
    func handleReport(_ cell: TweetCell)
    func handleDeleteTweet(_ cell: TweetCell)
    func handleFollow(_ cell: TweetCell)
    func handleUnfollow(_ cell: TweetCell)
 }

class TweetCell: UICollectionViewCell {
    

    //MARK: - Properties    
    weak var delegate : MainFeedControllerCellDelegate?
    

    
    var tweet: Tweet? {
        didSet{ configTweet() }
    }
      
    private lazy var profileImg: UIImageView = {
        let iv = UIImageView()
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
    
    var commentCount:  UILabel = {
       let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let likeCount:  UILabel = {
       let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let retweetCount:  UILabel = {
       let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()


    private lazy var optionsBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .iconBadgeTheme
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
        
        let comStack = UIStackView(arrangedSubviews: [commentBtn, commentCount])
        comStack.axis = .horizontal
        comStack.spacing = 5
        let retweetStack = UIStackView(arrangedSubviews: [retweetBtn, retweetCount])
        retweetStack.axis = .horizontal
        retweetStack.spacing = 5
        let likeStack = UIStackView(arrangedSubviews: [likeBtn, likeCount])
        likeStack.axis = .horizontal
        likeStack.spacing = 5

        let iconStack = UIStackView(arrangedSubviews: [comStack, retweetStack, likeStack, bookmarkBtn])
        iconStack.axis = .horizontal
        iconStack.distribution = .equalSpacing
        
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
        guard let tweet = tweet else { return }
        delegate?.feedActionLauncher(tweet)
    }
    
    @objc func profileImgPressed(){
        delegate?.userProfImgPressSegue(self)
    }
    
    @objc func infoLabelPressed(){
        guard let tweet = tweet else { return }
        delegate?.infoLabelPressedSegue(tweet)
    }
    
    @objc func commentBtnPressed(){
        guard let tweet = tweet else { return }
        delegate?.commentBtnPressedSegue(tweet)
//        Utilities().animateIcon(self.commentBtn)

    }
    
    @objc func retweetBtnPressed(){
        delegate?.handleRetweetBtn(self)
//        Utilities().animateIcon(self.retweetBtn)
    }
    @objc func likeBtnPressed(){
        delegate?.handleLikeBtn(self)
//        Utilities().animateIcon(self.likeBtn)
    }
    
    @objc func bookmarkBtnPressed(){
        delegate?.handleBookMarkBtn(self)
//        Utilities().animateIcon(self.bookmarkBtn)
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

        let viewModel = TweetViewModel(tweet: tweet, delegate: delegate, tweetCell: self) //info label
        infoLabel.attributedText = viewModel.userInfoText
        infoLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(infoLabelPressed))
        infoLabel.addGestureRecognizer(tap)
        
        likeBtn.tintColor = viewModel.likButtonTint
        likeBtn.setImage(viewModel.likeBtnImage, for: .normal)
        likeCount.text = "\(tweet.likes)"
        
        retweetBtn.tintColor = viewModel.retweetColor
        retweetBtn.setImage(viewModel.retweetImg, for: .normal)
        retweetCount.text = "\(tweet.retweetCount)"
        
        bookmarkBtn.tintColor = viewModel.bookmarkColor
        bookmarkBtn.setImage(viewModel.bookmarkImg, for: .normal)
        
        optionsBtn.menu = viewModel.menu
        optionsBtn.showsMenuAsPrimaryAction = true
        
        commentCount.text = "\(tweet.replyCount)"
        
    }
    
}
