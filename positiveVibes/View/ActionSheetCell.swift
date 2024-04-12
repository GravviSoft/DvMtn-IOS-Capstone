//
//  ActionSheetCell.swift
//  positiveVibes
//
//  Created by Beau Enslow on 4/3/24.
//

import UIKit

class ActionSheetCell: UITableViewCell {
    
    //MARK: - Properties
    var options: ActionSheetOptions? {
        didSet{
            configCell()
        }
    }
    
//    var isFollowing = Bool(){
//        didSet{
//           
//        }
//    }
    
    private let logoImg: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "vibeImgTrans")
        image.setDimensions(width: 30, height: 30)
        image.layer.masksToBounds = true
        return image
    }()
    
    private let buttonTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Follow"
        return label
    }()
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .vibeTheme1
        
        let stack = UIStackView(arrangedSubviews:  [logoImg, buttonTitle])
        stack.axis = .horizontal
        stack.spacing = 12
        addSubview(stack)
        stack.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 25)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    //MARK: - Selectors
    //MARK: - Helpers
    
    func configCell(){
        buttonTitle.attributedText = options?.description
        buttonTitle.textColor = options?.description.string == "Delete" ? .red : .iconBadgeTheme
    }
    
}
