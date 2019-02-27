//
//  ContributorTableViewController.swift
//  Bitpanda
//
//  Created by Laureen Schausberger on 27.02.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

final class ContributorTableViewController: UITableViewController {
    
    var viewModel: ContributorViewModel? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Overrides
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "contributerCell", for: indexPath) as? ContributorTableViewCell else {
            print("ContributerTableViewController -> repoCell is not of type ContributerTableViewCell.")
            return tableView.dequeueReusableCell(withIdentifier: "contributerCell", for: indexPath)
        }
        
        if let viewModel = viewModel {
            // set viewModel for cell with correct user
            let contributor = viewModel.contributorFor(indexPath: indexPath)
            let contributorCellViewModel = ContributorCellViewModel(user: contributor)
            
            cell.viewModel = contributorCellViewModel
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
}
