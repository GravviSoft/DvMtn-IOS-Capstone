//
//  CaptionTextView.swift
//  positiveVibes
//
//  Created by Beau Enslow on 3/13/24.
//

import UIKit

class CaptionTextView: UITextView {
    
    let placeHolder: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .lightGray
        label.text = "What's Happening?"
        return label
    }()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        backgroundColor = .vibeTheme1
        
        
        font = UIFont.systemFont(ofSize: 20)
        isScrollEnabled = true
        addSubview(placeHolder)
        placeHolder.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 4)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleTextInputChange() {
        placeHolder.isHidden = !text.isEmpty
    }
}
