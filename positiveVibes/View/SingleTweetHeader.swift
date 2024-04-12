//
//  SingleTweetHeader.swift
//  positiveVibes
//
//  Created by Beau Enslow on 3/27/24.
//

import UIKit
import SDWebImage

protocol SingleTweetHeaderDelegate: AnyObject {
    func showActionSheet()
    func showTweetUserProf()
    func handleSingleComment(_ tweet: Tweet)
    func handleSingleLike(_ tweet: Tweet)
    func handleSingleRetweet(_ tweet: Tweet)
    func handleSingleBookMark(_ tweet: Tweet)

}


class SingleTweetHeader: UICollectionReusableView {
    //MARK: - Properties
    weak var delegate: SingleTweetHeaderDelegate?
    
    var tweet: Tweet?{
        didSet{
//            print("Tweet info for this cell: \(tweet)")
            configTweet()
        }
    }
    
    var commentCount: Int?{
        didSet{
            setReplyCount()
        }
    }
    
    
    private lazy var profileImg: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .twitterBlue
        iv.setDimensions(width: 50, height: 50)
        iv.layer.cornerRadius = 50 / 2
        iv.layer.masksToBounds = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(profileImgPressed))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
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
    
    private lazy var tweetMsg: UILabel = {
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
     
    var commentLabel:  UILabel = {
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
    
//    private let commentBtn: UIButton = {
//        let button = UIButton(type: .system)
//        button.setImage(UIImage(systemName: "bubble", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 14.0))), for: .normal)
//        button.tintColor = .systemGray
////        button.setDimensions(width: 20, height: 20)
//        button.addTarget(self, action: #selector(commentBtnPressed), for: .touchUpInside)
//        return button
//    }()
//    
//    private let retweetBtn: UIButton = {
//        let button = UIButton(type: .system)
//        button.setImage(UIImage(systemName: "arrow.counterclockwise", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 14.0))), for: .normal)
//        button.tintColor = .systemGray
////        button.setDimensions(width: 20, height: 20)
//        button.addTarget(self, action: #selector(retweetBtnPressed), for: .touchUpInside)
//        return button
//    }()
//    
//    private let likeBtn: UIButton = {
//        let button = UIButton(type: .system)
//        button.setImage(UIImage(systemName: "suit.heart", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 14.0))), for: .normal)
//        button.tintColor = .systemGray
////        button.setDimensions(width: 20, height: 20)
//        button.addTarget(self, action: #selector(likeBtnPressed), for: .touchUpInside)
//        return button
//    }()
//    
//    private let bookmarkBtn: UIButton = {
//        let button = UIButton(type: .system)
//        button.setImage(UIImage(systemName: "bookmark", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 14.0))), for: .normal)
//        button.tintColor = .systemGray
////        button.setDimensions(width: 20, height: 20)
//        button.addTarget(self, action: #selector(bookmarkBtnPressed), for: .touchUpInside)
//        return button
//    }()
//    
//    private let shareBtn: UIButton = {
//        let button = UIButton(type: .system)
//        button.setImage(UIImage(systemName: "rectangle.portrait.and.arrow.forward", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 14.0))), for: .normal)
//        button.tintColor = .systemGray
////        button.setDimensions(width: 20, height: 20)
//        button.addTarget(self, action: #selector(shareBtnPressed), for: .touchUpInside)
//        return button
//    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return label
    }()
    
    private lazy var followInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return label
    }()
    
    private lazy var dateLine: UIView = {
        let line = UIView()
        line.backgroundColor = .lightGray
        line.heightAnchor.constraint(equalToConstant: 0.35).isActive = true
        return line
    }()
    
    private lazy var infoLine: UIView = {
        let line = UIView()
        line.backgroundColor = .lightGray
        line.heightAnchor.constraint(equalToConstant: 0.35).isActive = true
        return line
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .vibeTheme1
        
        
        addSubview(profileImg) //img
//        let getUrlFromUserImgString = URL(string: tweet.user.profileImgUrl)
//        profileImg.sd_setImage(with: getUrlFromUserImgString)
        profileImg.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, paddingTop: 20, paddingLeft: 10)

