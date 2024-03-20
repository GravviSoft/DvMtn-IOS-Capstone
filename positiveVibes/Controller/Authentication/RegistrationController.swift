//
//  RegistrationController.swift
//  positiveVibes
//
//  Created by Beau Enslow on 3/6/24.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class RegistrationController: UIViewController, UITextFieldDelegate {
    
    //MARK: - Properties
    
    private let imgPicker = UIImagePickerController()

    private var profileImg: UIImage?
    
    //!!!: UIView
    private lazy var emailContainer: UIView = {
        let view = Utilities().inputContainerView(with: emailTextField)
        return view
    }()
    
    private lazy var passwordContainer: UIView = {
        let view = Utilities().inputContainerView(with: passwordTextField)
        return view
    }()
    
    private lazy var fullNameContainer: UIView = {
        let view = Utilities().inputContainerView(with: fullNameTextField)
        return view
    }()
    
    private lazy var userNameContainer: UIView = {
        let view = Utilities().inputContainerView(with: userNameTextField)
        return view
    }()
    
    
    //!!!: UITextField
    private let emailTextField:  UITextField = {
        let tf = Utilities().textFieldHelper(withPlaceholder: "Email", selector1: #selector(textFieldDidChange(_:)), selector2: #selector(textFieldDidEndEditing(_:)))
        return tf
    }()
    
    private let passwordTextField:  UITextField = {
        let tf = Utilities().textFieldHelper(withPlaceholder: "Password", selector1: #selector(textFieldDidChange(_:)), selector2: #selector(textFieldDidEndEditing(_:)))
        return tf
    }()
    
    private let fullNameTextField:  UITextField = {
        let tf = Utilities().textFieldHelper(withPlaceholder: "Full Name", selector1: #selector(textFieldDidChange(_:)), selector2: #selector(textFieldDidEndEditing(_:)))
        return tf
    }()
    
    private let userNameTextField:  UITextField = {
        let tf = Utilities().textFieldHelper(withPlaceholder: "User Name", selector1: #selector(textFieldDidChange(_:)), selector2: #selector(textFieldDidEndEditing(_:)))
        return tf
    }()
    
    private lazy var addImageView: UIView = {
       let iv = UIView()
        iv.addSubview(addImgBtn)
        addImgBtn.centerX(inView: iv)
        return iv
    }()
    
    //!!!: UIButton
    private let addImgBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "add_photo"), for: .normal)
        button.tintColor = .iconBadgeTheme
        button.setDimensions(width: 150, height: 150)
        button.addTarget(self, action: #selector(addProfileImage), for: .touchUpInside)
        return button
    }()
    
    private let registerBtn: UIButton = {
        let button = Utilities().loginAndRegisterBtn(withText: "Register", andSelector: #selector(registerBtnPressed))
        return button
    }()
    
    
    private let haveAcctBtn: UIButton = {
        let button = Utilities().authRedirectBtn(text: "Already have account?  ", boldText: "Login", andSelector: #selector(haveAcctBtnPressed))
        return button
    }()
    
    
    //!!!: Custom Error Message
    private let errorView: UIView = {
        let ev = UIView()
        ev.backgroundColor = .red
        let errorBubble = UIImageView()
        errorBubble.image = UIImage(systemName: "bubble.middle.top.fill")
        errorBubble.tintColor = .red
        ev.addSubview(errorBubble)
        errorBubble.anchor(left: ev.leftAnchor, bottom: ev.bottomAnchor, paddingLeft: 20, height: 45)
        return ev
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 0
        return label
    }()
    
    //!!!: Custom Success Labels & Images
    private let emailFieldLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        label.textColor = .iconBadgeTheme
        return label
    }()
    
    private let passwordFieldLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        label.textColor = .iconBadgeTheme
        return label
    }()
    
    private let fullNameFieldLabel: UILabel = {
        let label = UILabel()
        label.text = "Full Name"
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        label.textColor = .iconBadgeTheme
        return label
    }()
    
    private let userNameFieldLabel: UILabel = {
        let label = UILabel()
        label.text = "User Name"
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        label.textColor = .iconBadgeTheme
        return label
    }()
    
    private let emailFieldImg: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    private let passwordFieldImg: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    private let fullNameFieldImg: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    private let userNameFieldImg: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        fullNameTextField.delegate = self
        userNameTextField.delegate = self
        
        //set image picker delegate and allowEditing delegate
        imgPicker.delegate = self
        imgPicker.allowsEditing = true
        
    }
   
    //MARK: - Selectors
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        errorView.removeFromSuperview()// Remove errors when any changes detected
        
        switch textField.placeholder{//show and hide success labels on text change
        case "Email":
            textField.text?.isEmpty == true ? Utilities().hideSuccessLabels(label: emailFieldLabel, image: emailFieldImg) : Utilities().configSuccessLabels(forTextField: emailContainer, label: emailFieldLabel, checkImg: emailFieldImg)
        case "Password":
            textField.text?.isEmpty == true ? Utilities().hideSuccessLabels(label: passwordFieldLabel, image: passwordFieldImg) : Utilities().configSuccessLabels(forTextField: passwordContainer, label: passwordFieldLabel, checkImg: passwordFieldImg)
        case "Full Name":
            textField.text?.isEmpty == true ? Utilities().hideSuccessLabels(label: fullNameFieldLabel, image: fullNameFieldImg) : Utilities().configSuccessLabels(forTextField: fullNameContainer, label: fullNameFieldLabel, checkImg: fullNameFieldImg)
        case "User Name":
            textField.text?.isEmpty == true ? Utilities().hideSuccessLabels(label: userNameFieldLabel, image: userNameFieldImg) : Utilities().configSuccessLabels(forTextField: userNameContainer, label: userNameFieldLabel, checkImg: userNameFieldImg)
        default:
            print("Error")
        }
        //show success green check and title above text field when typing
        
        
//        switch textField.placeholder{
//        case "Email":
//            view.viewWithTag(1)?.isHidden = textField.text!.isEmpty ? true : false
//            view.viewWithTag(2)?.isHidden = textField.text!.isEmpty ? true : false
//        case "Password":
//            view.viewWithTag(6)?.isHidden = textField.text!.isEmpty ? true : false
//            view.viewWithTag(7)?.isHidden = textField.text!.isEmpty ? true : false
//        case "Full Name":
//            view.viewWithTag(11)?.isHidden = textField.text!.isEmpty ? true : false
//            view.viewWithTag(12)?.isHidden = textField.text!.isEmpty ? true : false
//        case "User Name":
//            view.viewWithTag(16)?.isHidden = textField.text!.isEmpty ? true : false
//            view.viewWithTag(17)?.isHidden = textField.text!.isEmpty ? true : false
//        default:
//            print("Error")
//        }
    }
    
    @objc func textFieldDidEndEditing(_ textField: UITextField){
        errorView.removeFromSuperview()
        
        //Hide the error messages after you click out of the textfield
//        switch textField.placeholder{
//        case "Email":
//        for tag in 3...5{
//            view.viewWithTag(tag)?.isHidden = true
//        }
//        case "Password":
//        for tag in 8...10{
//            view.viewWithTag(tag)?.isHidden = true
//        }
//        case "Full Name":
//        for tag in 13...15{
//            view.viewWithTag(tag)?.isHidden = true
//        }
//        case "User Name":
//        for tag in 18...20{
//            view.viewWithTag(tag)?.isHidden = true
//        }
//        default:
//            print("Error")
//        }
    }
    
    @objc func addProfileImage(){
        print("Image pressed")
        present(imgPicker, animated: true, completion: nil)
    }
    
    @objc func registerBtnPressed(){
        print("Register btn pressed")
        guard let image = profileImg else {
            Utilities().presentUIAlert("Please select a profile image.", view: self) //Image validation
            return
        }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullName = fullNameTextField.text else { return }
        if fullName.count == 0 {  //full name validation error
            Utilities().configErrors(forTextField: fullNameContainer, errView: errorView, label: errorLabel, errMsg: "You need to enter your full name.", warnImg: fullNameFieldImg)
//            Utilities().showErrors(withText: "You need to enter your full name.", forView: fullNameContainer, errorTag1: 13)
            return
        }
        guard let userName = userNameTextField.text else { return }
        if userName.count == 0{   //user name validation error
            Utilities().configErrors(forTextField: userNameContainer, errView: errorView, label: errorLabel, errMsg: "You need to enter a user name.", warnImg: userNameFieldImg)
//            Utilities().showErrors(withText: "You need to enter a user name.", forView: userNameContainer, errorTag1: 18)
            return
        }
        
        
        AuthService.shared.registerUser(withEmail: email, password: password, fullName: fullName, userName: userName, image: image) { (result) in
            DispatchQueue.main.async{
                switch result{
                case .success(let success):
                    Utilities().tapRootViewDismissCurrent(withView: self)
                    print(success)
                case .failure(let error):
                    //validation errors coming back from firebase.  Email and password fields only
                    let err = error.localizedDescription
                    if err.contains("email"){
                        Utilities().configErrors(forTextField: self.emailContainer, errView: self.errorView, label: self.errorLabel, errMsg: err, warnImg: self.emailFieldImg)
                    } else {
                        Utilities().configErrors(forTextField: self.passwordContainer, errView: self.errorView, label: self.errorLabel, errMsg: err, warnImg: self.passwordFieldImg)
                    }
                }
            }
            print(result)
        }
    }
    
    @objc func haveAcctBtnPressed(){
        navigationController?.popViewController(animated: true)
    }

    //MARK: - Helpers
    func configureUI(){
        view.backgroundColor = .vibeTheme1
        navigationItem.hidesBackButton = true
        
        view.addSubview(addImageView)
        addImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 175)
        
        let stack = UIStackView(arrangedSubviews: [emailContainer, passwordContainer, fullNameContainer, userNameContainer, registerBtn])
        stack.axis = .vertical
        stack.spacing = 45
        view.addSubview(stack)
        stack.anchor(top: addImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 35, paddingRight: 35)
        
        view.addSubview(haveAcctBtn)
        haveAcctBtn.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingBottom: 35)

    }
}


extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //return edited img selected by user if there is one
        guard let profileImg = info[.editedImage] as? UIImage else { return }
        //assign profileImg to var created at top of file
        self.profileImg = profileImg
        //make the button rounded
        addImgBtn.layer.cornerRadius = 150 / 2
        addImgBtn.layer.masksToBounds = true
        //change the scale aspect and clip to view
        addImgBtn.imageView?.contentMode = .scaleAspectFill
        addImgBtn.imageView?.clipsToBounds = true
        //Add a white border to the image btn
        addImgBtn.layer.borderColor = UIColor.iconBadgeTheme.cgColor
        addImgBtn.layer.borderWidth = 3
        //Change the add image button to be the image the user selects
        addImgBtn.setImage(profileImg.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true, completion: nil)
        
    }
}
