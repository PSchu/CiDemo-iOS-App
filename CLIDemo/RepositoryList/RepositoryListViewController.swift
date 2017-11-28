//
//  RepositoryListViewController.swift
//  CLIDemo
//
//  Created by Peter Schumacher on 27.11.17.
//  Copyright © 2017 ImagineOn GmbH. All rights reserved.
//

import UIKit

protocol RepositoryListViewControllerViewModel {
    
}

class RepositoryListViewController: UITableViewController {
    typealias ViewModel = RepositoryListViewControllerViewModel
    let viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(style: .plain)
        view.backgroundColor = .blue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}
