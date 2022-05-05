//
//  UserResponseDTO.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/05.
//

import Foundation
import UIKit

struct UserResponseDTO: Codable, APIResponse {
    let login: String
    let id: Int
    let nodeId: String
    let avatarURL: String
    let gravatarId: String
    let URL: String
    let htmlURL: String
    let followersURL: String
    let followingURL: String
    let gistsURL: String
    let starredURL: String
    let subscriptionsURL: String
    let organizationsURL: String
    let reposURL: String
    let eventsURL: String
    let receivedEventsURL: String
    let type: String
    let siteAdmin: Bool
    let name: String
    let company: String?
    let blog: String
    let location, email: String
    let hireable: Bool?
    let bio: String
    let twitterUsername: String?
    let publicRepos: Int
    let publicGists: Int
    let followers: Int
    let following: Int
    let createdAt, updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case login, id, type, name, company, blog, location, email, hireable, bio, followers, following
        case URL = "url"
        case nodeId = "node_id"
        case avatarURL = "avatar_url"
        case gravatarId = "gravatar_id"
        case htmlURL = "html_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case gistsURL = "gists_url"
        case starredURL = "starred_url"
        case subscriptionsURL = "subscriptions_url"
        case organizationsURL = "organizations_url"
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case receivedEventsURL = "received_events_url"
        case siteAdmin = "site_admin"
        case twitterUsername = "twitter_username"
        case publicRepos = "public_repos"
        case publicGists = "public_gists"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

extension UserResponseDTO {
    func toDomain() -> User {
        let starredURL = starredURL.components(separatedBy: "{").first ?? ""
        return .init(login: login, name: name, profileImageURL: avatarURL, repoURL: reposURL, starredURL: starredURL)
    }
}
