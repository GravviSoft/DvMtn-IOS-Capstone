//
//  UserProfileController.swift
//  positiveVibes
//
//  Created by Beau Enslow on 3/22/24.
//

import UIKit

class UserProfileController: UICollectionViewController {
    
    //MARK: - Properties
    private var user: User
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        guard let navBar = navigationController?.navigationBar else { return }
//        Utilities().changeNavBar(navigationBar: navBar, to: .white)
        navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: - Selectors
//    @objc func goBack(){
//        dismiss(animated: true, completion: nil)
//    }
//    
    //MARK: - Helpers
    func configUI(){
        view.backgroundColor = .red
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: K.reuseTweetCellId)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: K.reuseProfileHeader)
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(goBack))
    }
}

//MARK: - UICollectionViewDataSource
extension UserProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.reuseTweetCellId, for: indexPath) as! TweetCell
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension UserProfileController: UserProfileHeaderDelegate {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: K.reuseProfileHeader, for: indexPath) as! ProfileHeader
        header.delegate = self
        header.user = user
        return header
    }
    
    func backBtnPressed() {
        dismiss(animated: true, completion: nil)
    }
}



//MARK: - UICollectionViewFlowLayout
extension UserProfileController: UICollectionViewDelegateFlowLayout {
    //sizeforheader --  THE HEADER
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 375)
    }
    //sizeForItemat for 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 200)
    }
}
