//
//  MainFeedController.swift
//  positiveVibes
//
//  Created by Beau Enslow on 3/6/24.


import UIKit
import SDWebImage


class MainFeedController: UICollectionViewController  {
        
    //MARK: - Properties
    
//    var myCollectionView: UICollectionView!
//    guard let user = user else { return }
    private lazy var actionLauncher = ActionSheetLauncher(user: user ?? User(uid: "", user: ["": ""]))
    
    var user: User?{
        didSet{
            print("User did set in feed")
            configProfileImg()
        }
    }
    
    private var refreshUser = ""
    
    private var tweets = [Tweet]() {
        didSet{ collectionView.reloadData() }
    }
    

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchTweets()
        print("VIEW DID LOAD")
        
    }
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        print("ViewWILL APPREAR")
        fetchTweetFollowing()
    }
    
    //MARK: - Selectors
    @objc func userImgPressed(){
        guard let user = user else { return }
        let nav = UINavigationController(rootViewController: UserProfileController(user: user))
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @objc func logUserOut(){
        AuthService.shared.logUserOut(withView: self)
    }
    
    //MARK: - API
    func fetchTweets(){
        TweetService.shared.fetchTweet { tweets in
            let sorted = tweets.sorted { $0.timestamp > $1.timestamp }  //Newest tweets on top
            self.tweets = sorted
        }
    }
    
    func fetchTweetFollowing(){
        print("fetchTweetFollowing")
        TweetService.shared.fetchTweet { tweets in
            DispatchQueue.main.async{
                let sorted = tweets.sorted { $0.timestamp > $1.timestamp }  //Newest tweets on top
                for (index, _) in self.tweets.enumerated() {
                    if self.tweets.count == sorted.count{
//                        self.tweets[index].followInfo?.isFollowing = sorted[index].followInfo!.isFollowing
                        self.tweets[index].followInfo? = sorted[index].followInfo!
                    }
                }
            }
        }
    }
    
    //MARK: - Helpers
    func configureUI(){
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: K.reuseTweetCellId)//register TweetCell
        configNavBar()
        collectionView.backgroundColor = .vibeTheme1
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait //disable device rotation
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
           flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize  //Set the autolayout for the collectionview cells
         }

    }
    
    func configProfileImg(){
        guard let user = user else { return }
        guard let getUrlFromUserImgString = URL(string: user.profileImgUrl) else { return }
        let image = UIImageView()
        image.setDimensions(width: 40, height: 40)
        image.sd_setImage(with: getUrlFromUserImgString)
        image.layer.cornerRadius = 40 / 2
        image.layer.masksToBounds = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: image)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(userImgPressed))
        image.addGestureRecognizer(tap)
        image.isUserInteractionEnabled = true
        
    }
    
    
    func configNavBar(){
        let image = UIImageView(image: UIImage(named: "vibeImgTrans"))
        image.contentMode = .scaleAspectFit
        image.setDimensions(width: 38, height: 38)
        navigationItem.titleView = image
//        navigationController.back
//        navigationController?.navigationBar.backgroundColor = .vibeTheme1 //here...
//        if #available(iOS 15, *) {
//            UINavigationBar.appearance().scrollEdgeAppearance = UINavigationBarAppearance()
//        }
        guard let navBar = navigationController?.navigationBar else { return }
        Utilities().changeNavBar(navigationBar: navBar, to: .vibeTheme1)
        let button = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logUserOut))
        button.tintColor = .iconBadgeTheme
        navigationItem.rightBarButtonItem = button
    }
    
    
    
}

extension MainFeedController  {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.reuseTweetCellId, for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
//        cell.tweetIcons = tweetIcons[indexPath.row]
        cell.delegate = self
        return cell
    }

    
}


//extension MainFeedController: UICollectionViewDelegate {
//    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
//
//        let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { (_) in
//            print(indexPath.row)
//         }
//        let like = UIAction(title: "Like", image: UIImage(systemName: "heart")) { (_) in
//            print(indexPath.row)
//
//        }
//        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { _ in
//            return UIMenu(title: "Options", children: [like, delete])
//        })
//
//
//    }
//}

//MARK: - UICollectionViewFlowLayout
extension MainFeedController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 200)
    }
}


extension MainFeedController: MainFeedControllerCellDelegate{
    func handleReport(_ cell: TweetCell) {
        guard let tweet = cell.tweet else { return }
        Utilities().presentUIAlert("Reported @\(tweet.user.userName)", view: self)
    }
    