//        profileImg.widthAnchor.constraint(equalToConstant: 50).isActive = true
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
        let comStack = UIStackView(arrangedSubviews: [commentBtn, commentLabel])
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
//        iconStack.heightAnchor.constraint(equalToConstant: 25).isActive = true
//
        
        
        
        let vertStack = UIStackView(arrangedSubviews: [tweetMsg, timeLabel, dateLine, followInfoLabel, infoLine, iconStack])
        vertStack.axis = .vertical
        vertStack.spacing = 10
//
        addSubview(vertStack)
//        vertStack.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 45,  paddingLeft: 20, paddingBottom: 15, paddingRight: 20)
//        
//        widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width).isActive = true
        
        
        vertStack.anchor(top: profileImg.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 15,  paddingLeft: 20, paddingBottom: 15, paddingRight: 20)

//        let indexPath = IndexPath(row: 0, section: section)
//        lazy var headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath) as? SingleTweetHeader

        // Use this view to calculate the optimal size based on the collection view's width
//        setDimensions(width: UIScreen.main.bounds.size.width, height: <#T##CGFloat#>)
//        systemLayoutSizeFitting(CGSize(width: frame.width, height: UIView.layoutFittingExpandedSize.height),
//                                                    withHorizontalFittingPriority: .required, // Width is fixed
//                                                    verticalFittingPriority: .fittingSizeLevel)
//        profileImg.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        widthAnchor.constraint(equalToConstant: 0).isActive = true
//        updateConstraintsIfNeeded()
////        translatesAutoResizingMaskIntoConstraints()
//        translatesAutoresizingMaskIntoConstraints = true
        layoutIfNeeded()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func optionBtnPressed(){
        print("optionBtnPressed")
        delegate?.showActionSheet()
    }
    
    @objc func profileImgPressed(){
        print("Profile image pressed")
        delegate?.showTweetUserProf()
    }
    
    @objc func commentBtnPressed(){
        guard let tweet = tweet else { return }
        delegate?.handleSingleComment(tweet)
        Utilities().animateIcon(self.commentBtn)

    }
    
    @objc func retweetBtnPressed(){
        guard let tweet = tweet else { return }
        delegate?.handleSingleRetweet(tweet)
        Utilities().animateIcon(self.retweetBtn)
    }
    @objc func likeBtnPressed(){
        guard let tweet = tweet else { return }
        delegate?.handleSingleLike(tweet)
        Utilities().animateIcon(self.likeBtn)
    }
    
    @objc func bookmarkBtnPressed(){
        guard let tweet = tweet else { return }
        delegate?.handleSingleBookMark(tweet)
        Utilities().animateIcon(self.bookmarkBtn)
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
    
    

    
    func configTweet(){
        guard let tweet = tweet else { return }
        let image = URL(string: tweet.user.profileImgUrl)
        profileImg.sd_setImage(with: image)
        
        let vm = SingleTweetViewModel(tweet: tweet)
        fullName.attributedText = vm.fullNameLabel
        userName.text = "@\(tweet.user.userName)"
        tweetMsg.text = tweet.tweet
        timeLabel.text = vm.time
        followInfoLabel.attributedText = vm.followInfoLabel
        
        
        likeBtn.tintColor = vm.likButtonTint
        likeBtn.setImage(vm.likeBtnImage, for: .normal)
        
        retweetBtn.tintColor = vm.retweetColor
        retweetBtn.setImage(vm.retweetImg, for: .normal)
        
        bookmarkBtn.tintColor = vm.bookmarkColor
        bookmarkBtn.setImage(vm.bookmarkImg, for: .normal)

        likeCount.text = "\(tweet.likes)"
        retweetCount.text = "\(tweet.retweetCount)"

//        optionsBtn.menu = viewModel.menu
//        optionsBtn.showsMenuAsPrimaryAction = true
    }
    
    func setReplyCount(){
        guard let commentCount = commentCount else { return }
        commentLabel.text = "\(commentCount)"
    }
}
