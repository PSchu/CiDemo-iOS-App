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
    var data: Property<[RepositoryCellData]> { get }
    var title: String { get }
    func setFilter(_ filter: RepositoryFilter?)
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
        title = viewModel.title
        tableView.register(RepositoryTableViewCell.self, forCellReuseIdentifier: RepositoryTableViewCell.reuseIdentifier)
        
        self.tableView.reactive.reloadData <~ viewModel.data.signal.skip(while: { $0.isEmpty } ).map( { _ in ()} )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(showFilterOptions))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func showFilterOptions() {
        let sheet = UIAlertController(title: "Filter", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(alertAction(for: .notForked))
        sheet.addAction(alertAction(for: .hasWiki))
        sheet.addAction(alertAction(for: .hasPages))
        sheet.addAction(alertAction(for: nil))
        present(sheet, animated: true, completion: nil)
    }
    
    func alertAction(for repFilter: RepositoryFilter?) -> UIAlertAction {
        return UIAlertAction(title: repFilter?.title ?? "No Filter", style: UIAlertActionStyle.default, handler: { [viewModel] _ in
            viewModel.setFilter(repFilter)
        })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryTableViewCell.reuseIdentifier, for: indexPath)
        cell.textLabel?.text = viewModel.data.value[indexPath.item].name
        return cell
    }
}
