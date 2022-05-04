//
//  APIProvider.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/05.
//

import Foundation

protocol APIProvider {
    var session: URLSession { get }
    func request<T: APIRequest>(
        _ request: T,
        completion: @escaping (Result<T.Response, Error>) -> Void
    )
}
