//
//  SearchController.swift
//  positiveVibes
//
//  Created by Beau Enslow on 3/6/24.
//

import UIKit

class SearchController: UIViewController {
    
    //MARK: - Properties
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Selectors
    //MARK: - API
    //MARK: - Helpers
    func configureUI(){
        navigationItem.title = "Search"
    }
}
