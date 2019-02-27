//
//  RepoTableViewModel.swift
//  Bitpanda
//
//  Created by Laureen Schausberger on 27.02.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import Foundation

final class RepoTableViewModel {
    
    // repositories
    private var repositories: [Repository]
    
    init(repos: [Repository]) {
        repositories = repos
    }
    
    var title: String { return "GitHub Repositories" }
    var count: Int { return repositories.count }
    
    func cellViewModelForRepo(ofIndexPath indexPath: IndexPath) -> RepoCellViewModel {
        return RepoCellViewModel(repo: repositories[indexPath.row])
    }
    
    func detailViewModelForRepo(ofIndexPath indexPath: IndexPath) -> DetailViewModel {
        return DetailViewModel(fullName: repositories[indexPath.row].fullName)
    }
    
    func requestAllRepositories(completion: @escaping Success) {
        DataHandler.shared.requestAllRepositories() { newRepos in
            if let newRepos = newRepos {
                self.repositories += newRepos
                completion(true)
                
            } else {
                completion(false)
            }
        }
    }
}
