//
//  Contribution.swift
//  Bitpanda
//
//  Created by Laureen Schausberger on 27.02.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import Foundation

final class Contribution {
    let additions, deletions, commitCount: Int
    let additionsPerWeek, deletionsPerWeek: Double
    
    init(additions: Int, deletions: Int, commitCount: Int,
         additionsPerWeek: Double, deletionsPerWeek: Double) {
        self.additions = additions
        self.deletions = deletions
        self.commitCount = commitCount
        self.additionsPerWeek = additionsPerWeek
        self.deletionsPerWeek = deletionsPerWeek
    }
    
}
