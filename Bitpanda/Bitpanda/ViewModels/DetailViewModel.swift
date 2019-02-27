//
//  DetailViewModel.swift
//  Bitpanda
//
//  Created by Laureen Schausberger on 27.02.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import Foundation

final class DetailViewModel {
    
    private var fullName: String
    private var repository: Repository?
    
    var contributerTableVC: ContributorTableViewController?
    
    init(fullName: String) {
        self.fullName = fullName
    }
    
    // MARK: - UILabel Texts
    
    func nameText() -> String {
        return repository?.name ?? ""
    }
    
    func pathText() -> String {
        return repository?.fullName ?? ""
    }
    
    func forkText() -> String {
        return "\(repository?.forksCount ?? 0)"
    }
    
    func sizeText() -> String {
        return "Size \(repository?.size ?? 0)"
    }
    
    func stargazerText() -> String {
        return "\(repository?.stargazersCount ?? 0)"
    }
    
    func descriptionText() -> String {
        return repository?.description ?? ""
    }
    
    func ownerLoginText() -> String {
        return repository?.owner?.login ?? ""
    }
    
    func ownerUrlText() -> String {
        return repository?.owner?.url ?? ""
    }
    
    // MARK: - Fetching Data
    
    func fetchRepository(completion: @escaping Success) {
        DataHandler.shared.requestRepo(path: fullName) { repo in
            if let repo = repo {
                self.repository = repo
                completion(true)
            } else {
                completion(false)
            }
        }
        
    }
    
    func fetchContributors(completion: @escaping Success) {
        guard let fullName = repository?.fullName else {
            print("DetailViewModel > Repository is nil.")
            completion(false)
            return
        }
        
        DataHandler.shared.requestContributors(forRepo: fullName) { contributors in
            if let contributors = contributors, contributors.count > 0 {
                // set contributorViewModel in list
                let contributorViewModel = ContributorViewModel(contributors: contributors)
                self.contributerTableVC?.viewModel = contributorViewModel
                completion(true)
                
            } else {
                completion(false)
            }
        }
    }
    
    func image(completion: @escaping RetrievedImage) {
        if let url = repository?.owner?.avatarUrl {
            DataHandler.shared.requestImage(forImageUrl: url) { image in
                completion(image)
            }
        } else {
            completion(nil)
        }
        
    }
    
}
