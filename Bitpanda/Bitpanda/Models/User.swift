//
//  User.swift
//  Bitpanda
//
//  Created by Laureen Schausberger on 27.02.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import Foundation

final class User {
    let login, url, avatarUrl: String
    var contribution: Contribution?
    
    init(login: String, url: String, avatarUrl: String, contribution: Contribution? = nil) {
        self.login = login
        self.url = url
        self.avatarUrl = avatarUrl
        self.contribution = contribution
    }
}
