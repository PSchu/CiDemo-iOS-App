//
//  RepositoryListViewController.swift
//  CLIDemo
//
//  Created by Peter Schumacher on 27.11.17.
//  Copyright © 2017 ImagineOn GmbH. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import enum Result.NoError

protocol RepositoryCellData {
    var name: String { get }
}

protocol RepositoryListViewControllerViewModel {
    var numberOfSections: Int { get }
    func numberOfItems(in section: Int) -> Int
    func data(for indexPath: IndexPath) -> RepositoryCellData
    var newDataSignal: Signal<Void, NoError> { get }
}

class RepositoryListViewController: UITableViewController {
    class RepositoryTableViewCell: UITableViewCell {
        static let reuseIdentifier = "RepositoryTableViewCell"
    }
    
    typealias ViewModel = RepositoryListViewControllerViewModel
    let viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(style: .plain)
        tableView.register(RepositoryTableViewCell.self, forCellReuseIdentifier: RepositoryTableViewCell.reuseIdentifier)
        
        self.tableView.reactive.reloadData <~ viewModel.newDataSignal
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(in: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryTableViewCell.reuseIdentifier, for: indexPath)
        cell.textLabel?.text = viewModel.data(for: indexPath).name
        return cell
    }
}
