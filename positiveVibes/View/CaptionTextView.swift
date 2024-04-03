//
//  CaptionTextView.swift
//  positiveVibes
//
//  Created by Beau Enslow on 3/13/24.
//

import UIKit

class CaptionTextView: UITextView {
    
    //MARK: - Properties
    var placeHolder: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .lightGray
//        guard let label = UploadTweetViewModel(config: con) else { return }
//        label.text = label.placeholderText
        return label
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        backgroundColor = .vibeTheme1
        
        
        font = UIFont.systemFont(ofSize: 20)
        isScrollEnabled = true
//        heightAnchor.constraint(equalToConstant: 300).isActive = true
        addSubview(placeHolder)
        placeHolder.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 4)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Selectors
    @objc func handleTextInputChange() {
        placeHolder.isHidden = !text.isEmpty
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {

        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        self.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification) {

        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.contentInset = contentInset
    }
    
}
