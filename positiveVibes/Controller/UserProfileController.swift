//
//  UserProfileController.swift
//  positiveVibes
//
//  Created by Beau Enslow on 3/22/24.
//

import UIKit

class UserProfileController: UICollectionViewController {
    
    //MARK: - Properties
    private var user: User {
        didSet{
            collectionView.reloadData()
        }
    }
    

   var mainList = [Tweet](){
        didSet{
            collectionView.reloadData()
        }
    }
    
    var userTweets = [Tweet]() {
        didSet{
            collectionView.reloadData()
        }
    }
    
    var userReplies = [Tweet]() {
        didSet{
            collectionView.reloadData()
        }
    }
    
    
    private var isFollowing = Bool() {
        didSet{
            collectionView.reloadData()
        }
    }
    
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        fetchUserTweets()
        checkFollowing()
        fetchUserReplies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: - Selectors
    
    //MARK: - API
    func fetchUserTweets(){
        TweetService.shared.fetchUserTweets(for: user) { tweets in
            let sorted = tweets.sorted { $0.timestamp > $1.timestamp }  //Newest tweets on top
            self.userTweets = sorted
            self.mainList = sorted
        }
    }
    
    func fetchUserReplies(){
        TweetService.shared.fetchUserReplies(withUser: user, completion: { tweets in
            let sorted = tweets.sorted { $0.timestamp > $1.timestamp }  //Newest tweets on top
            self.userReplies = sorted
        })
    }
    
    
    func checkFollowing(){
        UserService.shared.checkFollowing(uid: user.uid) { result in
            print(result)
            self.isFollowing = result.isFollowing
            self.user.followers = result.followers
            self.user.following = result.following
            print("USER Data: \(self.isFollowing)     Result: \(result)")
            
        }
    }
    
    //MARK: - Helpers
    func configUI(){
//        view.backgroundColor = .red
        collectionView.backgroundColor = .vibeTheme1
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: K.reuseTweetCellId)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: K.reuseProfileHeader)
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
           flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize  //Set the autolayout for the collectionview cells
         }
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(goBack))
    }
}

//MARK: - UICollectionViewDataSource
extension UserProfileController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.reuseTweetCellId, for: indexPath) as! TweetCell
        cell.tweet = mainList[indexPath.row]
        return cell
    }

}

//MARK: - UICollectionViewDelegate
extension UserProfileController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: K.reuseProfileHeader, for: indexPath) as! ProfileHeader
        header.delegate = self
        header.user = user
        header.isFollowing = isFollowing
        return header
    }
}



//MARK: - UICollectionViewFlowLayout
extension UserProfileController: UICollectionViewDelegateFlowLayout {
    //sizeforheader --  THE HEADER
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 395)
    }
    //sizeForItemat for 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 200)
    }
}

//MARK: - ProfileHeaderView Delegate Methods
extension UserProfileController: UserProfileHeaderDelegate {
    func filterTweetList(_ indexPath: Int) {
        print("THIS IS INDEX \(indexPath)")
//        switch indexPath {
//        case 0:
//            allLists.removeAll()
//            allLists = userTweets
//        case 1:
//            allLists.removeAll()
//            allLists = userReplies
//        default:
//            print("THIS IS ERROR \(indexPath)")
//        }
        
        
        let option = ProfileFilterOptions(rawValue: indexPath)
        switch option?.description {
        case "Tweets":
            mainList.removeAll()
            mainList = userTweets
        case "Replies":
            mainList.removeAll()
            mainList = userReplies
        default:
            print("Error")
        }

    }
    
    func handleEditFollowBtn(_ text: String) {
        switch text {
        case "Follow":
            UserService.shared.followUser(uid: user.uid) { result in
                self.isFollowing = true
            }
        case "Following":
            UserService.shared.unfollowUser(uid: user.uid) { result in
                self.isFollowing = false
            }
        case "Edit Profile":
            print("Edit Profile Btn Pressed")
        default:
            print("Error")
        }
    }

    
    func backBtnPressed() {
        dismiss(animated: true, completion: nil)
    }
}



