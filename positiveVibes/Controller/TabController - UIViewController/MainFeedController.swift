//
//  MainFeedController.swift
//  positiveVibes
//
//  Created by Beau Enslow on 3/6/24.


import UIKit
import SDWebImage

//private let reuseIdentifier = "TweetCell"

class MainFeedController: UICollectionViewController{
    
    //MARK: - Properties
    
    var myCollectionView: UICollectionView!
    
    var user: User?{
        didSet{
            print("User did set in feed")
            configProfileImg()
        }
    }
    
    private var tweets = [Tweet]() {
        didSet{ collectionView.reloadData() }
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchTweets()
        

//        let collectionHeight = self.collectionViewLayout.collectionViewContentSize.height

//        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
//           flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//        }
//        cellSizes = myAwesomeCells.map({ _ in return CGSize(width: 200, height: 50) })

    }
    
    //MARK: - Selectors
    @objc func userImgPressed(){
        print("img pressed")
    }
    
    @objc func logUserOut(){
        AuthService.shared.logUserOut(withView: self)
    }
    
    //MARK: - API
    func fetchTweets(){
        TweetService.shared.fetchTweet { tweets in
            print("Number of tweets \(tweets.count)")
            print(tweets)
            self.tweets = tweets
        }
    }
    
    //MARK: - Helpers
    func configureUI(){
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: K.reuseTweetCellId)//register TweetCell
        configNavBar()
        self.collectionView.backgroundColor = .vibeTheme1
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
    
//    func configLine(){
//        let line = UIView()
//        line.backgroundColor = .systemGray
//        addSubview(line)
//        line.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 0.18)
//    }
    
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

extension MainFeedController{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.reuseTweetCellId, for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
}


extension MainFeedController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let msg = tweets[indexPath.row].tweet
        let numLine = Double(msg.numberOfLines()) * 5
        if tweets.count > 0 {
            let setHeight = Utilities().heightForLable(text: msg, width: view.frame.width)
            return CGSize(width: view.frame.width, height:  setHeight + 65)
        }
        
        return CGSize(width: view.frame.width, height:  200 )
    }
    
    //Make sure the screen doesnt resize incorrectly on device rotate
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView?.collectionViewLayout.invalidateLayout()
    }
}


