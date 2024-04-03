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
    
    private var replies = [Tweet]() {
        didSet{
            collectionView.reloadData()
        }
    }
    
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
        fetchReplyTweets()
//        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//           flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize  //Set the autolayout for the collectionview cells
//         }
//        fetchUserTweets()
    }
    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        collectionView.collectionViewLayout.invalidateLayout()
//    }
    
    
    //MARK: - Selectors
    @objc func backBtnPressed(){
        dismiss(animated: true, completion: nil)
    }
    
    

//    //MARK: - API
//    func fetchUserTweets(){
//        TweetService.shared.fetchUserTweets(uid: tweet.user.uid) { tweets in
//            print(tweets)
//        }
//        print("fetchUserTweets")
//    }
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
        let viewModel = TweetViewModel(tweet: replies[indexPath.row])
        let height = viewModel.cellAutoSize(forWidth: view.frame.width).height
        return CGSize(width: collectionView.frame.width, height: height + 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        let header = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: IndexPath(row: 0, section: section)) as! SingleTweetHeader
        let addSize = replies.count > 0 ? CGFloat(80) : CGFloat(200)
        let computedSize = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height + addSize
        collectionView.reloadData()
        return CGSizeMake(view.frame.width, computedSize);
    }
}

//MARK: - UICollectionViewHeader
extension SingleTweetController{
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: K.reuseSnglTwtHeader, for: indexPath) as! SingleTweetHeader
        header.tweet = tweet
        return header
    }    
}
