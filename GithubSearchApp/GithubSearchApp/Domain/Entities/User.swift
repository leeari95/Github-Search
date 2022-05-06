//
//  User.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/05.
//

import Foundation

struct User {
    let login: String
    let name: String
    let profileImageURL: String
    let repoURL: String
    let starredURL: String
    
    func path(url: String) -> String {
        let path = url.components(separatedBy: "users/").last ?? ""
        return path
    }
}
