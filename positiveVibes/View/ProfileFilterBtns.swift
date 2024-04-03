//
//  ProfileFilterBtns.swift
//  positiveVibes
//
//  Created by Beau Enslow on 3/25/24.
//

import UIKit

protocol ProfileFilterBtnLineDelegate: AnyObject {
    func filterView(_ view: ProfileFilterBtns, cv: UICollectionView, didSelect indexPath: IndexPath)

}



class ProfileFilterBtns: UIView {
    //MARK: - Properties
    weak var delegate: ProfileFilterBtnLineDelegate?
//    let labelCount = ProfileFilterOptions.allCases.count

    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .vibeTheme1
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    //MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        

//        backgroundColor = .vibeTheme1
        collectionView.register(ProfileFilterCell.self, forCellWithReuseIdentifier: K.reuseProFilterCell)
        
        //make it so the first cell is selected
        let selectedCell = IndexPath(row: 0, section: 0)
        collectionView.selectItem(at: selectedCell, animated: true, scrollPosition: .left)
        
        addSubview(collectionView)
        collectionView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Selectors
    //MARK: - Helpers
}

//MARK: - UICollectionViewDataSource
extension ProfileFilterBtns: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(ProfileFilterOptions.allCases.count)
        return ProfileFilterOptions.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.reuseProFilterCell, for: indexPath) as! ProfileFilterCell
        let option = ProfileFilterOptions(rawValue: indexPath.row)
        cell.titleOption = option
        print(option?.description ?? "")
        print("OPtions\(option?.rawValue ?? 0)")
//        listDelegate?.filterGetIndex(option?.rawValue ?? 0)
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension ProfileFilterBtns: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.filterView(self, cv: collectionView, didSelect: indexPath)

    }
}



//MARK: - UICollectionViewDelegateFlowLayout
extension ProfileFilterBtns: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width /  CGFloat(ProfileFilterOptions.allCases.count), height: frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
