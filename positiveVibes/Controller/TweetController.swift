//
//  TweetController.swift
//  positiveVibes
//
//  Created by Beau Enslow on 3/12/24.
//

import UIKit
import SDWebImage
import FirebaseDatabase

class TweetController: UIViewController, UIScrollViewDelegate {
    
    //MARK: - Properties
    private let user: User
    
    
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
    
    private let profileImg: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .twitterBlue
        iv.setDimensions(width: 50, height: 50)
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 50 / 2
        return iv
    }()
    
    private let captionTextView = CaptionTextView()
    
//    private let tweetTextField: UITextField = {
//        let tf = UITextField()
//        tf.placeholder = "What's Happening"
//        tf.tintColor = .white
//        return tf
//    }()
    
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.delegate = self
        scroll.contentSize = CGSize(width: self.view.frame.size.width, height: 1000)
        return scroll
    }()
    
    //MARK: - Lifecycle
    init(user: User){
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        captionTextView.becomeFirstResponder()
        configureUI()

    }
    //MARK: - API
    //MARK: - Selector
    
    @objc func postPressed(){
        print("post pressed")
        guard let tweet = captionTextView.text else { return }
        if tweet.isEmpty { //text field validation
            Utilities().presentUIAlert("Use your words... Aka you need to type something.", view: self)
            return
        }
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
        dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelPressed(){
        dismiss(animated: true, completion: nil)
    }
    //MARK: - Helpers
    func configureUI(){
        view.backgroundColor = .vibeTheme1
        
        configNavBar()
        configProfileImg()
        configTextField()
    }
    
    func configNavBar(){
        let btn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        btn.tintColor = .iconBadgeTheme
        navigationItem.leftBarButtonItem = btn
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: postBtn)
    }
    
    func configProfileImg(){
        view.addSubview(profileImg)
        guard let profileUrl = URL(string: user.profileImgUrl) else { return }
        profileImg.sd_setImage(with: profileUrl)
        profileImg.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 25, paddingLeft: 25)
    }
    
    func configTextField(){
        view.addSubview(captionTextView)
        captionTextView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: profileImg.rightAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 12, paddingRight: 25)
    }
}
