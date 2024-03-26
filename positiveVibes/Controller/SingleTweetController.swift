//
//  SingleTweetController.swift
//  positiveVibes
//
//  Created by Beau Enslow on 3/22/24.
//

import UIKit

class SingleTweetController: UICollectionViewController {
    
    //MARK: - Properties
    private let tweet: Tweet
    
    private let profileImg: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .twitterBlue
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48 / 2
        iv.layer.masksToBounds = true
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
        button.setImage(UIImage(systemName: "ellipsis", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 10.0))), for: .normal)
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
    init(tweet: Tweet) {
        self.tweet = tweet
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    
    //MARK: - Selectors
    @objc func backBtnPressed(){
        dismiss(animated: true, completion: nil)
    }
    
    
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
    func configUI(){
        view.backgroundColor = .twitterBlue
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: K.reuseTweetCellId)
        configNavBar()
//        
//        view.addSubview(profileImg) //img
//        let getUrlFromUserImgString = URL(string: tweet.user.profileImgUrl)
//        profileImg.sd_setImage(with: getUrlFromUserImgString)
//        profileImg.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 10)
//                
//        
////        configInfoLabel() //label
//        view.addSubview(infoLabel)
//        infoLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: profileImg.rightAnchor)
//        
//        tweetMsg.text = tweet.tweet // Tweet msg
//
//
//        let labelStack = UIStackView(arrangedSubviews: [infoLabel, optionsBtn])
//        labelStack.axis = .horizontal
//        labelStack.distribution = .equalSpacing
//        
//        view.addSubview(labelStack)
//        labelStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: profileImg.rightAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 12, paddingRight: 12)
//        let iconStack = UIStackView(arrangedSubviews: [commentBtn, retweetBtn, likeBtn, bookmarkBtn, shareBtn])
//        iconStack.axis = .horizontal
//        iconStack.distribution = .equalSpacing
////        
//        let vertStack = UIStackView(arrangedSubviews: [tweetMsg, iconStack])
//        vertStack.axis = .vertical
//        vertStack.spacing = 15
////
//        view.addSubview(vertStack)
//        vertStack.anchor(top: profileImg.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 25,  paddingLeft: 12, paddingRight: 10)
        
    }
    
    func configNavBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backBtnPressed)) // left
        navigationItem.leftBarButtonItem?.tintColor = .iconBadgeTheme
    
        navigationItem.title = "Post"  //center
    }
//    
//    func configInfoLabel(){
//        let viewModel = TweetViewModel(tweet: tweet) //info label
//        infoLabel.attributedText = viewModel.userInfoText
////        infoLabel.isUserInteractionEnabled = true
////        let tap = UITapGestureRecognizer(target: self, action: #selector(infoLabelPressed))
////        infoLabel.addGestureRecognizer(tap)
//    }
//    
//    func configLine(){
//        let line = UIView()
//        line.backgroundColor = .systemGray
//        view.addSubview(line)
////        line.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 0.18)
//    }
}



//MARK: - UICollectionViewDataSource - TweetCell
extension SingleTweetController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.reuseTweetCellId, for: indexPath) as! TweetCell
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension SingleTweetController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 350)
    }
    
}
