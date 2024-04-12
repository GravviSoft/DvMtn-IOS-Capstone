//
//  ProfileHeader.swift
//  positiveVibes
//
//  Created by Beau Enslow on 3/23/24.
//

import UIKit

protocol UserProfileHeaderDelegate: AnyObject {
    func backBtnPressed()
    func handleEditFollowBtn(_ text: String)
    func filterTweetList(_ indexPath: Int)
}



class ProfileHeader: UICollectionReusableView {
    
    //MARK: - Properties
    var user: User? {
        didSet{
            configHeader()
        }
    }
    
    
    var isFollowing: Bool? {
        didSet{
            configFollowing()
        }
    }
    
//    var listNum: Int? {
//        didSet{
//            guard let listNum = listNum else { return }
//            delegate?.filterTweetList(listNum)
//        }
//    }
    
    weak var delegate: UserProfileHeaderDelegate?
    
    
    private let filterBar = ProfileFilterBtns()
    
    private lazy var profileImg: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .twitterBlue
        image.setDimensions(width: 80, height: 80)
        image.layer.cornerRadius = 80 / 2
        image.layer.masksToBounds = true
        image.layer.borderColor = UIColor.iconBadgeTheme.cgColor
        image.layer.borderWidth = 3
        return image
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        return view
    }()
    
    private lazy var backBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(backBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    private let editFollowBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.iconBadgeTheme, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(editFollowBtnPressed), for: .touchUpInside)
        button.setDimensions(width: 100, height: 36)
        button.layer.cornerRadius = 36 / 2
        button.layer.borderColor = UIColor.iconBadgeTheme.cgColor
        button.layer.borderWidth = 1.25
        return button
    }()
    
    private let fullName: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()
    
//    private let checkImg: UIView = {
//       let iv = UIView()
//        iv.backgroundColor = .red
//        iv.setDimensions(width: 25, height: 25)
//        let img = UIImageView()
//        img.image = UIImage(systemName: "checkmark.seal.fill", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 18)))?.withTintColor(.twitterBlue)
//        iv.addSubview(img)
//        img.center(inView: iv)
//        return iv
//    }()
    
    private let userName: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        return label
    }()
    
    private let bioText: UILabel = {
        let label = UILabel()
        label.textColor = .iconBadgeTheme
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "This is the bio section for the user, it goes here. This is the bio section for the user, it goes here."
        label.numberOfLines = 3
        return label
    }()
    
    private let bottomLine: UIView = {
        let uv = UIView()
        uv.backgroundColor = .twitterBlue
        return uv
    }()
    
    private lazy var followingLabel: UILabel = {
        let label = UILabel()
//        let tap = UITapGestureRecognizer(target: self, action: #selector(followingPressed))
//        label.addGestureRecognizer(tap)
//        label.isUserInteractionEnabled = true
        return label
    }()
    private lazy var followersLabel: UILabel = {
        let label = UILabel()
//        let tap = UITapGestureRecognizer(target: self, action: #selector(followersPressed))
//        label.addGestureRecognizer(tap)
//        label.isUserInteractionEnabled = true
        return label
    }()
    
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .vibeTheme1
        
        filterBar.delegate = self
        
        addSubview(containerView)
        containerView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 130)
        
        containerView.addSubview(backBtn)
        backBtn.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, paddingTop: 55, paddingLeft: 25)
        
        addSubview(profileImg)
        profileImg.anchor(top: topAnchor, left: leftAnchor, paddingTop: 100, paddingLeft: 16)
        
        addSubview(editFollowBtn)
        editFollowBtn.anchor(top: containerView.bottomAnchor, right: rightAnchor, paddingTop: 12, paddingRight: 16)
                
        let stack = UIStackView(arrangedSubviews: [fullName, userName])
        stack.axis = .vertical
        stack.spacing = 2
        addSubview(stack)
        stack.anchor(top: profileImg.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 20)
        
        addSubview(bioText)
        bioText.anchor(top: stack.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 14, paddingLeft: 16, paddingRight: 20)
        
        let followStack = UIStackView(arrangedSubviews: [followingLabel, followersLabel])
        followStack.axis = .horizontal
        followStack.spacing = 12
        addSubview(followStack)
        followStack.anchor(top: bioText.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 16)


        addSubview(filterBar)
        filterBar.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingBottom: 10, height: 45)
        
//        addSubview(bottomLine)
//        bottomLine.anchor(bottom: bottomAnchor, paddingBottom: 10, width: frame.width / CGFloat(ProfileFilterOptions.allCases.count), height: 2)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func backBtnPressed(){
        delegate?.backBtnPressed()
    }
    
    @objc func editFollowBtnPressed(){
        guard let btnText = editFollowBtn.titleLabel?.text else { return }
        delegate?.handleEditFollowBtn(btnText)
    }
    
    
    //MARK: - Helpers

    func configHeader(){
        guard let user = user else { return }
        
        guard let profileUrl = URL(string: user.profileImgUrl) else { return }
        profileImg.sd_setImage(with: profileUrl)
        
        guard let isFollowing = isFollowing else { return }
        let model = ProfileHeaderViewModel(user: user, isFollowing: isFollowing)
        fullName.text = user.fullName
        followingLabel.attributedText = model.followingLabel
        followersLabel.attributedText = model.followersLabel
        userName.attributedText = model.userNameLabel
        
    }
    
    func configFollowing() {
        guard let user = user else { return }
        guard let isFollowing = isFollowing else { return }
        let model = ProfileHeaderViewModel(user: user, isFollowing: isFollowing)
        editFollowBtn.setTitle(model.editOrFollowBtn, for: .normal)

    }
}



//MARK: - UICollectionViewDelegate
extension ProfileHeader: ProfileFilterBtnLineDelegate {
    func filterView(_ view: ProfileFilterBtns, cv: UICollectionView, didSelect indexPath: IndexPath) {
        delegate?.filterTweetList(indexPath.last ?? 0)

        guard let cell = view.collectionView(cv, cellForItemAt: indexPath) as? ProfileFilterCell else { return }

//        let xPosition = cell.frame.origin.x
//        UIView.animate(withDuration: 0.3){
//            self.bottomLine.frame.origin.x = xPosition
//        }
        
//        listNum = indexPath.last ?? 0

    }

}
