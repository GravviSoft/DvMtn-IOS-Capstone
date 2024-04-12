//
//  ProfileFilterCell.swift
//  positiveVibes
//
//  Created by Beau Enslow on 3/25/24.
//

import UIKit

class ProfileFilterCell: UICollectionViewCell {
    //MARK: - Properties
    var titleOption: ProfileFilterOptions?{
        didSet{
            titleLabel.text = titleOption?.description
        }
    }
    
    private let titleLabel: UILabel = {
        let labels = UILabel()
        labels.text = "Test Text"
        labels.textColor = .lightGray
        return labels
    }()
    
    private let bottomLine: UIView = {
        let uv = UIView()
        uv.backgroundColor = .vibeTheme1
        return uv
    }()
    
    override var isSelected: Bool {
        didSet{
            titleLabel.font = isSelected ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 16)
            titleLabel.textColor = isSelected ? .twitterBlue : .lightGray
            bottomLine.backgroundColor = isSelected ? .twitterBlue : .vibeTheme1

        }
    }
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = .vibeTheme1
        addSubview(titleLabel)
        
        titleLabel.center(inView: self)
        
        addSubview(bottomLine)
        bottomLine.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
}