    func handleDeleteTweet(_ cell: TweetCell) {
        guard let tweet = cell.tweet else { return }
        print("Delete \(tweet.user.userName)")
        TweetService.shared.deleteTweet(tweet: tweet) { result in
            DispatchQueue.main.async{
                switch result {
                case .success(let success):
                    print(success)
                    guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
                    print("indexPath \(indexPath)")
                    self.tweets.remove(at: indexPath.last!)
                case .failure(let error):
                    Utilities().presentUIAlert("\(error.localizedDescription)", view: self)
                }
            }
        }
    }
    
    func handleFollow(_ cell: TweetCell) {
        guard let tweet = cell.tweet else { return }
        UserService.shared.followUser(uid: tweet.user.uid) { result in
            DispatchQueue.main.async{
                for (index, tweetInfo) in self.tweets.enumerated() {
                    print("\(tweetInfo.user.uid) == \(tweet.user.uid)")
                    if tweetInfo.user.uid == tweet.user.uid{
                        self.tweets[index].followInfo?.isFollowing = true
                    }
                }
            }
        }
    }
    
    func handleUnfollow(_ cell: TweetCell) {
        guard let tweet = cell.tweet else { return }
        UserService.shared.unfollowUser(uid: tweet.user.uid) { result in
            DispatchQueue.main.async{
                for (index, tweetInfo) in self.tweets.enumerated() {
                    print("\(tweetInfo.user.uid) == \(tweet.user.uid)")
                    if tweetInfo.user.uid == tweet.user.uid{
                        self.tweets[index].followInfo?.isFollowing = false
                    }
                }
            }
        }
    }
    
    func handleBookMarkBtn(_ cell: TweetCell) {
        guard let tweet = cell.tweet else { return }
        cell.tweet?.followInfo?.didBookmark.toggle()
        TweetService.shared.bookmarkTweet(tweet: tweet) { bookmark in
            DispatchQueue.main.async{
                guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
                print("indexPath \(indexPath)")
                self.tweets[indexPath.last!].followInfo?.didBookmark = bookmark
            }
        }
    }
    
    func handleRetweetBtn(_ cell: TweetCell) {
        guard let tweet = cell.tweet else { return }
        cell.tweet?.followInfo?.didRetweet.toggle()
        TweetService.shared.reTweet(tweet: tweet) { count, retweet in
            DispatchQueue.main.async{
                print("count = \(count)  retweet = \(retweet) ")
                guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
                print("indexPath \(indexPath)")
                self.tweets[indexPath.last!].followInfo?.didRetweet = retweet
                self.tweets[indexPath.last!].retweetCount = count
            }
        }
    }
    
    func handleLikeBtn(_ cell: TweetCell) {
        guard let tweet = cell.tweet else { return }
        cell.tweet?.followInfo?.didLike.toggle()
        TweetService.shared.likeTweet(tweet: tweet) { count, likes in
            DispatchQueue.main.async{
                print("count = \(count)  likes = \(likes) ")
                guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
                print("indexPath \(indexPath)")
                self.tweets[indexPath.last!].followInfo?.didLike = likes
                self.tweets[indexPath.last!].likes = count
            }
        }
    }
    
    
    
    func feedActionLauncher(_ tweet: Tweet) {
//        actionLauncher = ActionSheetLauncher(user: tweet.user)
//        actionLauncher.show()
        
//        @objc func openTapped() {
//        let title = tweet.user.isCurrentUser ? "Edit Profile" : ( tweet.followInfo?.isFollowing ?? false ? "Following" : "Follow")
//        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        ac.addAction(UIAlertAction(title:  "Delete", style: .default, handler: deleteTweet))
//        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
////        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
//        present(ac, animated: true)
//        
//        func deleteTweet(action: UIAlertAction) {
//            print("Tweet deleted")
//        }

    }
    
    
    func commentBtnPressedSegue(_ tweet: Tweet) {
        guard let user = user else { return }
        let nav = UINavigationController(rootViewController: TweetController(user: tweet.user, config: .reply(tweet, user)))
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func infoLabelPressedSegue(_ tweet: Tweet) {
        guard let user = user else { return }
        let nav = UINavigationController(rootViewController: SingleTweetController(tweet: tweet, user: user))
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
        
    }
    
    func userProfImgPressSegue(_ cell: TweetCell)  {
        guard let user = cell.tweet?.user else { return }
        let nav = UINavigationController(rootViewController: UserProfileController(user: user))
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
}

