//
//  Authentication.swift
//  positiveVibes
//
//  Created by Beau Enslow on 3/9/24.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class AuthService {
    
    static let shared = AuthService()
    
    func logUserIn(withEmail email: String, password: String, completion: @escaping (Result<String, Error>) -> ()){
        print(email, password)
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error{
                completion(.failure(error))
                return
            }
            completion(.success("User logged in successfully"))
        }
    }
    
    func registerUser(withEmail email: String, password: String, fullName: String, userName: String, image: UIImage?,  completion: @escaping (Result<String, Error>)->()){
        
        //image data
        guard let imageData = image?.jpegData(compressionQuality: 0.3) else { return }
        let filename = NSUUID().uuidString
        
        //create a storage image bucket called profile images
        let storageRef = Storage.storage().reference().child("profile_images").child(filename)
        
        storageRef.putData(imageData, metadata: nil) { (meta, error) in
            print(error?.localizedDescription as Any)
            storageRef.downloadURL { (url, error) in
                print(error?.localizedDescription as Any)
                guard let profileImgUrl = url?.absoluteString else { return }
                
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    //if there was an error print the error.
                    if let error = error{
                        completion(.failure(error))
                        print("Error: \(error.localizedDescription)")
                        return
                    }
                    //if there was no error when user hits sign up button then save their uid unique number into a variable.
                    guard let uid = result?.user.uid else { return }
                    
                    //put all the form data except for password and image into a dictionary, we need that to pass to firebase to save.
                    let values = ["email": email, "fullname": fullName, "username": userName.lowercased(), "profileImgUrl": profileImgUrl]
                    
                    //Database.database().reference() means reference the urls firebase gave use when we created the database.
                    Database.database().reference().child("users").child(uid).updateChildValues(values) { (error, ref)  in
                    }
                    completion(.success("Registered User, Nice work champ"))
                }
            }
        }
    }
    
    
    func logUserOut(withView view: UIViewController){
        do{
            try Auth.auth().signOut()
            print("User logged out")
        }catch{
            print("Error signing out: \(error.localizedDescription)")
        }
        DispatchQueue.main.async{
            view.view.backgroundColor = .vibeTheme1
            let nav = UINavigationController(rootViewController: LoginController())
            nav.modalPresentationStyle = .fullScreen
            view.present(nav, animated: true, completion: nil)
        }
    }
    
}
