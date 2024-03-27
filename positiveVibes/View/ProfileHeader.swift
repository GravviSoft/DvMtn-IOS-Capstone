//
//  ProfileHeader.swift
//  positiveVibes
//
//  Created by Beau Enslow on 3/23/24.
//

import UIKit

protocol UserProfileHeaderDelegate: AnyObject {
    func backBtnPressed()
}

class ProfileHeader: UICollectionReusableView {
    
    //MARK: - Properties
    var user: User?{
        didSet{
            print("This is the user info: \(user)")
            configHeader()
        }
    }
    
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
    
    private lazy var editFollowBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.iconBadgeTheme, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(editFollowBtnPressed), for: .touchUpInside)
//        button.backgroundColor = .systemPink
        button.setDimensions(width: 100, height: 36)
        button.layer.cornerRadius = 36 / 2
        button.layer.borderColor = UIColor.iconBadgeTheme.cgColor
        button.layer.borderWidth = 1.25
        return button
    }()
    
    private let fullName: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.text = "Beau Enslow"
        return label
    }()
    
    private let userName: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "@beauenslow"
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
        let title = NSMutableAttributedString(string: "0", attributes: [.font : UIFont.boldSystemFont(ofSize: 14), .foregroundColor: UIColor.iconBadgeTheme.cgColor])
        title.append(NSAttributedString(string: " Following", attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        label.attributedText = title
       
        let tap = UITapGestureRecognizer(target: self, action: #selector(followingPressed))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        return label
    }()
    private lazy var followersLabel: UILabel = {
        let label = UILabel()
        let title = NSMutableAttributedString(string: "2", attributes: [.font : UIFont.boldSystemFont(ofSize: 14), .foregroundColor: UIColor.iconBadgeTheme.cgColor])
        title.append(NSAttributedString(string: " Followers", attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        label.attributedText = title
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(followersPressed))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
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
        filterBar.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 50)
        
        addSubview(bottomLine)
        bottomLine.anchor(bottom: bottomAnchor, width: frame.width / CGFloat(ProfileFilterOptions.allCases.count), height: 2)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func followingPressed(){
        print("followingPressed")
    }
    
    @objc func followersPressed(){
        print("followersPressed")
    }
    
    @objc func backBtnPressed(){
        delegate?.backBtnPressed()
    }
    @objc func editFollowBtnPressed(){
        print("editFollowBtnPressed")
    }
    
    
    //MARK: - Helpers

    func configHeader(){
        guard let user = user else { return }
        guard let profileUrl = URL(string: user.profileImgUrl) else { return }
        profileImg.sd_setImage(with: profileUrl)
        
        fullName.text = user.fullName
        userName.text = "@\(user.userName)"
        
    }
}



//MARK: - UICollectionViewDelegate
extension ProfileHeader: ProfileFilterBtnLineDelegate{
    func filterView(_ view: ProfileFilterBtns, cv: UICollectionView, didSelect indexPath: IndexPath) {
        guard let cell = view.collectionView(cv, cellForItemAt: indexPath) as? ProfileFilterCell else { return }
        print(indexPath)
        let xPosition = cell.frame.origin.x
        UIView.animate(withDuration: 0.3){
            self.bottomLine.frame.origin.x = xPosition
        }
    }
}
