//
//  SingleTweetController.swift
//  positiveVibes
//
//  Created by Beau Enslow on 3/22/24.
//

import UIKit


class SingleTweetController: UICollectionViewController {
    
    
    //MARK: - Properties
    private var tweet: Tweet {
        didSet{
            collectionView.reloadData()
            actionSheetLauncher = ActionSheetLauncher(user: tweet.user)
            actionSheetLauncher.delegate = self
            print("actionSheetLauncher change: \(actionSheetLauncher)")
        }
    }
    
    private var user: User
    
    private lazy var actionSheetLauncher = ActionSheetLauncher(user: tweet.user)
    
    private var replies = [Tweet]() {
        didSet{
            collectionView.reloadData()
        }
    }
    
    private var isFollowing = Bool() {
        didSet{
            collectionView.reloadData()
//            self.actionSheetLauncher.isFollowing = isFollowing
//            print("isFollowing \(isFollowing)")
        }
    }
    
    private lazy var followingLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    private lazy var followersLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    //MARK: - Lifecycle
    init(tweet: Tweet, user: User) {
        self.tweet = tweet
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        fetchReplyTweets()
        checkFollowing()
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
           flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize  //Set the autolayout for comments collectionview cells
         }
//        fetchUserTweets()
    }
    
    
    //MARK: - Selectors
    @objc func backBtnPressed(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "backBtnPressed"), object: nil)
        Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false) { timer in // give time to save data and update UI properly
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    

   //MARK: - API
    func checkFollowing(){
        UserService.shared.checkFollowing(uid: tweet.user.uid) { result in
            self.tweet.user.followers = result.followers
            self.tweet.user.following = result.following
            self.isFollowing = result.isFollowing
        }
    }
    func fetchReplyTweets(){
        TweetService.shared.fetchReplyTweets(tweetUID: tweet.tweetID) { result in
            self.replies = result
        }
    }
    
    
    //MARK: - Helpers
    func configUI(){
        collectionView.backgroundColor = .vibeTheme1
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: K.reuseTweetCellId)
        collectionView.register(SingleTweetHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: K.reuseSnglTwtHeader)
        configNavBar()
        
    }
    
    func configNavBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backBtnPressed)) // left
        navigationItem.leftBarButtonItem?.tintColor = .iconBadgeTheme
    
        navigationItem.title = "Post"  //center
    }
}



//MARK: - UICollectionViewDataSource - TweetCell
extension SingleTweetController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return replies.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.reuseTweetCellId, for: indexPath) as! TweetCell
        cell.tweet = replies[indexPath.row]
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout 
//Height and width for collectionviews
extension SingleTweetController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let viewModel = TweetViewModel(tweet: replies[indexPath.row])
//        let height = viewModel.cellAutoSize(forWidth: view.frame.width).height
//        return CGSize(width: collectionView.frame.width, height: height + 80)
        return CGSize(width: collectionView.frame.width, height: 200)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        

            // First Method
            let indexPath = IndexPath(row: 0, section: section)
            let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath) as! SingleTweetHeader
            // Use this view to calculate the optimal size based on the collection view's width
            return headerView.systemLayoutSizeFitting(CGSize(width: view.frame.width, height: UIView.layoutFittingExpandedSize.height),
                                                        withHorizontalFittingPriority: .required, // Width is fixed
                                                        verticalFittingPriority: .fittingSizeLevel)
                
        
//        -------------
//        let header = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: IndexPath(row: 0, section: section)) as! SingleTweetHeader
//        if replies.count > 0 {
//            return header.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
//                                                  withHorizontalFittingPriority: .required, // Width is fixed
//                                                        verticalFittingPriority: .fittingSizeLevel)
//        }
        
        //Second Method
//        let vm = SingleTweetViewModel(tweet: tweet)
//        let height = vm.headerAutoSize(forWidth: collectionView.frame.width - 40).height + 310
//        return CGSize(width: collectionView.frame.width, height: height)
   
        
//        let header = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: IndexPath(row: 0, section: section)) as! SingleTweetHeader
//        let addSize = replies.count > 0 ? CGFloat(80) : CGFloat(200)
//        let computedSize = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height + addSize
//        return CGSizeMake(view.frame.width, computedSize);
//        
//        return CGSize(width: collectionView.frame.width, height: 200)
    }
}

//MARK: - UICollectionViewHeader
extension SingleTweetController{
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: K.reuseSnglTwtHeader, for: indexPath) as! SingleTweetHeader
        header.tweet = tweet
        header.delegate = self
        print(replies.count)
        header.commentCount = replies.count
        return header
    }    
}


//MARK: - SingleTweetHeaderDelegate
extension SingleTweetController: SingleTweetHeaderDelegate, ActionSheetDeleteDelegate{
    func handleReportTweet() {
        Utilities().presentUIAlert("Reported @\(tweet.user.userName)", view: self)
    }
    
    func handleDeleteTweet() {
        Utilities().presentDeleteAlert(withTweet: tweet, view: self)
    }
    
    func handleSingleComment(_ tweet: Tweet) {
        let nav = UINavigationController(rootViewController: TweetController(user: tweet.user, config: .reply(tweet, user)))
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func handleSingleLike(_ tweet: Tweet) {
        TweetService.shared.likeTweet(tweet: tweet) { count, likes in
            DispatchQueue.main.async{
                print("count = \(count)  likes = \(likes) ")
                self.tweet.followInfo?.didLike = likes
                self.tweet.likes = count
            }
        }
    }
    
    func handleSingleRetweet(_ tweet: Tweet) {
        TweetService.shared.reTweet(tweet: tweet) { count, retweet in
            DispatchQueue.main.async{
                print("count = \(count)  retweet = \(retweet) ")
                self.tweet.followInfo?.didRetweet = retweet
                self.tweet.retweetCount = count
            }
        }
    }
    
    func handleSingleBookMark(_ tweet: Tweet) {
        TweetService.shared.bookmarkTweet(tweet: tweet) { bookmark in
            DispatchQueue.main.async{
                self.tweet.followInfo?.didBookmark = bookmark
            }
        }
    }
    
    
    func showTweetUserProf() {
        let nav = UINavigationController(rootViewController: UserProfileController(user: tweet.user))
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func showActionSheet() {
        actionSheetLauncher.show()
    }
    
}
