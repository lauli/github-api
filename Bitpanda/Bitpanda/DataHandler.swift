//
//  DataHandler.swift
//  Bitpanda
//
//  Created by Laureen Schausberger on 27.02.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

// global data types
typealias Success = (Bool) -> ()
typealias RetrievedImage = (UIImage?) -> ()
typealias RetrievedRepos = ([Repository]?) -> ()

final class DataHandler {
    
    // singleton
    static let shared: DataHandler = DataHandler()
    
    // counter for fetching more
    private var pageCounter = 1
    
    // data types
    typealias Success = (Bool) -> ()
    typealias RetrievedRepo = (Repository?) -> ()
    typealias RetrievedContributors = ([User]?) -> ()
    
    func requestAllRepositories(completion: @escaping RetrievedRepos) {
        
        guard let url = URL(string: "https://api.github.com/search/repositories?q=language:swift&page=\(pageCounter)") else {
            print("DataHandler > requestAllRepositories > String couldn't be translated into URL.")
            completion([])
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("DataHandler > requestAllRepositories > Couldn't fetch any data from URL.")
                print(error?.localizedDescription as Any)
                completion([])
                return
            }
            
            guard let items = self.jsonDecodingForRepos(from: data)["items"] as? [Any] else {
                print("DataHandler > requestAllRepositories > returned value for 'items' doesn't conform to [Any].")
                completion([])
                return
            }
            
            var repositories: [Repository] = []
            
            for item in items {
                if let repository = self.decodeBasicRepositoryInfo(from: item) {
                    repositories.append(repository)
                }
            }
            completion(repositories)
            self.pageCounter += 1
        }
        
