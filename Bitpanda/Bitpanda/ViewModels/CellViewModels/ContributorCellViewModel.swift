//
//  ContributorCellViewModel.swift
//  Bitpanda
//
//  Created by Laureen Schausberger on 27.02.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import Foundation

final class ContributorCellViewModel {
    
    private var user: User
    
    init(user: User) {
        self.user = user
    }
    
    // MARK: - UILabel Texts
    
    func loginLabelText() -> String {
        return user.login
    }
    
    func commitLabelText() -> String {
        return "Total amount of commits: \(user.contribution?.commitCount ?? 0)"
    }
    
    func contributionLabelText() -> String {
        return "Additions: \(user.contribution?.additions ?? 0), Deletions: \(user.contribution?.deletions ?? 0)"
    }
    
    func perWeekLabel() -> String {
        // round to two places after 0
        let addPerWeek = String(format: "%.2f", user.contribution?.additionsPerWeek ?? 0.0)
        let delPerWeek = String(format: "%.2f", user.contribution?.deletionsPerWeek ?? 0.0)
        return "Add/Week: \(addPerWeek), Del/Week: \(delPerWeek)"
    }
    
    // MARK: - Fetching Data
    
    func image(completion: @escaping RetrievedImage) {
        DataHandler.shared.requestImage(forImageUrl: user.avatarUrl) { image in
            completion(image)
        }
    }
}

