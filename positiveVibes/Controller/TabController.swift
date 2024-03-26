//
//  TabController.swift
//  positiveVibes
//
//  Created by Beau Enslow on 3/6/24.
//

import UIKit
import FirebaseAuth

class TabController: UITabBarController {
    
    //MARK: - Properties
    var user: User? {
        didSet{
            guard let nav = viewControllers?[0] as? UINavigationController else { return }
            guard let feed = nav.viewControllers.first as? MainFeedController else { return }
            feed.user = user
        }
    }
    
    let tweetBtn: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .twitterBlue
        button.tintColor = .white
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.addTarget(self, action: #selector(tweetBtnPressed), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateUserConfigureUI()
    }
    
    //MARK: - Selectors
    @objc func tweetBtnPressed(){
        print("Btn pressed")
        guard let user = user else { return }
        let nav = UINavigationController(rootViewController: TweetController(user: user))
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    //MARK: - API
    func fetchUser(){
        UserService.shared.fetchUser { user in
            self.user = user
        }
    }
    
    func authenticateUserConfigureUI(){
        Auth.auth().currentUser == nil ? sendUserToLogin() : configureUI()
    }
    
    
    //MARK: - Helpers
    func configureUI(){
        view.backgroundColor = .vibeTheme1
        
        configTabSettings()

        configTabBar()
        
        fetchUser()
        
        view.addSubview(tweetBtn)
        tweetBtn.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 65, paddingRight: 15, width: 60, height: 60)
        tweetBtn.layer.cornerRadius = 60 / 2
        
    }
    
    
    func configTabSettings(){
        //!!!: UITabBar Settings
        UITabBar.appearance().tintColor = .iconBadgeTheme //selected icon color
        UITabBar.appearance().unselectedItemTintColor = .iconBadgeTheme //unselected icon color
        UITabBar.appearance().backgroundColor = .tabBarTheme
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().barTintColor = .vibeTheme1 //UITABBAR COLOR
//        UITabBar.appearance().standardAppearance.compactInlineLayoutAppearance.
//        if #available(iOS 15.0, *) {
//               let appearance = UITabBarAppearance()
//               appearance.configureWithOpaqueBackground()
//               appearance.backgroundColor = .vibeTheme1
//               UITabBar.appearance().standardAppearance = appearance
//               UITabBar.appearance().scrollEdgeAppearance = UITabBar.appearance().standardAppearance
//           }
    }
    
    func configTabBar(){
        //!!!: UITabBar Icons/Controllers
        //Set the tab bar controllers and image icons
        let feedView = MainFeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let feed = Utilities().createTabBarItemImg(withController: feedView, unselectedIcon: "house", selectedIcon: "house.fill")
        let search = Utilities().createTabBarItemImg(withController: SearchController(), unselectedIcon: "magnifyingglass", selectedIcon: "sparkle.magnifyingglass")
        let notifications = Utilities().createTabBarItemImg(withController: NotificationsController(), unselectedIcon: "bell", selectedIcon: "bell.fill")
        let message = Utilities().createTabBarItemImg(withController: MessagesController(), unselectedIcon: "envelope", selectedIcon: "envelope.fill")
        //set as view controllers
        viewControllers = [ feed, search, notifications, message ]
    }
    
    func sendUserToLogin(){
        DispatchQueue.main.async{
            self.view.backgroundColor = .vibeTheme1
            let nav = UINavigationController(rootViewController: LoginController())
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }

}

