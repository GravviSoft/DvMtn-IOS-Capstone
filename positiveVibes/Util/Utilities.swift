//
//  Utilities.swift
//  positiveVibes
//
//  Created by Beau Enslow on 3/6/24.
//

import UIKit

class Utilities {
    
    //TABCONTROLLER
    func createTabBarItemImg(withController controller: UIViewController, unselectedIcon: String, selectedIcon: String) -> UINavigationController{
        let controller = controller
        controller.tabBarItem.image = UIImage(systemName: unselectedIcon)
        controller.tabBarItem.selectedImage = UIImage(systemName: selectedIcon)
        
        let navBar = UINavigationController(rootViewController: controller)
        navBar.navigationBar.isTranslucent = true
        return navBar
    }
    
    
    func configSuccessLabels(forTextField container: UIView, label: UILabel, checkImg: UIImageView){
        container.addSubview(label)
        label.anchor(top: container.topAnchor, left: container.leftAnchor)
        
        checkImg.image = UIImage(systemName: "checkmark.circle.fill")
        checkImg.tintColor = .systemGreen
        checkImg.setDimensions(width: 25, height: 25)
        container.addSubview(checkImg)
        checkImg.anchor(bottom: container.bottomAnchor, right: container.rightAnchor, paddingBottom: 10)
    }
    
    func hideSuccessLabels(label: UILabel, image: UIImageView){
        label.removeFromSuperview()
        image.removeFromSuperview()
    }
    
    
    func configErrors(forTextField container: UIView, errView: UIView, label: UILabel, errMsg: String, warnImg: UIImageView){
            container.addSubview(errView)
            errView.anchor(top: container.bottomAnchor, left: container.leftAnchor, right: container.rightAnchor, paddingTop: 8, height: 35)
            errView.addSubview(label)
            label.text = errMsg
            label.anchor(top: errView.topAnchor, left: errView.leftAnchor, bottom: errView.bottomAnchor, right: errView.rightAnchor, paddingTop: 5, paddingLeft: 8, paddingBottom: 5)
            
            warnImg.tintColor = .red
            warnImg.image = UIImage(systemName: "exclamationmark.circle.fill")
        
    }
    
    //LOGIN AND REGISTRATION VIEWS
    func inputContainerView(with textField: UITextField) -> UIView {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.tintColor = .iconBadgeTheme

        view.addSubview(textField)
        textField.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingBottom: 10)
        
        let lineView = UIView()
        lineView.backgroundColor = .iconBadgeTheme
        view.addSubview(lineView)
        lineView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, height: 0.75)
        return view
    }
    
    
    func textFieldHelper(withPlaceholder placeholder: String, selector1 selector_1: Selector, selector2 selector_2: Selector ) -> UITextField {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.iconBadgeTheme]
            )
        tf.textColor = .twitterBlue
        tf.returnKeyType = .next
//        tf.addTarget(self, action: next, for: .touchUpInside)
        tf.addTarget(self, action: selector_1, for: .editingChanged)
        tf.addTarget(self, action: selector_2, for: .editingDidEndOnExit)
