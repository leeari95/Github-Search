//
//  APIProvider.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/05.
//

import Foundation

protocol APIProvider {
    var session: URLSession { get }
    
    func execute(request: URLRequest, completion: @escaping (Result<Data?, Error>) -> Void)
    
    func request<T: APIRequest>(
        _ request: T,
        completion: @escaping (Result<T.Response, Error>) -> Void
    )
    
    func requestList<T: APIRequest>(
        _ request: T,
        completion: @escaping (Result<[T.Response], Error>) -> Void
    )
}
