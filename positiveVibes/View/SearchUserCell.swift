//
//  SearchCell.swift
//  positiveVibes
//
//  Created by Beau Enslow on 3/29/24.
//

import UIKit

class SearchUserCell: UITableViewCell {
    
    //MARK: - Properties
    var user: User? {
        didSet{
            configUserCell()
        }
    }
    private lazy var profileImg: UIImageView = {
       let img = UIImageView()
        img.setDimensions(width: 48, height: 48)
        img.layer.cornerRadius = 48 / 2
        img.layer.masksToBounds = true
        return img
    }()
    
    private let fullName: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .iconBadgeTheme
        return label
    }()
    
    private let userName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .vibeTheme1
        
        addSubview(profileImg)
        profileImg.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        let labelStack = UIStackView(arrangedSubviews: [fullName, userName])
        labelStack.axis = .vertical
        labelStack.spacing = 2
        addSubview(labelStack)
        labelStack.centerY(inView: self, leftAnchor: profileImg.rightAnchor, paddingLeft: 12)

//        widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")

    }
    //MARK: - Helpers
    func configUserCell(){
        guard let user = user else { return }
        let url = URL(string: user.profileImgUrl)
        profileImg.sd_setImage(with: url)
        
        fullName.text = user.fullName
        userName.text = "@\(user.userName)".lowercased()
        
    }
    
}