//        tf.addTarget(self, action: selector_3, for: .ed)

        return tf
    }
    
    func loginAndRegisterBtn(withText text: String, andSelector selector: Selector)-> UIButton{
        let button = UIButton(type: .system)
        button.backgroundColor = .iconBadgeTheme
        button.setTitle(text, for: .normal)
        button.tintColor = .vibeTheme1
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
    
    func authRedirectBtn(text str: String, boldText boldStr: String, andSelector selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        let textTitle = NSMutableAttributedString(string: str, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.iconBadgeTheme])
        textTitle.append(NSAttributedString(string: boldStr, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.iconBadgeTheme]))
        button.setAttributedTitle(textTitle, for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
    
    func replyToBtn(text str: String, boldText boldStr: String, andSelector selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        let textTitle = NSMutableAttributedString(string: str, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textTitle.append(NSAttributedString(string: "@\(boldStr)", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.twitterBlue]))
        button.setAttributedTitle(textTitle, for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
    
    func tapRootViewDismissCurrent(withView view: UIViewController){
        //Step 1: Tap into rootviewcontroller
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let firstWindow = window.windows.first else { return }
        guard let tab = firstWindow.rootViewController as? TabController else { return }
        //Step 2: Perform configureUI func from inside TabController
        tab.configureUI()
        //Step 3: Dismiss current view
        view.dismiss(animated: true, completion: nil)
    }
    
    func reloadCollectViewOnDismiss(withView view: UIViewController, cvController: UICollectionViewController){
        //Step 1: Tap into rootviewcontroller
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let firstWindow = window.windows.first else { return }
        guard let tab = firstWindow.rootViewController as? TabController else { return }
        //Step 2: Perform configureUI func from inside TabController
        tab.configureUI()
        //Step 3: Dismiss current view
        view.dismiss(animated: true, completion: nil)
    }

    func presentUIAlert(_ error: String, view: UIViewController){
        let alertController = UIAlertController(title: nil, message: error, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default) { (action) in
        }
        alertController.addAction(dismissAction)
        view.present(alertController, animated: true)
    }
    
    func presentDeleteAlert(withTweet tweet: Tweet, view: UICollectionViewController){
        let alertController = UIAlertController(title: "Confirm Delete", message: "Are you sure you want to delete?", preferredStyle: .alert)
        // create a cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        // add the cancel action to the alertController
        alertController.addAction(cancelAction)
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .destructive) { (action) in
            TweetService.shared.deleteTweet(tweet: tweet) { result in
                DispatchQueue.main.async{
                    switch result {
                    case .success(let success):
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "backBtnPressed"), object: nil)
                        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in // give time to delete data and update UI
                            view.dismiss(animated: true, completion: nil)
                        }
                    case .failure(let error):
                        Utilities().presentUIAlert("\(error.localizedDescription)", view: view)
                    }
                }
            }
        }
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        view.present(alertController, animated: true)
    }
    
    func changeNavBar(navigationBar: UINavigationBar, to color: UIColor) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = color
        navigationBar.standardAppearance = appearance;
        navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
    }
//font:UIFont,
    func heightForLable(text:String, width:CGFloat) -> CGFloat {
        // pass string, font, LableWidth
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
//                                                    CGFloat.greatestFiniteMagnitude))
//        let label:UILabel = UILabel(frame: CGRect(x: 72, y: CGFloat.greatestFiniteMagnitude, width: width - 72, height: CGFloat.greatestFiniteMagnitude))

         label.numberOfLines = 0
         label.lineBreakMode = .byWordWrapping
//         label.lineBreakMode = NSLineBreakMode.byWordWrapping
         label.text = text
         label.sizeToFit()
    
        
        return label.bounds.size.height
    }
    
    func cellAutoSize(withText text: String, forWidth width: CGFloat) -> CGSize{
        let measureLabel = UILabel(frame: CGRect(x: 72, y: CGFloat.greatestFiniteMagnitude, width: width - 72, height: CGFloat.greatestFiniteMagnitude))
//        let measureLabel = UILabel()
        measureLabel.text = text
        measureLabel.numberOfLines = 0
        measureLabel.lineBreakMode = .byWordWrapping
        measureLabel.translatesAutoresizingMaskIntoConstraints  = false
        measureLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        return measureLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
    func keyboardBtns(withTF tf: UITextField, nextBtn nextSelector: Selector, doneBtn doneSelector: Selector){
        let keyboardToolbar = UIToolbar(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 44.0)))
        keyboardToolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
            target: nil, action: nil)
        let down = UIBarButtonItem(image: UIImage(systemName: "chevron.down"), style: .plain, target: self, action:  nextSelector)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
            target: self, action: doneSelector)
        keyboardToolbar.items = [flexibleSpace, down, doneButton]
        tf.inputAccessoryView = keyboardToolbar
    }
    
    func keyboardDoneBtn(withTF tv: UITextView, doneBtn doneSelector: Selector){
        let keyboardToolbar = UIToolbar(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 44.0)))
        keyboardToolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
            target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
            target: self, action: doneSelector)
        keyboardToolbar.items = [flexibleSpace, doneButton]
        tv.inputAccessoryView = keyboardToolbar
    }
    
     func animateIcon(_ btn: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            btn.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                btn.transform = .identity
            }
        }
    }
    
    
}

extension String {
    
    func numberOfLines() -> Int {
        return self.numberOfOccurrencesOf(string: "\n") + 1
    }

    func numberOfOccurrencesOf(string: String) -> Int {
        return self.components(separatedBy:string).count - 1
    }
}
