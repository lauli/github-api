//
//  Repository.swift
//  Bitpanda
//
//  Created by Laureen Schausberger on 27.02.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import Foundation

final class Repository {
    let name, fullName, description, language: String
    
    var contributersUrl: String?
    var size, stargazersCount, forksCount: Int?
    var owner: User?
    var license: String
    
    init(name: String, fullName: String, description: String, language: String, license: String = "",
         contributersUrl: String? = nil, size: Int? = nil, stargazersCount: Int? = nil, forksCount: Int? = nil, owner: User? = nil) {
        self.name = name
        self.fullName = fullName
        self.description = description
        self.language = language
        self.license = license
        self.contributersUrl = contributersUrl
        self.size = size
        self.stargazersCount = stargazersCount
        self.forksCount = forksCount
        self.owner = owner
    }
    
}
