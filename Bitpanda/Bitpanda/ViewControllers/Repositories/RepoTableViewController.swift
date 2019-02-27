//
//  RepoTableViewController.swift
//  Bitpanda
//
//  Created by Laureen Schausberger on 27.02.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

final class RepoTableViewContoller: UITableViewController {
    
    private let datahandler = DataHandler.shared
    private var isLoading = false
    
    var viewModel: RepoTableViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.prefetchDataSource = self
        setupLayout()
    }
    
    // MARK: - Overrides
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath) as? RepoTableViewCell else {
            print("RepoTableViewContoller -> repoCell is not of type RepoTableViewCell.")
            return tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath)
        }
        
        cell.viewModel = viewModel.cellViewModelForRepo(ofIndexPath: indexPath)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailsViewController = segue.destination as? DetailViewController, let cell = sender as? RepoTableViewCell else {
            return
        }
        
        let repoIndex = tableView.indexPath(for: cell)
        detailsViewController.viewModel = viewModel.detailViewModelForRepo(ofIndexPath: repoIndex!)
    }
    
    // MARK: - Private Custom
    
    private func setupLayout() {
        self.navigationItem.title = viewModel.title
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 120
        self.tableView.separatorColor = UIColor(red: 1, green: 0.5, blue: 0, alpha: 0.4)
    }
}

extension RepoTableViewContoller: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if !isLoading, indexPaths.first?.row ?? 0 >= viewModel.count-5 {
            isLoading = true
            
            viewModel.requestAllRepositories() { success in
                if success {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                self.isLoading = false
            }
        }
    }
    
}
