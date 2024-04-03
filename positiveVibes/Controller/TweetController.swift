//
//  TweetController.swift
//  positiveVibes
//
//  Created by Beau Enslow on 3/12/24.
//

import UIKit
import SDWebImage
import FirebaseDatabase
import FirebaseAuth

enum UploadTweetConfiguration {
    case tweet
    case reply(Tweet, User)
}

class TweetController: UIViewController{
    
    //MARK: - Properties
    private let user: User
    
    private let config: UploadTweetConfiguration
    
    
    private lazy var postBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setDimensions(width: 64, height: 32)
        button.layer.cornerRadius = 32 / 2
        button.addTarget(self, action: #selector(postPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var profileImg: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .twitterBlue
        iv.setDimensions(width: 50, height: 50)
        iv.layer.cornerRadius = 50 / 2
        iv.layer.masksToBounds = true
        return iv
    }()
    
    private let replyLabel: UILabel = {
        let label = UILabel()
        label.text = "Replying to @Horse"
        label.textColor = .lightGray
        return label
    }()
    
    private var replyBtn: UIButton = {
        let button = UIButton(type: .system)
//        let button = Utilities().replyToBtn(text: "Replying to ", boldText: user.userName, andSelector: #selector(replyBtnPressed))
        return button
    }()
    
    private let line: UIView = {
        let line = UIView()
        line.backgroundColor = .systemGray
        line.setDimensions(width: 1, height: 25)
        return line
    }()
    
    private let captionTextView = CaptionTextView()
    
    //MARK: - Lifecycle
    init(user: User, config: UploadTweetConfiguration){
        self.user = user
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configKeyboard()
    }

    //MARK: - Selector
    
    @objc func postPressed(){
        print("post pressed")
        guard let tweet = captionTextView.text else { return }
        if tweet.isEmpty { //text field validation
            Utilities().presentUIAlert("Use your words... Aka you need to type something.", view: self)
            return
        }
        let configInfo = UploadTweetViewModel(config)
        configInfo.showReplyInfo ? saveReplyTweets() : saveTweets()
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelPressed(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func resignKeyboard(){
        view.endEditing(true)
    }
    
    @objc func replyBtnPressed(){
        let nav = UINavigationController(rootViewController: UserProfileController(user: user))
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    //MARK: - API
    
    func saveTweets(){
        guard let tweet = captionTextView.text else { return }
        TweetService.shared.saveTweet(withText: tweet, andUID: user.uid) { result in
            DispatchQueue.main.async{
                switch result{
                case .success(let success):
                    print(success)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func saveReplyTweets(){
        guard let tweet = captionTextView.text else { return }
        let configInfo = UploadTweetViewModel(config)
        TweetService.shared.saveReplyTweet(withText: tweet, tweetUID: configInfo.tweet!.tweetID, andUID:  configInfo.currentUserUID ?? user.uid) {  result in DispatchQueue.main.async{
                switch result{
                case .success(let success):
                    print(success)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    //MARK: - Helpers
    func configureUI(){
        view.backgroundColor = .vibeTheme1
        configNavBar()
        configProfileImg()
        configTextField()
        
        let configInfo = UploadTweetViewModel(config)
        postBtn.setTitle(configInfo.actionBtnTitle, for: .normal)
        captionTextView.placeHolder.text = configInfo.placeholderText
        configInfo.showReplyInfo ? configReplyInfo() : nil

        guard let profileUrl = URL(string: configInfo.currentUserImg ?? user.profileImgUrl) else { return }
        profileImg.sd_setImage(with: profileUrl)

        
        
    
    }
    
    func configKeyboard(){
        Utilities().keyboardDoneBtn(withTF: captionTextView, doneBtn: #selector(resignKeyboard))
        captionTextView.becomeFirstResponder()
    }
    
    func configNavBar(){
        let btn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        btn.tintColor = .iconBadgeTheme
        navigationItem.leftBarButtonItem = btn
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: postBtn)
        guard let navBar = navigationController?.navigationBar else { return }
        Utilities().changeNavBar(navigationBar: navBar, to: .vibeTheme1)
    }
    
    func configProfileImg(){
        view.addSubview(profileImg)
        profileImg.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 25, paddingLeft: 16)
    }
    
    func configTextField(){
        view.addSubview(captionTextView)
        captionTextView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: profileImg.rightAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 12, paddingRight: 25)
    }
    
    func configReplyInfo(){
        view.addSubview(line)
        line.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 0, paddingLeft: 41) // (imageWidth / 2) + imagePaddingLeft
        replyBtn = Utilities().replyToBtn(text: "Replying to ", boldText: user.userName, andSelector: #selector(replyBtnPressed))
        view.addSubview(replyBtn)
        replyBtn.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 10, paddingLeft: 82)// imageWidth  + imagePaddingLeft + configTextPaddingLeft + CaptionTextViewPaddingLeft
    }
}