        dataTask.resume()
    }
    
    func requestRepo(path: String, completion: @escaping RetrievedRepo) {
        
        guard let url = URL(string: "https://api.github.com/repos/" + path) else {
            print("DataHandler > requestRepo > String couldn't be translated into URL.")
            completion(nil)
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("DataHandler > requestRepo > Couldn't fetch any data from URL.")
                print(error?.localizedDescription as Any)
                completion(nil)
                return
            }
            let jsonData = self.jsonDecodingForRepos(from: data)
            let repo = self.decodeAdvancedRepositoryInfo(from: jsonData)
            
            completion(repo)
        }
        
        dataTask.resume()
    }
    
    func requestImage(forImageUrl url: String, completion: @escaping RetrievedImage) {
        let dataTask = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            guard let data = data, error == nil else {
                print("DataHandler > requestImage() image downloader, data or response nil for url: \(url).")
                completion(nil)
                return
            }
            
            if let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }
        dataTask.resume()
    }
    
    func requestContributors(forRepo fullName: String, completion: @escaping RetrievedContributors) {
        let urlString = "https://api.github.com/repos/" + fullName + "/stats/contributors"
        print(urlString)
        
        guard let url = URL(string: urlString) else {
            print("DataHandler > requestContributors > String couldn't be translated into URL.")
            completion(nil)
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("DataHandler > requestContributors > Couldn't fetch any data from URL.")
                print(error?.localizedDescription as Any)
                completion(nil)
                return
            }
            
            var contributors: [User] = []
            
            for jsonItem in self.jsonDecodingForContributers(from: data) {
                
                guard let item = jsonItem as? [String: Any],
                    let commitCount = item["total"] as? Int,
                    let weeks = item["weeks"] as? [Any],
                    let contributor = item["author"] as? [String: Any],
                    let contributorObject = self.decodeContributor(from: contributor, totalCommits: commitCount, weeks: weeks) else {
                        print("DataHandler > requestContributors > Contributor list contains wrong types or misses values.")
                        completion(nil)
                        return
                }
                contributors.append(contributorObject)
            }
            //sort based on contribution
            contributors.sort(by: { $0.contribution?.commitCount ?? 0 > $1.contribution?.commitCount ?? 0 })
            completion(contributors)
        }
        
        dataTask.resume()
    }
    
    // MARK: - Decoding
    
    private func jsonDecodingForRepos(from data: Data) -> [String: Any] {
        do {
            guard let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                print(try JSONSerialization.jsonObject(with: data, options: .allowFragments))
                print("DataHandler > jsonDecodingForRepos > Data is either empty, or doesn't conform to [String: Any].")
                return [:]
            }
            return jsonData
            
        } catch let error {
            print("DataHandler > jsonDecodingForRepos > Decoding error: " + error.localizedDescription)
            return [:]
        }
    }
    
    func jsonDecodingForContributers(from data: Data) -> [Any] {
        do {
            guard let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Any] else {
                print(try JSONSerialization.jsonObject(with: data, options: .allowFragments))
                print("DataHandler > jsonDecodingForContributers > Data is either empty, or doesn't comform to [Any].")
                return []
            }
            
            return jsonData
            
        } catch let error {
            print("DataHandler > jsonDecodingForContributers > Decoding error: " + error.localizedDescription)
            return []
        }
    }
    
    private func decodeBasicRepositoryInfo(from item: Any) -> Repository? {
        
        guard let repo = item as? [String: Any] else {
            print("DataHandler > decodeBasicRepositoryInfo > Item of Repo doesn't conform to [String: Any].")
            return nil
        }
        
        guard let name = repo["name"] as? String,
            let fullName = repo["full_name"] as? String,
            let description = repo["description"] as? String,
            let language = repo["language"] as? String else {
                print("DataHandler > decodeBasicRepositoryInfo > Repo Information contains wrong types or misses values.")
                return nil
        }
        
        let repository = Repository(name: name, fullName: fullName, description: description, language: language)
        
        if let license = repo["license"] as? [String: Any],
            let licenseName = license["name"] as? String {
            repository.license = licenseName
        }
        
        return repository
    }
    
    private func decodeAdvancedRepositoryInfo(from item: Any) -> Repository? {
        
        let repo = decodeBasicRepositoryInfo(from: item)
        
        guard let data = item as? [String: Any] else {
            print("DataHandler > decodeAdvancedRepositoryInfo > Item of Repo doesn't conform to [String: Any].")
            return nil
        }
        
        guard let contributersUrl = data["contributors_url"] as? String,
            let size = data["size"] as? Int,
            let stargazersCount = data["stargazers_count"] as? Int,
            let forksCount = data["forks_count"] as? Int,
            let owner = data["owner"] as? [String: Any] else {
                print("DataHandler > decodeAdvancedRepositoryInfo >  Repo Information contains wrong types or misses values.")
                return nil
        }
        
        repo?.contributersUrl = contributersUrl
        repo?.size = size
        repo?.stargazersCount = stargazersCount
        repo?.forksCount = forksCount
        repo?.owner = decodeUser(from: owner)
        
        return repo
    }
    
    private func decodeUser(from data: [String: Any]) -> User? {
        guard let ownerLogin = data["login"] as? String,
            let ownerUrl = data["url"] as? String,
            let ownerAvatarUrl = data["avatar_url"] as? String else {
                print("DataHandler > decodeUser > User Information contains wrong types or misses values.")
                return nil
        }
        
        return User(login: ownerLogin, url: ownerUrl, avatarUrl: ownerAvatarUrl)
    }
    
    func decodeContributor(from data: [String: Any], totalCommits: Int, weeks: [Any]) -> User? {
        var additionsTotal = 0
        var deletionsTotal = 0
        
        for weekItem in weeks {
            if let week = weekItem as? [String: Any],
                let additions = week["a"] as? Int,
                let deletions = week["d"] as? Int {
                additionsTotal += additions
                deletionsTotal += deletions
            }
        }
        
        let contribution = Contribution(additions: additionsTotal, deletions: deletionsTotal, commitCount: totalCommits,
                                        additionsPerWeek: Double(additionsTotal) / Double(weeks.count),
                                        deletionsPerWeek: Double(deletionsTotal) / Double(weeks.count))
        
        if let user = decodeUser(from: data) {
            user.contribution = contribution
            return user
            
        } else {
            return nil
        }
    }
    
}

