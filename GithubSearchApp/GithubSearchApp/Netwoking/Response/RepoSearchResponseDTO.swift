//
//  RepoSearchResponseDTO.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/05.
//

import Foundation

// MARK: - RepoSearchResponseDTO
struct RepoSearchResponseDTO: Codable, APIResponse {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [ItemResponseDTO]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items = "items"
    }
}

// MARK: - ItemResponseDTO
struct ItemResponseDTO: Codable, APIResponse {
    let id: Int
    let nodeId: String
    let name: String
    let itemPrivate: Bool
    let owner: OwnerResponseDTO
    let htmlUrl: String
    let itemDescription: String?
    let fork: Bool
    let url: String
    let statusesUrl: String
    let languagesUrl: String
    let stargazersUrl: String
    let createdAt: String
    let updatedAt: String
    let pushedAt: String
    let stargazersCount: Int
    let watchersCount: Int
    let language: String?
    let forksCount: Int
    let archived: Bool
    let disabled: Bool
    let topics: [String]
    let visibility: String
    let forks: Int
    let watchers: Int
    let score: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case nodeId = "node_id"
        case name = "name"
        case itemPrivate = "private"
        case owner = "owner"
        case htmlUrl = "html_url"
        case itemDescription = "description"
        case fork = "fork"
        case url = "url"
        case statusesUrl = "statuses_url"
        case languagesUrl = "languages_url"
        case stargazersUrl = "stargazers_url"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case pushedAt = "pushed_at"
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case language = "language"
        case forksCount = "forks_count"
        case archived = "archived"
        case disabled = "disabled"
        case topics = "topics"
        case visibility = "visibility"
        case forks = "forks"
        case watchers = "watchers"
        case score = "score"
    }
}

extension ItemResponseDTO {
    func toDomain() -> RepositoryItem {
        .init(id: id, name: name, login: owner.login, description: itemDescription ?? "", isMarkStar: false, starredCount: stargazersCount)
    }
}

// MARK: - LicenseResponseDTO
struct LicenseResponseDTO: Codable, APIResponse {
    let key: String
    let name: String
    let url: String
    let spdxId: String
    let nodeId: String
    let htmlUrl: String
    
    enum CodingKeys: String, CodingKey {
        case key = "key"
        case name = "name"
        case url = "url"
        case spdxId = "spdx_id"
        case nodeId = "node_id"
        case htmlUrl = "html_url"
    }
}

// MARK: - OwnerResponseDTO
struct OwnerResponseDTO: Codable, APIResponse {
    let login: String
    let avatarUrl: String
    let url: String
    let htmlUrl: String
    let gistsUrl: String
    let starredUrl: String
    let reposUrl: String
    let type: String
    let siteAdmin: Bool

    enum CodingKeys: String, CodingKey {
        case login = "login"
        case avatarUrl = "avatar_url"
        case url = "url"
        case htmlUrl = "html_url"
        case gistsUrl = "gists_url"
        case starredUrl = "starred_url"
        case reposUrl = "repos_url"
        case type = "type"
        case siteAdmin = "site_admin"
    }
}
