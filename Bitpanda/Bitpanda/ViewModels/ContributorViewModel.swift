//
//  ContributorViewModel.swift
//  Bitpanda
//
//  Created by Laureen Schausberger on 27.02.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import Foundation

final class ContributorViewModel {
    
    private var contributors: [User] = []
    var count: Int { return contributors.count }
    
    init(contributors:  [User]) {
        self.contributors = contributors
    }
    
    func contributorFor(indexPath: IndexPath) -> User {
        return contributors[indexPath.row]
    }
    
}
