//
//  RepoCellViewModel.swift
//  Bitpanda
//
//  Created by Laureen Schausberger on 27.02.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import Foundation

final class RepoCellViewModel {
    
    private var repository: Repository!
    
    init(repo: Repository) {
        self.repository = repo
    }
    
    // MARK: - UILabel Texts
    
    func nameText() -> String {
        return repository.name
    }
    
    func fullNameText() -> String {
        return repository.fullName
    }
    
    func descriptionText() -> String {
        return repository.description
    }
    
    func languageText() -> String {
        return repository.language
    }
    
    func licenseText() -> String {
        if repository.license == "" {
            return "None"
            
        } else {
            // only first two worsd of license should be shown
            // otherwise it will be too long
            let words = repository.license.components(separatedBy: " ")
            let license = words.count <= 1 ? words[0] : words[0] + " " + words[1]
            return license
        }
        
    }
}
