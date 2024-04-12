//
//  ActionSheetLauncher.swift
//  positiveVibes
//
//  Created by Beau Enslow on 4/3/24.
//

import UIKit


class ActionSheetLauncher: NSObject {
    
    //MARK: - Properties
    
    private var user: User
    
    private var isFollowing = Bool()
    
    private let tableView = UITableView()
    
    private var window: UIWindow?
    
    private let tableRowHeight = CGFloat(60)
    
    private lazy var numOfOptions = CGFloat(viewModel.options.count + 1)
    
    private lazy var tableHeight = (tableRowHeight * numOfOptions) + 50
    
    private lazy var viewModel = ActionSheetViewModel(user: user, isFollowing: isFollowing) {
        didSet{
            tableView.reloadData()
        }
    }
        
    private lazy var blackView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissBlackView))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var footerView: UIView = {
        let view = UIView()
        view.backgroundColor = .vibeTheme1
        view.addSubview(cancelBtn)
        cancelBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelBtn.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 10, paddingRight: 10)
        cancelBtn.centerY(inView: view, leftAnchor: view.leftAnchor)
        cancelBtn.layer.cornerRadius = 50 / 2
        return view
    }()
    
    private lazy var cancelBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Cancel", for: .normal)
        btn.backgroundColor = .iconBadgeTheme
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.tintColor = .vibeTheme1
        btn.addTarget(self, action: #selector(cancelBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    init(user: User){
        self.user = user
        super.init()
    }
    //MARK: - Selectors
    @objc func dismissBlackView(){
        print("dismissBlackView")
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.tableView.frame.origin.y += self.tableHeight
        }
    }
    
    @objc func cancelBtnPressed(){
        print("cancelBtnPressed")
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.tableView.frame.origin.y += self.tableHeight
        }
    }
    
//    //MARK: - API
    func checkFollowing(){
        UserService.shared.checkFollowing(uid: user.uid) { result in
//            self.viewModel = ActionSheetViewModel(user: self.user, isFollowing: result.isFollowing)
            print("result.isFollowing \(result.isFollowing)")
            self.user.following = result.following
            self.user.followers = result.followers
            self.isFollowing = result.isFollowing
            self.viewModel = ActionSheetViewModel(user: self.user, isFollowing: result.isFollowing)

        }
    }
    
    
    //MARK: - Helpers
    func show() {
        configTableView()
        checkFollowing()
        print("Action sheet launcher for \(user.userName)")
//        guard let firstWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let firstWindow = windowScene.windows.first(where: {$0.isKeyWindow}) else { return }
        self.window = firstWindow
        
        firstWindow.addSubview(blackView)
        blackView.frame = firstWindow.frame
        
        firstWindow.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: firstWindow.frame.height, width: firstWindow.frame.width, height: tableHeight)
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 1
            self.tableView.frame.origin.y -= self.tableHeight
        }
    }
    
//    func checkFollowing(){
//        UserService.shared.checkFollowing(uid: user.uid) { result in
//            self.isFollowing = result.isFollowing
//            print("USER Data: \(self.isFollowing)     Result: \(result)")
//        }
//    }
    
    func configTableView(){
        tableView.backgroundColor = .vibeTheme1
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = tableRowHeight
        tableView.layer.cornerRadius = 5
//        tableView.separatorStyle = .none
        tableView.register(ActionSheetCell.self, forCellReuseIdentifier: K.reuseActionSheetCell)
    }
}


//MARK: - UITableViewDelegate & Datasource
extension ActionSheetLauncher: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.reuseActionSheetCell, for: indexPath) as! ActionSheetCell
        cell.options = viewModel.options[indexPath.row]
        return cell
    }
}


//MARK: - UITableView Footer
extension ActionSheetLauncher: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableRowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.options.first {
        case .follow(let user):
            print("Followfollow")
            UserService.shared.followUser(uid: user.uid) { result in
                self.isFollowing = true
                self.viewModel = ActionSheetViewModel(user: user, isFollowing: true)
            }
        case .unfollow(let user):
            UserService.shared.unfollowUser(uid: user.uid) { result in
                self.isFollowing = false
                self.viewModel = ActionSheetViewModel(user: user, isFollowing: false)
            }
        case .delete:
                print("DELETEDELTE")
        default:
            print("Error")
        }

    }
}
