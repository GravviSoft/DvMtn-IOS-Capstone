//
//  LoginController.swift
//  positiveVibes
//
//  Created by Beau Enslow on 3/6/24.
//

import UIKit

class LoginController: UIViewController, UITextFieldDelegate{
    
    //MARK: - Properties
    
    private lazy var logoImg: UIImageView = {
        let iv = UIImageView()
        iv.heightAnchor.constraint(lessThanOrEqualToConstant: 175).isActive = true
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = UIImage(named: "vibeImage")
        return iv
    }()
    
    private let needAcctBtn: UIButton = {
        let button = Utilities().authRedirectBtn(text: "Dont have an account? ", boldText: "Register", andSelector: #selector(needAcctBtnPressed))
        return button
    }()
    
    private lazy var emailContainer: UIView = {
        let view = Utilities().inputContainerView(with: emailTextField)
        return view
    }()
    
    private lazy var passwordContainer: UIView = {
        let view = Utilities().inputContainerView(with: passwordTextField)
        return view
    }()
    
    private let emailTextField:  UITextField = {
        let tf = Utilities().textFieldHelper(withPlaceholder: "Email", selector1: #selector(textFieldDidChange(_:)), selector2: #selector(textFieldDidEndEditing(_:)))
        return tf
    }()
    
    private let passwordTextField:  UITextField = {
        let tf = Utilities().textFieldHelper(withPlaceholder: "Password", selector1: #selector(textFieldDidChange(_:)), selector2: #selector(textFieldDidEndEditing(_:)))
        return tf
    }()
    
    private let loginBtn: UIButton = {
        let button = Utilities().loginAndRegisterBtn(withText: "Log In", andSelector: #selector(loginBtnPressed))
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
    
    private let emailFieldImg: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    private let passwordFieldImg: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    //MARK: - Selectors
    
    @objc func keyboardNxtBtnEmail(){
        passwordTextField.becomeFirstResponder()
    }
    
    @objc func keyboardNxtBtnPass(){
        emailTextField.becomeFirstResponder()
    }
    
    @objc func resignKeyboard(){
        view.endEditing(true)
    }
   
    @objc func textFieldDidBeginEditing(_ textField: UITextField) { //Keyboard code
        switch textField.placeholder{
        case "Email":
            Utilities().keyboardBtns(withTF: textField, nextBtn: #selector(keyboardNxtBtnEmail), doneBtn: #selector(resignKeyboard))
        case "Password":
            Utilities().keyboardBtns(withTF: textField, nextBtn: #selector(keyboardNxtBtnPass), doneBtn: #selector(resignKeyboard))
        default:
            print("Error")
        }

    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        errorView.removeFromSuperview()// Remove errors when any changes detected
        
        switch textField.placeholder{
        case "Email":
            textField.text?.isEmpty == true ? Utilities().hideSuccessLabels(label: emailFieldLabel, image: emailFieldImg) : Utilities().configSuccessLabels(forTextField: emailContainer, label: emailFieldLabel, checkImg: emailFieldImg)
        case "Password":
            textField.text?.isEmpty == true ? Utilities().hideSuccessLabels(label: passwordFieldLabel, image: passwordFieldImg) : Utilities().configSuccessLabels(forTextField: passwordContainer, label: passwordFieldLabel, checkImg: passwordFieldImg)
        default:
            print("Error")
        }
    }
    
    @objc func textFieldDidEndEditing(_ textField: UITextField){
        errorView.removeFromSuperview()  //Remove errors by click out of the textfield or press return
    }
    
    @objc func loginBtnPressed(){
        print("Login btn pressed")
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        AuthService.shared.logUserIn(withEmail: email, password: password) { result in
            DispatchQueue.main.async{
                switch result{
                case .success(_):
                    Utilities().tapRootViewDismissCurrent(withView: self)
                case .failure(let error):
                    print(error)
                    let err = error.localizedDescription
                    if err.contains("email"){
                        Utilities().configErrors(forTextField: self.emailContainer, errView: self.errorView, label: self.errorLabel, errMsg: err, warnImg: self.emailFieldImg)
                    } else {
                        Utilities().configErrors(forTextField: self.passwordContainer, errView: self.errorView, label: self.errorLabel, errMsg: err, warnImg: self.passwordFieldImg)
                    }
                }
            }
        }
    }
    
    @objc func needAcctBtnPressed(){
        print("Need account btn pressed")
        navigationController?.pushViewController(RegistrationController(), animated: true)
    }
    
    //MARK: - API
    //MARK: - Helpers
    
    func configureUI(){
        view.backgroundColor = .vibeTheme1
           
        view.addSubview(logoImg)
        logoImg.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
    
        let stack = UIStackView(arrangedSubviews: [emailContainer, passwordContainer, loginBtn])
        stack.spacing = 45
        stack.axis = .vertical
        view.addSubview(stack)
        stack.anchor(top: logoImg.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 35, paddingRight: 35)

        view.addSubview(needAcctBtn)
        needAcctBtn.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingBottom: 35)
        
    }
    
}



