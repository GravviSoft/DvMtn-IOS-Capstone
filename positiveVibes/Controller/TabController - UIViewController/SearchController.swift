//
//  SearchController.swift
//  positiveVibes
//
//  Created by Beau Enslow on 3/6/24.
//

import UIKit

class SearchController: UITableViewController {
    
    //MARK: - Properties
    private var user = [User](){
        didSet{ tableView.reloadData()}
    }
    
    private var filterUsers = [User]() {
        didSet{ tableView.reloadData() }
    }
    
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fethAllUsers()
        configSearchController()
    }
    
    //MARK: - Selectors
    //MARK: - API
    func fethAllUsers(){
        UserService.shared.fetchAllUsers { users in
            self.user = users
        }
    }
    
    //MARK: - Helpers
    func configureUI(){
        navigationItem.title = "Search"
        tableView.register(SearchUserCell.self, forCellReuseIdentifier: K.reuseSearchUserCell)
        tableView.rowHeight = 60
        tableView.backgroundColor = .vibeTheme1

//        tableView.separatorStyle = .none
    }
    
    func configSearchController(){
        searchController.searchResultsUpdater = self //delegate
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for user..."
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
}

//MARK: - UISearchResultsUpdating Delegate
extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text  else { return }
        filterUsers = user.filter({ $0.userName.localizedCaseInsensitiveContains(text) || $0.fullName.localizedCaseInsensitiveContains(text)})
        print("THe search bar text: \(text)")
    }
}


//MARK: - UITableViewController DataSource
extension SearchController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filterUsers.count : user.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.reuseSearchUserCell, for: indexPath) as! SearchUserCell
        cell.user = inSearchMode ? filterUsers[indexPath.row] : user[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        let userData = inSearchMode ? filterUsers[indexPath.last ?? 0] : user[indexPath.last ?? 0]
        let nav = UINavigationController(rootViewController: UserProfileController(user: userData))
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
}
